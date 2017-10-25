//
//  ChangeAccountEmailViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/15.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class ChangeAccountEmailViewCtrl: UIViewController {

    @IBOutlet weak var m_eAccountEmail: UITextField!
    @IBOutlet weak var m_btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_btnSave.layer.cornerRadius = 5//实现按钮左右两侧完整的圆角
        m_btnSave.layer.masksToBounds = true//允许圆角
        m_eAccountEmail.clearButtonMode=UITextFieldViewMode.whileEditing  //编辑状态下显示右侧的叉号
        m_eAccountEmail.text = gDC.mAccountInfo.m_sAccountEmail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        print("从修改邮箱界面返回到注册界面")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSave(_ sender: UIButton) {
        if m_eAccountEmail.text == "" {
            print("用户没有输入邮箱，不过无所谓")
        }
        let webReturn = MyWebService.sharedInstance.UpdateAccount(gDC.mAccountInfo.m_sAccountCode, accountName: gDC.mAccountInfo.m_sAccountName, accountPhone: gDC.mAccountInfo.m_sAccountCode, accountAddress: gDC.mAccountInfo.m_sAccountAddress, accountEmail: m_eAccountEmail.text!)
        WebUpdateAccount(webReturn)
    }
    
    func WebUpdateAccount(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "-2":
            ShowNoticeDispatch("错误", content: "发生了未知的错误", duration: 1.5)
        case "0":
            ShowNoticeDispatch("错误", content: "该用户不存在", duration: 1.5)
        case "1":
            ShowInfoDispatch("成功", content: "更新用户数据成功", duration: 1.5)
            //将对应的数据写入到数据库,同时也写入内存
            gDC.mAccountInfo.m_sAccountEmail = m_eAccountEmail.text!
            let dictSet = NSMutableDictionary()
            dictSet.setObject(m_eAccountEmail.text!, forKey: "account_email" as NSCopying)
            let dictRequired = NSMutableDictionary()
            dictRequired.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
            gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "accounts")
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }

    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    
}
