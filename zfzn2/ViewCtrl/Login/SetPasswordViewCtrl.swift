//
//  SetPasswordViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/10/19.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class SetPasswordViewCtrl: UIViewController {

    @IBOutlet weak var m_ePasswordSet: UITextField!//设置密码
    @IBOutlet weak var m_ePasswordSure: UITextField!//确认设置的密码
    @IBOutlet weak var m_btnDown: UIButton!
//    var m_sAccountCode:String!//上一个界面的账户名
//    var m_sAccountName:String!//上一个界面的账户名
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        m_ePasswordSet.isSecureTextEntry = true//设置为密码输入框
        m_ePasswordSure.isSecureTextEntry = true//设置为密码输入框
        self.m_btnDown.layer.cornerRadius = 5.0
        self.m_btnDown.layer.masksToBounds = true
    }

    deinit {
        //视图退出时一定要销毁这个观测器，如果没有取消监听消息，消息会发送给一个已经销毁的对象，导致程序崩溃
        g_notiCenter.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnDown(_ sender: UIButton) {
        if m_ePasswordSet.text! != m_ePasswordSure.text! {
            print("前后密码输入不一致")
            ShowNoticeDispatch("提示", content: "前后密码输入不一致", duration: 0.8)
            return
        }
        let webResult:String = MyWebService.sharedInstance.AddAccount(gDC.mAccountInfo.m_sAccountCode, passWord: m_ePasswordSet.text!, accountName: gDC.mAccountInfo.m_sAccountName)
        WebAddAccount(webResult)
    }

    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    //从服务器端得到的响应
    func WebAddAccount(_ responseValue: String) {
        switch responseValue {
        case "WebError":
            break
        case "-2":
            ShowNoticeDispatch("提示", content: "添加新用户失败", duration: 0.8)
        case "1":
            ShowInfoDispatch("提示", content: "添加新用户成功", duration: 0.8)
            //反正要先返回登录界面，下一次登陆都会重新加载所有的数据，还不如先不添加在本地数据库中
            SaveImage(UIImage(named: "首页_用户logo.png")!, newSize: CGSize(width: 128, height: 128), percent: 0.5, imagePath: gDC.mAccountInfo.m_sAccountCode, imageName: "/head.png")//其实并没有必要在这个时候添加图片
            
            self.dismiss(animated: true, completion: {
                print("从设置密码界面直接返回到登录界面")
            })
        case "2":
            ShowNoticeDispatch("提示", content: "该用户已存在", duration: 0.5)
        default:
            break
        }
        
    }
    
}




