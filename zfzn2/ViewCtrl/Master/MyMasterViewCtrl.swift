//
//  MyMasterViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/15.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//


import UIKit

class MyMasterViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_tableMaster: UITableView!
    var m_nDeleteListFoot:Int!
    var m_viewLoading:SCLAlertView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false//保证对齐顶端，去除的话，会在上部留出空白
        m_tableMaster.register(MyMasterCell.self, forCellReuseIdentifier: "myMasterCell")
        m_tableMaster.register(UINib(nibName: "MyMasterCell", bundle: nil), forCellReuseIdentifier: "myMasterCell")
        m_tableMaster.bounces = false//不需要弹簧效果
        m_tableMaster.tableFooterView = UIView()//隐藏多余行
//        m_tableMaster.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        m_tableMaster.reloadData()//修改数据返回时处理这个
//        m_tableMaster.estimatedRowHeight
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            print("从我的主机界面返回到侧边栏界面")
        })
    }
    
    @IBAction func OnAdd(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "addMasterViewCtrl") as! AddMasterViewCtrl
        nextView.m_bFirstAdd = false
        self.navigationController?.pushViewController(nextView , animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gDC.mUserList.count
    }
    
    //每行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myMasterCell", for: indexPath) as! MyMasterCell
        cell.m_labelMasterName.text = gDC.mUserList[indexPath.row].m_sUserName
        if gDC.mUserList[indexPath.row].m_sUserName == gDC.mUserInfo.m_sUserName {//说明是活动主机
            cell.m_labelMasterStatus.text = "已连接"
        }else {
            cell.m_labelMasterStatus.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            if gDC.mUserList[indexPath.row].m_sMasterCode != gDC.mUserInfo.m_sMasterCode {
                alertView.addButton("设为当前主机", action: {
                    () -> Void in
                    self.SetCurrentUser(indexPath.row)
                })
            }
            alertView.addButton("编辑", action: {
                () -> Void in
                let sb = UIStoryboard(name: "Main", bundle:nil)
                let nextView = sb.instantiateViewController(withIdentifier: "editMasterViewCtrl") as! EditMasterViewCtrl
                nextView.m_nUserListFoot = indexPath.row
                self.navigationController?.pushViewController(nextView , animated: true)
            })
//            if gDC.mUserList[indexPath.row].m_sMasterCode != gDC.mUserInfo.m_sMasterCode {
            alertView.addButton("删除", action: {//需要有一个
                () -> Void in
                let appearance2 = SCLAlertView.SCLAppearance(showCloseButton: true)
                let alertView2 = SCLAlertView(appearance: appearance2)
                alertView2.addButton("确定", action: {
                    () -> Void in
                    let webReturn = MyWebService.sharedInstance.DeleteUser(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserList[indexPath.row].m_sMasterCode)
                    self.m_nDeleteListFoot = indexPath.row
                    if gDC.mUserList[indexPath.row].m_sMasterCode != gDC.mUserInfo.m_sMasterCode {
                        self.WebDeleteUser(webReturn, isCurrentUser: false)
                    }else{
                        self.WebDeleteUser(webReturn, isCurrentUser: true)
                    }
                })
                alertView2.showInfo("提示", subTitle: "请问您是否确认删除该主机", duration: 0)//时间间隔为0时不会自动退出
            })
//            }
            alertView.showInfo("菜单", subTitle: "请选择您需要的操作", duration: 0)//时间间隔为0时不会自动退出
        })
        tableView.deselectRow(at: indexPath, animated: false)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func WebDeleteUser(_ responseValue:String, isCurrentUser:Bool) {
        switch responseValue {
        case "1":
            ShowInfoDispatch("提示", content: "删除成功", duration: 0.5)
            gDC.mUserData.DeleteUserByFoot(m_nDeleteListFoot)
            if isCurrentUser == true {//删除的是当前使用的账户
                if gDC.mUserList.count>0 {//如果还有主机的话，则自动跳转到默认的第一个主机
                    self.SetCurrentUser(0)
                }else {//如果只剩下最后一个主机的话，则直接跳转回登录界面
                    MyWebService.sharedInstance.StopPolling()
                    WebSocket.sharedInstance.CloseWebSocket()
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
            m_tableMaster.reloadData()
        default:
            ShowNoticeDispatch("提示", content: "未知的错误", duration: 0.5)
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func SetCurrentUser(_ index:Int) {
        gDC.mUserInfo = gDC.mUserList[index]//TODO：gDC.mUserList这里的时间值都是空的
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            self.m_viewLoading = SCLAlertView(appearance: appearance)
            self.m_viewLoading.showInfo("提示", subTitle: " 正在加载用户数据......", duration: 0)
        })
        //开始各种读取工作
        LoadDataFromWeb()
        //重新刷新区域界面
        gDC.m_bRefreshAreaList = true
        gDC.m_nSelectAreaSequ = 0
        //切换不同的主机时，重置默认的登录主机
        UpdateAccountPlistData()
        self.m_viewLoading.hideView()
        m_tableMaster.reloadData()
//        g_notiCenter.postNotificationName("RefreshAreas", object: self)//向所有注册过观测器的界面发送消息
    }
    
    //修改账户plist文件数据
    func UpdateAccountPlistData(){
        let fullPath = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
        let array = NSMutableDictionary.init(contentsOfFile: fullPath)//根据plist文件路径读取到数据字典
//        array?.setObject(gDC.m_sProvinceName, forKey: "province" as NSCopying)
//        array?.setObject(gDC.m_sCityName, forKey: "city" as NSCopying)
        array!.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "last_master" as NSCopying)
        array!.write(toFile: fullPath, atomically: true)
    }

}
