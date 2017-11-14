//
//  ShareMasterViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/29.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class ShareMasterViewCtrl: UIViewController {

    @IBOutlet weak var m_eAccountCode: UITextField!
    @IBOutlet weak var m_btnDown: UIButton!
    var m_nUserListFoot:Int!
    var m_sMastercode:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_btnDown.layer.cornerRadius = 5.0
        m_btnDown.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnDown(_ sender: AnyObject) {
        self.view.endEditing(true)
        let webReturn = MyWebService.sharedInstance.AddSharedUser(m_eAccountCode.text!, masterCode:gDC.mUserList[m_nUserListFoot].m_sMasterCode, userName:gDC.mUserList[m_nUserListFoot].m_sUserName, userIp:gDC.mUserList[m_nUserListFoot].m_sUserIP)
        WebAddSharedUser(webReturn)
    }

    ////////////////////////////////////////////////////////////////////////////////////
    func WebAddSharedUser(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "-1":
            ShowNoticeDispatch("提示", content: "不存在被分享的账号", duration: 0.8)
        case "0":
            ShowNoticeDispatch("提示", content: "该账号已被分享", duration: 0.8)
        case "1":
            ShowInfoDispatch("提示", content: "分享成功", duration: 0.5)
            self.navigationController?.popViewController(animated: true)
        case "-2":
            ShowNoticeDispatch("提示", content: "分享失败", duration: 0.5)
        default:
            break
        }
    }
    
}


