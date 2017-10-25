//
//  ResetPasswordViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/10/19.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class ResetPasswordViewCtrl: UIViewController {

    @IBOutlet weak var m_ePasswordNew: UITextField!
    @IBOutlet weak var m_ePasswordConfirm: UITextField!
    @IBOutlet weak var m_btnDown: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.m_btnDown.layer.cornerRadius = 5.0
        self.m_btnDown.layer.masksToBounds = true
        m_ePasswordNew.isSecureTextEntry = true//设置为密码输入框
        m_ePasswordConfirm.isSecureTextEntry = true//设置为密码输入框
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        print("从重置密码界面返回到找回密码界面")
    }
    
    @IBAction func OnDown(_ sender: UIButton) {
        if m_ePasswordNew.text == "" {
            ShowNoticeDispatch("错误", content: "请输入新的密码", duration: 0.8)
        }else if m_ePasswordNew.text != m_ePasswordConfirm.text {
            ShowNoticeDispatch("错误", content: "前后密码输入不一致", duration: 0.8)
        }else {
            //向服务器发送更新指令
            let webReturn = MyWebService.sharedInstance.ResetAccountPassword(gDC.mAccountInfo.m_sAccountCode, newPassword: m_ePasswordNew.text!)
            WebResetAccountPassword(webReturn, newPassword: m_ePasswordNew.text!)
        }
    }
    
    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebResetAccountPassword(_ responseValue:String, newPassword:String) {
        switch responseValue {
        case "WebError":
            break
        case "0":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            gDC.mAccountData.UpdateAccountPassword(newPassword)
//            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: {
                print("从重置密码界面返回到登录界面")
            })
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
}
