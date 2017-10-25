//
//  ChangeAccountPasswordViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/15.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class ChangeAccountPasswordViewCtrl: UIViewController {

    @IBOutlet weak var m_ePasswordOld: UITextField!
    @IBOutlet weak var m_ePasswordNew: UITextField!
    @IBOutlet weak var m_ePasswordConfirm: UITextField!
    @IBOutlet weak var m_btnDown: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_btnDown.layer.cornerRadius = 5//实现按钮左右两侧完整的圆角
        m_btnDown.layer.masksToBounds = true//允许圆角
        m_ePasswordOld.clearButtonMode=UITextFieldViewMode.whileEditing  //编辑状态下显示右侧的叉号
        m_ePasswordOld.isSecureTextEntry = true//设置为密码输入框
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        print("从修改地址界面返回到注册界面")
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnDown(_ sender: UIButton) {
        //判断输入的旧密码是否正确
        if m_ePasswordOld.text == "" {
            ShowNoticeDispatch("提示", content: "请输入旧密码", duration: 0.8)
            return
        }
        if m_ePasswordNew.text == "" {
            ShowNoticeDispatch("提示", content: "请输入新密码", duration: 0.8)
            return
        }
        if m_ePasswordNew.text != m_ePasswordConfirm.text {
            ShowNoticeDispatch("提示", content: "两次输入的密码不一致", duration: 0.8)
            return
        }
        let webReturn = MyWebService.sharedInstance.UpdateAccountPassword(gDC.mAccountInfo.m_sAccountCode, oldPassword: m_ePasswordOld.text!, newPassword: m_ePasswordNew.text!)
        WebUpdateAccountPassword(webReturn, passwordNew: m_ePasswordNew.text!)
    }
    
    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateAccountPassword(_ responseValue:String, passwordNew:String) {
        switch responseValue {
        case "WebError":
            break
        case "0":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            gDC.mAccountData.UpdateAccountPassword(passwordNew)
            self.navigationController?.popViewController(animated: true)
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
}
