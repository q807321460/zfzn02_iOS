//
//  EditMasterViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/26.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.

import UIKit

class EditMasterViewCtrl: UIViewController {

    @IBOutlet weak var m_eMasterName: UITextField!
    @IBOutlet weak var m_eMasterCode: UITextField!
    @IBOutlet weak var m_eMasterIP: UITextField!
//    @IBOutlet weak var m_btnSave: UIButton!
    @IBOutlet weak var m_btnAbandonAdmin: UIButton!//放弃管理员权限
    @IBOutlet weak var m_btnShareMaster: UIButton!
    @IBOutlet weak var m_btnShareList: UIButton!
    @IBOutlet weak var m_btnGetAdmin: UIButton!//获取管理员权限
    @IBOutlet weak var m_btnGetAdminAccount: UIButton!//获取管理员账号
    @IBOutlet weak var m_layoutHeight: NSLayoutConstraint!
    var m_nUserListFoot:Int!
    var m_viewSearching:SCLAlertView! = nil
    var m_viewAfterSearch:SCLAlertView! = nil
    var m_appear = SCLAlertView.SCLAppearance(showCloseButton: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_eMasterName.clearButtonMode=UITextFieldViewMode.always  //一直显示清除按钮
        m_eMasterCode.isUserInteractionEnabled = false
        m_eMasterIP.isUserInteractionEnabled = false
        m_eMasterName.text = gDC.mUserList[m_nUserListFoot].m_sUserName
        m_eMasterCode.text = gDC.mUserList[m_nUserListFoot].m_sMasterCode
        m_eMasterIP.text = gDC.mUserList[m_nUserListFoot].m_sUserIP
//        m_btnSave.layer.cornerRadius = 5.0
//        m_btnSave.layer.masksToBounds = true
        m_btnAbandonAdmin.layer.cornerRadius = 5.0
        m_btnAbandonAdmin.layer.masksToBounds = true
        m_btnShareMaster.layer.cornerRadius = 5.0
        m_btnShareMaster.layer.masksToBounds = true
        m_btnGetAdmin.layer.cornerRadius = 5.0
        m_btnGetAdmin.layer.masksToBounds = true
        m_btnShareList.layer.cornerRadius = 5.0
        m_btnShareList.layer.masksToBounds = true
        m_btnGetAdminAccount.layer.cornerRadius = 5.0
        m_btnGetAdminAccount.layer.masksToBounds = true
        g_notiCenter.addObserver(self, selector:#selector(EditMasterViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
        RefreshButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
//        RefreshButton()
    }
    
    func RefreshButton(){
        if gDC.mUserList[m_nUserListFoot].m_nIsAdmin == 1 {
            m_btnAbandonAdmin.isHidden = false
            m_btnShareMaster.isHidden = false
            m_btnShareList.isHidden = false
            m_btnGetAdmin.isHidden = true
            m_btnGetAdminAccount.isHidden = true
        }else {
            m_btnAbandonAdmin.isHidden = true
            m_btnShareMaster.isHidden = true
            m_btnShareList.isHidden = true
            m_btnGetAdmin.isHidden = false
            m_btnGetAdminAccount.isHidden = false
        }
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnSave(_ sender: AnyObject) {
//        ShowInfoDispatch("提示", content: "修改主机名功能尚未添加，敬请期待~", duration: 1.5)
        if m_eMasterName.text?.characters.count == 0 {
            ShowNoticeDispatch("提示", content: "请输入主机名", duration: 0.8)
            return
        }
        let webReturn = MyWebService.sharedInstance.UpdateUserName(accountCode: gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, userName: m_eMasterName.text!)
        WebUpdateUserName(webReturn)
    }
    
    @IBAction func OnAbandonAdmin(_ sender: AnyObject) {
        let webReturn = MyWebService.sharedInstance.GiveUpAdmin(gDC.mUserList[m_nUserListFoot].m_sMasterCode, owner:gDC.mUserList[m_nUserListFoot].m_sAccountCode)
        WebGiveUpAdmin(webReturn)
    }
    
    @IBAction func OnGetAdmin(_ sender: AnyObject) {
        let webReturn = MyWebService.sharedInstance.AccessAdmin(gDC.mUserList[m_nUserListFoot].m_sMasterCode, owner:gDC.mUserList[m_nUserListFoot].m_sAccountCode)
        WebAccessAdmin(webReturn)
        if gDC.mUserList[m_nUserListFoot].m_sMasterCode == gDC.mUserInfo.m_sMasterCode {//需要是当前连接的电器才行
            let dictsElectric = MyWebService.sharedInstance.LoadElectric(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserList[m_nUserListFoot].m_sMasterCode, electricTime: "__:__:__")
            gDC.mElectricData.UpdateElectric(dictsElectric)
            g_notiCenter.post(name: Notification.Name(rawValue: "RefreshElectricStates"), object: self)//向所有注册过观测器的界面发送消息，刷新显示
        }
    }
    
    @IBAction func OnShareMaster(_ sender: AnyObject) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "shareMasterViewCtrl") as! ShareMasterViewCtrl
        nextView.m_nUserListFoot = self.m_nUserListFoot
        self.navigationController?.pushViewController(nextView , animated: true)
    }
    
    @IBAction func OnShowShareList(_ sender: AnyObject) {
        DispatchQueue.main.async(execute: {
            self.m_viewSearching = SCLAlertView(appearance: self.m_appear)
            self.m_viewSearching.showInfo("提示", subTitle: " 正在加载中......", duration: 0)
        })
        //加载分享账户列表
        let dictsSharedAccount = MyWebService.sharedInstance.LoadSharedAccount(gDC.mUserList[m_nUserListFoot].m_sMasterCode)//延迟大约在一秒钟
        gDC.mAccountData.UpdateSharedAccount(dictsSharedAccount)
        //加载分享电器列表
        let dictsSharedElectric = MyWebService.sharedInstance.LoadAllSharedElectric(gDC.mUserList[m_nUserListFoot].m_sMasterCode)//延迟大约在一秒钟
        gDC.mElectricData.UpdateSharedElectric(dictsSharedElectric)
        //取消显示正在加载的字样
        self.m_viewSearching.hideView()
        
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "sharedListViewCtrl") as! SharedListViewCtrl
        self.navigationController?.pushViewController(nextView , animated: true)
    }
    
    @IBAction func OnGetAdminAccount(_ sender: Any) {
        let sAdminAccount:String = MyWebService.sharedInstance.GetAdminAccountCode(gDC.mUserInfo.m_sMasterCode)
        WebGetAdminAccount(sAdminAccount)
    }
    
////////////////////////////////////////////////////////////////////////////////////
    func WebGiveUpAdmin(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "0":
            ShowNoticeDispatch("提示", content: "不能执行该操作", duration: 0.8)
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            gDC.mUserData.UpdateAdmin(gDC.mUserList[m_nUserListFoot].m_sMasterCode, isAdmin:0)
            gDC.m_bRefreshAreaList = true
            RefreshButton()
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
    func WebAccessAdmin(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "0":
            ShowNoticeDispatch("提示", content: "不能执行该操作", duration: 0.8)
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            gDC.mUserData.UpdateAdmin(gDC.mUserList[m_nUserListFoot].m_sMasterCode, isAdmin:1)
            gDC.m_bRefreshAreaList = true
            RefreshButton()
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
    func WebGetAdminAccount(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "":
            ShowNoticeDispatch("提示", content: "当前主机还没有分配管理员", duration: 1.0)
            break
        default:
            DispatchQueue.main.async(execute: {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                let viewLoading = SCLAlertView(appearance: appearance)
                viewLoading.showInfo("管理员账号", subTitle: responseValue, duration: 0)
            })
            break
        }
    }
    
    func WebUpdateUserName(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            gDC.mUserData.UpdateUserName(accountCode: gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, userName: m_eMasterName.text!)
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
    func SyncData() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}





