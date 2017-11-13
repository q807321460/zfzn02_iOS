//
//  AddMasterViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/23.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import Foundation
import UIKit

class AddMasterViewCtrl: UIViewController, GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate {

    @IBOutlet weak var m_btnSearchMaster: UIButton!
    @IBOutlet weak var m_eMasterName: UITextField!
    @IBOutlet weak var m_eMasterCode: UITextField!
    @IBOutlet weak var m_eMasterIP: UITextField!
    
    var m_viewSearching:SCLAlertView! = nil
    var m_viewAfterSearch:SCLAlertView! = nil
    var m_arrayMasterCode = [String]()
    var m_arrayMasterIP = [String]()
    var m_nSelectButton:Int = 0
    var m_appearSearching = SCLAlertView.SCLAppearance(showCloseButton: false)
    var m_appearAfterSearch = SCLAlertView.SCLAppearance(showCloseButton: true)
    var m_sUdpMasterReturn:String!//广播时返回的字符串
    var m_sTcpMasterReturn:String!//点对点发送时返回的字符串
    var m_timer:Timer?//定时器
    var m_bFirstAdd:Bool = true//是否是首次添加主机
//    var test_timer:dispatch_source_t?
//    var currentQueue:dispatch_queue_t?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.m_btnSearchMaster.layer.cornerRadius = 5.0
        self.m_btnSearchMaster.layer.masksToBounds = true
        m_eMasterName.clearButtonMode=UITextFieldViewMode.always  //一直显示清除按钮
        m_eMasterCode.isUserInteractionEnabled = false
        m_eMasterIP.isUserInteractionEnabled = false
    }

    deinit {
        //视图退出时一定要销毁这个观测器，如果没有取消监听消息，消息会发送给一个已经销毁的对象，导致程序崩溃
//        g_notiCenter!.removeObserver(self)//程序似乎没有进入这里？
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        if m_bFirstAdd == true {
            self.dismiss(animated: true, completion: {
                print("从添加主机界面返回到登录界面")
            })
        }else {
            print("从添加主机界面返回到我的主机界面")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //点击右上角添加主机的按钮，实际上是添加了一个user
    @IBAction func OnAddMaster(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if m_eMasterCode.text == "" {
            print("请先搜索主机")
            ShowNoticeDispatch("提示", content: "请先搜索主机", duration: 0.8)
            return
        }
        if m_eMasterName.text == "" {
            print("请输入主机的名称")
            ShowNoticeDispatch("提示", content: "请输入主机的名称", duration: 0.8)
            return
        }
        //判断这个主机是否被该账户添加过
        for i in 0..<gDC.mUserList.count {
            if (gDC.mUserList[i].m_sMasterCode == m_eMasterCode.text!) {
                ShowNoticeDispatch("提示", content: "该主机已被您添加过了", duration: 0.8)
                return
            }
        }
//        let dict = NSMutableDictionary()
//        dict.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
//        let sqlResult = gMySqlClass.QuerySql(dict, table: "users")
//        for i in 0..<sqlResult.count {
//            if sqlResult[i]["master_code"] as! String == m_eMasterCode.text! {
//                //说明已被添加过
//                ShowNoticeDispatch("提示", content: "该主机已被您添加过了", duration: 0.8)
//                return
//            }
//        }
        print("开始添加user")
        //向服务器中添加这个主机
        let webResult:String = MyWebService.sharedInstance.AddUser(gDC.mAccountInfo.m_sAccountCode, masterCode:m_eMasterCode.text!, userName:m_eMasterName.text!, userIp:m_eMasterIP.text!)
        WebAddUser(webResult)
    }
    

    //点击搜索主机按钮
    @IBAction func OnSearchMaster(_ sender: UIButton) {
        print("开始搜索主机")
        m_arrayMasterCode.removeAll()//清空该数组，用于保存下一轮masterCode
        m_arrayMasterIP.removeAll()//清空该数组，用于保存下一轮masterIP
        DispatchQueue.main.async(execute: {
            self.m_viewSearching = SCLAlertView(appearance: self.m_appearSearching)
            self.m_viewSearching.showInfo("提示", subTitle: " 正在搜索主节点......", duration: 0)
        })
        (m_arrayMasterCode, m_arrayMasterIP) = MySocket.sharedInstance.SearchMasterNodeIP()//发送指定指令，获得主机的编号和具体ip地址
        self.m_viewSearching.hideView()//取消显示正在搜索的字样
        if m_arrayMasterCode.count > 0 {
            DispatchQueue.main.async(execute: {
                self.m_viewAfterSearch = SCLAlertView(appearance: self.m_appearAfterSearch)
                let nCount = self.m_arrayMasterCode.count
                for i:Int in 0..<nCount {
                    //每搜索到一个结果，都相应加上一个按钮，并添加相应的响应
                    self.m_viewAfterSearch.addButton(self.m_arrayMasterCode[i], action: {
                        () -> Void in
                        self.m_eMasterCode.text = self.m_arrayMasterCode[i]
                        self.m_eMasterIP.text = self.m_arrayMasterIP[i]
                        self.m_nSelectButton = i
                    })
                }
                self.m_viewAfterSearch.showInfo("提示", subTitle: "搜索完成，请选择一个主节点", duration: 0)//时间间隔为0时不会自动退出
            })
        }else{
            ShowNoticeDispatch("提示", content: "没有搜索到主机，请确认主机和手机处在同一wifi下", duration: 1.0)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebAddUser(_ responseValue:String){
        switch responseValue{
        case "WebError":
            //错误的提示已经在WS类中处理过了
            break
        case "-2":
            print("添加失败")
            ShowNoticeDispatch("错误", content: "未知的失败", duration: 0.5)
        case "1":
            print("添加成功")
            ShowInfoDispatch("提示", content: "添加成功", duration: 0.5)
            //添加到本地数据库
            gDC.mUserData.AddUser(m_eMasterName.text!, masterCode: m_eMasterCode.text!, userIP: m_eMasterIP.text!)
            if m_bFirstAdd == true {//首次登录的话，则需要返回到登录界面重新登录
                self.dismiss(animated: true, completion: {
                    print("从添加主机界面返回到登录界面")
                })
            }else {//否则将刚刚添加的主机作为当前使用的主机
                print("从添加主机界面返回到我的主机界面")
                MyWebService.sharedInstance.StopPolling()
                SetCurrentUser(gDC.mUserList.count-1)//将刚刚添加的主机作为当前主机
                MyWebService.sharedInstance.OpenPolling()
                self.navigationController?.popViewController(animated: true)
            }
        case "0":
            print("需要由主节点的拥有者分享")
            ShowNoticeDispatch("错误", content: "该节点已被添加，需通过该主机的拥有者分享", duration: 1.5)
        default:
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func SetCurrentUser(_ index:Int) {
        gDC.mUserInfo = gDC.mUserList[index]
        //开始各种读取工作
        MyWebService.sharedInstance.StopPolling()
        //从web加载房间列表
        let dictsArea = MyWebService.sharedInstance.LoadUserRoom(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, areaTime: "")
        gDC.mAreaData.UpdateArea(dictsArea)
        //从web加载电器列表
        let dictsElectric = MyWebService.sharedInstance.LoadElectric(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, electricTime: "")
        gDC.mElectricData.UpdateElectric(dictsElectric)
        //从web加载情景列表
        let dictsScene = MyWebService.sharedInstance.LoadScene(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, sceneTime: "")
        gDC.mSceneData.UpdateScene(dictsScene)
        //从web加载情景电器列表
        let dictSceneElectric = MyWebService.sharedInstance.LoadSceneElectric(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, sceneElectricTime: "")
        gDC.mSceneElectricData.UpdateSceneElectric(dictSceneElectric)
        
        gDC.m_bRemote = false
        
        //重新刷新区域界面
        gDC.m_bRefreshAreaList = true
        gDC.m_nSelectAreaSequ = 0
        //修改plist文件数据
        UpdatePlistFile()
    }
    
    //修改plist文件数据
    func UpdatePlistFile() {
        let filePath = DataFilePath("data.plist")//获得本地data.plist文件的路径
        let array = NSMutableDictionary.init(contentsOfFile: filePath)//根据plist文件路径读取到数据字典
        array?.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "last_master" as NSCopying)
        array!.write(toFile: filePath, atomically: true)
    }
    
}
