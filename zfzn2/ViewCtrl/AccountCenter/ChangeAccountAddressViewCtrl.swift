//
//  ChangeAccountAddressViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/15.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class ChangeAccountAddressViewCtrl: UIViewController {

    @IBOutlet weak var m_btnSave: UIButton!
    @IBOutlet weak var m_eAccountAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_btnSave.layer.cornerRadius = 5//实现按钮左右两侧完整的圆角
        m_btnSave.layer.masksToBounds = true//允许圆角
        m_eAccountAddress.clearButtonMode=UITextFieldViewMode.whileEditing  //编辑状态下显示右侧的叉号
        m_eAccountAddress.text = gDC.mAccountInfo.m_sAccountAddress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        print("从修改地址界面返回到注册界面")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSave(_ sender: UIButton) {
        if m_eAccountAddress.text == "" {
            print("用户没有输入地址，不过无所谓")
        }
        let webReturn = MyWebService.sharedInstance.UpdateAccount(gDC.mAccountInfo.m_sAccountCode, accountName: gDC.mAccountInfo.m_sAccountName, accountPhone: gDC.mAccountInfo.m_sAccountCode, accountAddress: m_eAccountAddress.text!, accountEmail: gDC.mAccountInfo.m_sAccountEmail)
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
            gDC.mAccountInfo.m_sAccountAddress = m_eAccountAddress.text!
//            let dictSet = NSMutableDictionary()
//            dictSet.setObject(m_eAccountAddress.text!, forKey: "account_address" as NSCopying)
//            let dictRequired = NSMutableDictionary()
//            dictRequired.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
//            gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "accounts")
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    
}
