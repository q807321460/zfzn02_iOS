//
//  ChangeAccountNameViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/14.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class ChangeAccountNameViewCtrl: UIViewController {

    @IBOutlet weak var m_eAccountName: UITextField!
    @IBOutlet weak var m_btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let btnHeight = m_btnSave.layer.bounds.size.height
        m_btnSave.layer.cornerRadius = 5//实现按钮左右两侧完整的圆角
        m_btnSave.layer.masksToBounds = true//允许圆角
        m_eAccountName.clearButtonMode=UITextFieldViewMode.whileEditing  //编辑状态下显示右侧的叉号
        m_eAccountName.text = gDC.mAccountInfo.m_sAccountName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        print("从修改昵称界面返回到注册界面")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSave(_ sender: UIButton) {
        if m_eAccountName.text == "" {
            ShowNoticeDispatch("错误", content: "姓名不能为空", duration: 1.5)
            return
        }
        let webReturn = MyWebService.sharedInstance.UpdateAccount(gDC.mAccountInfo.m_sAccountCode, accountName: m_eAccountName.text!, accountPhone: gDC.mAccountInfo.m_sAccountCode, accountAddress: gDC.mAccountInfo.m_sAccountAddress, accountEmail: gDC.mAccountInfo.m_sAccountEmail)
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
            gDC.mAccountInfo.m_sAccountName = m_eAccountName.text!
            let dictSet = NSMutableDictionary()
            dictSet.setObject(m_eAccountName.text!, forKey: "account_name" as NSCopying)
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
