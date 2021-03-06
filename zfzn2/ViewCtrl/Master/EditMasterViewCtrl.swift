//
//  EditMasterViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/26.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.

import UIKit

class EditMasterViewCtrl: UIViewController {

    @IBOutlet weak var m_eMasterName: UITextField!
    @IBOutlet weak var m_labelMasterCode: UILabel!
    @IBOutlet weak var m_labelMasterIP: UILabel!
    @IBOutlet weak var m_labelMasterVersion: UILabel!
    @IBOutlet weak var m_labelMasterLatestVersion: UILabel!
    //    @IBOutlet weak var m_eMasterCode: UITextField!
//    @IBOutlet weak var m_eMasterIP: UITextField!

//    @IBOutlet weak var m_btnSave: UIButton!
    @IBOutlet weak var m_btnAbandonAdmin: UIButton!//放弃管理员权限
    @IBOutlet weak var m_btnShareMaster: UIButton!
    @IBOutlet weak var m_btnShareList: UIButton!
    @IBOutlet weak var m_btnGetAdmin: UIButton!//获取管理员权限
    @IBOutlet weak var m_btnGetAdminAccount: UIButton!//获取管理员账号
    var m_nUserListFoot:Int!
    var m_sMasterCode:String! = ""
    var m_viewSearching:SCLAlertView! = nil
    var m_viewAfterSearch:SCLAlertView! = nil
    var m_appear = SCLAlertView.SCLAppearance(showCloseButton: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_eMasterName.clearButtonMode=UITextFieldViewMode.always  //一直显示清除按钮
        m_eMasterName.text = gDC.mUserList[m_nUserListFoot].m_sUserName
        m_labelMasterCode.text = "主机编号：" + gDC.mUserList[m_nUserListFoot].m_sMasterCode
        m_labelMasterIP.text = "主机IP：" + gDC.mUserList[m_nUserListFoot].m_sUserIP
        let masterVersion:String = MyWebService.sharedInstance.GetMasterVersionBy(masterCode: gDC.mUserList[m_nUserListFoot].m_sMasterCode)
        m_labelMasterVersion.text = "主机当前版本：" + masterVersion
        let masterLatestVersion:String = MyWebService.sharedInstance.GetMasterVersion()
        m_labelMasterLatestVersion.text = "主机最新版本：" + masterLatestVersion
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
        if m_eMasterName.text?.count == 0 {
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
        let dictsSharedAccount = MyWebService.sharedInstance.LoadSharedAccount(gDC.mUserList[m_nUserListFoot].m_sMasterCode)
        gDC.mAccountData.UpdateSharedAccount(dictsSharedAccount)
        //取消显示正在加载的字样
        self.m_viewSearching.hideView()
        
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "sharedListViewCtrl") as! SharedListViewCtrl
        nextView.m_nUserListFoot = self.m_nUserListFoot
        nextView.m_sMasterCode = gDC.mUserList[self.m_nUserListFoot].m_sMasterCode
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
        DispatchQueue.main.async {
            //可能会数组越界，还需要判断当前的主机是否已经不存在了（被其他app删除）
            if (self.m_nUserListFoot >= gDC.mUserList.count || gDC.mUserList[self.m_nUserListFoot].m_sMasterCode != self.m_sMasterCode) {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            self.m_eMasterName.text = gDC.mUserList[self.m_nUserListFoot].m_sUserName
            self.m_labelMasterCode.text = "主机编号：" + gDC.mUserList[self.m_nUserListFoot].m_sMasterCode
            self.m_labelMasterIP.text = "主机IP：" + gDC.mUserList[self.m_nUserListFoot].m_sUserIP
            self.RefreshButton()
        }
    }
}





