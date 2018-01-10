//
//  EditSceneViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/3.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class EditSceneViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource, EditSceneElectricCellDelegate {

    @IBOutlet weak var m_labelSceneName: UITextField!
    @IBOutlet weak var m_imageScene: UIImageView!
    @IBOutlet weak var m_tableSceneElectric: UITableView!
    @IBOutlet weak var m_btnSetTiming: UIButton!
    @IBOutlet weak var m_btnDelete: UIButton!
    var m_nSceneListFoot:Int!
    var m_nSceneElectricListFoot:Int!
    var m_sElectricOrder:String!
    var m_nAreaListFoot:Int!
    var m_nSceneIndex:Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_labelSceneName.text = gDC.mSceneList[m_nSceneListFoot].m_sSceneName
        m_tableSceneElectric.bounces = false
        m_tableSceneElectric.tableFooterView = UIView()
        m_tableSceneElectric.register(EditSceneElectricCell.self, forCellReuseIdentifier: "editSceneElectricCell")
        m_tableSceneElectric.register(UINib(nibName: "EditSceneElectricCell", bundle: nil), forCellReuseIdentifier: "editSceneElectricCell")
        
        m_btnSetTiming.layer.cornerRadius = 5.0
        m_btnSetTiming.layer.masksToBounds = true
        m_btnDelete.layer.cornerRadius = 5.0
        m_btnDelete.layer.masksToBounds = true
        
        g_notiCenter.addObserver(self, selector:#selector(EditSceneViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        m_tableSceneElectric.reloadData()
        if gDC.m_bQuickScene == true {//快捷跳转时，需要将当前的情景pop出来，进入根界面并重新跳转
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

//    @IBAction func OnSave(_ sender: AnyObject) {
//        ShowInfoDispatch("提示", content: "该功能有待完善，敬请期待~", duration: 1.0)
//    }
    
    @IBAction func OnAddAction(_ sender: AnyObject) {
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "addSceneElectricViewCtrl") as! AddSceneElectricViewCtrl
        nextView.m_nSceneListFoot = self.m_nSceneListFoot
        nextView.m_nSceneIndex = self.m_nSceneIndex
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func OnDeleteScene(_ sender: AnyObject) {
//        if gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex < 4 {
//            ShowNoticeDispatch("提示", content: "默认情景无法删除", duration: 1.0)
//            return
//        }
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("确定", action: {()->Void in
                let webReturn = MyWebService.sharedInstance.DeleteScene(gDC.mUserInfo.m_sMasterCode, sceneIndex:gDC.mSceneList[self.m_nSceneListFoot].m_nSceneIndex, sceneSequ:gDC.mSceneList[self.m_nSceneListFoot].m_nSceneSequ)
                self.WebDeleteScene(webReturn)
            })
            alertView.showInfo("警告", subTitle: "是否确认删除这个情景？", duration: 0)//时间间隔为0时不会自动退出
        })
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebDeleteScene(_ responseValue:String){
        switch responseValue{
        case "WebError":
            break
        case "1":
            gDC.mSceneData.DeleteSceneByFoot(m_nSceneListFoot)
            self.navigationController?.popToRootViewController(animated: true)
        default:
            ShowNoticeDispatch("错误", content: "未知的失败", duration: 1.0)
            break
        }
    }
    
    func WebDeleteSceneElectric(_ responseValue:String){
        switch responseValue{
        case "WebError":
            break
        case "1":
            gDC.mSceneElectricData.DeleteSceneElectricByFoot(m_nSceneListFoot, electricIndex:gDC.mSceneList[self.m_nSceneListFoot].mSceneElectricList[self.m_nSceneElectricListFoot].m_nElectricIndex)
            m_tableSceneElectric.reloadData()
        default:
            ShowNoticeDispatch("错误", content: "未知的失败", duration: 1.0)
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gDC.mSceneList[m_nSceneListFoot].mSceneElectricList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editSceneElectricCell", for: indexPath) as! EditSceneElectricCell
        //根据电器类型设置左侧图片
        let nType:Int = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_nElectricType
        cell.m_imageSceneElectric.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)
//        if nType == 0 || nType==1 || nType==2 || nType==3 || nType==4 {
        let sElectricOrder:String = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_sElectricOrder
            if sElectricOrder == "XG" || sElectricOrder == "SG" {
                cell.m_switchElectric.isOn = false
            }else {
                cell.m_switchElectric.isOn = true
            }
//        }else {
//            cell.m_switchElectric.isHidden = true
//        }
        //其他属性设置
        cell.m_nSceneElectricListFoot = indexPath.row
        cell.m_labelElectricName.text = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_sElectricName
        for i in 0..<gDC.mAreaList.count {
            if gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_nRoomIndex == gDC.mAreaList[i].m_nAreaIndex {
                cell.m_labelAreaName.text = gDC.mAreaList[i].m_sAreaName
                break
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //点击cell内部的按钮时的响应
    func didClickDeleteButton(_ sceneElectricFoot:Int) {
        self.m_nSceneElectricListFoot = sceneElectricFoot
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("确定", action: {()->Void in
                //向服务器发送删除指令
                let webReturn = MyWebService.sharedInstance.DeleteSceneElectric(gDC.mUserInfo.m_sMasterCode, electricIndex:gDC.mSceneList[self.m_nSceneListFoot].mSceneElectricList[sceneElectricFoot].m_nElectricIndex, sceneIndex:gDC.mSceneList[self.m_nSceneListFoot].m_nSceneIndex)
                self.WebDeleteSceneElectric(webReturn)
            })
            alertView.showInfo("提示", subTitle: "是否确认在此情景中删除该动作？", duration: 0)//时间间隔为0时不会自动退出
        })
    }
    
    //切换cell内部的开关时的响应
    func didSwitchChange(_ sceneElectricFoot:Int, isOn:Bool) {
        self.m_nSceneElectricListFoot = sceneElectricFoot
        var sElectricOrder:String = ""
        if isOn == true {
            sElectricOrder = "SH"
        }else {
            sElectricOrder = "SG"
        }
        
        let electricIndex:Int = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[m_nSceneElectricListFoot].m_nElectricIndex
        let electricCode:String = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[m_nSceneElectricListFoot].m_sElectricCode
//        let electricName:String = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[m_nSceneElectricListFoot].m_sElectricName
//        let electricType:Int = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[m_nSceneElectricListFoot].m_nElectricType
        let sceneIndex:Int = gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex
//        let roomIndex:Int = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[m_nSceneElectricListFoot].m_nRoomIndex
        let orderInfo:String = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[m_nSceneElectricListFoot].m_sOrderInfo

//        let webReturn = MyWebService.sharedInstance.AddSceneElectric(gDC.mUserInfo.m_sMasterCode, electricCode:electricCode, electricOrder:sElectricOrder, accountCode:gDC.mAccountInfo.m_sAccountCode, sceneIndex:sceneIndex, orderInfo:orderInfo, electricIndex:electricIndex, electricName:electricName, roomIndex:roomIndex, electricType:electricType)
//        WebUpdateSceneElectricOrder(webReturn, electricOrder: sElectricOrder)
        
        let webReturn = MyWebService.sharedInstance.UpdateSceneElectricOrder(masterCode: gDC.mUserInfo.m_sMasterCode, electricIndex: electricIndex, electricCode: electricCode, sceneIndex: sceneIndex, electricOrder: sElectricOrder, orderInfo: orderInfo)
        WebUpdateSceneElectricOrder(webReturn, electricOrder: sElectricOrder)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateSceneElectricOrder(_ responseValue:String, electricOrder:String) {
        switch responseValue {
        case "WebError":
            break
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            gDC.mSceneElectricData.UpdateSceneElectricOrder(electricFoot: m_nSceneElectricListFoot, sceneFoot: m_nSceneListFoot, electricOrder: electricOrder)
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
    func SyncData() {
        DispatchQueue.main.async {
            //可能会数组越界，还需要判断当前的情景是否已经不存在了（被其他app删除）
            if (self.m_nSceneListFoot >= gDC.mSceneList.count || gDC.mSceneList[self.m_nSceneListFoot].m_nSceneIndex != self.m_nSceneIndex) {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            self.m_tableSceneElectric.reloadData()
        }
    }
}








