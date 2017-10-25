
//
//  RegisterViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/10/17.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class RegisterViewCtrl: UIViewController {

    @IBOutlet weak var m_eAccountCode: UITextField!//用户手机号
    @IBOutlet weak var m_eAccountName: UITextField!//用户昵称
    @IBOutlet weak var m_btnSmsCode: UIButton!
    @IBOutlet weak var m_eSmsCode: UITextField!
    @IBOutlet weak var m_labelInfo: UILabel!
    @IBOutlet weak var m_btnNext: UIButton!
    var m_bGettingSmsCode:Bool!
    var m_timer:Timer!
    var m_nCountdown:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.m_btnSmsCode.layer.cornerRadius = 5.0
        self.m_btnSmsCode.layer.masksToBounds = true
        self.m_btnNext.layer.cornerRadius = 5.0
        self.m_btnNext.layer.masksToBounds = true
        m_bGettingSmsCode = false
        m_nCountdown = 60
        m_eAccountCode.clearButtonMode=UITextFieldViewMode.whileEditing
        m_eAccountName.clearButtonMode=UITextFieldViewMode.whileEditing
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            print("从注册界面返回到登录界面")
        })
    }
    
    //点击以获取验证码
    @IBAction func OnGetSmsCode(_ sender: UIButton) {
        if m_bGettingSmsCode==true {
            return//处于获取中时，不可以重新获取验证码
        }
        if m_eAccountCode.text == "" {
            ShowNoticeDispatch("提示", content: "请输入手机号", duration: 0.8)
            return
        }
        //判断账号是否存在
        let sRe:String = MyWebService.sharedInstance.IsExistAccount(accountCode: m_eAccountCode.text!)
        WebIsExistAccount(sRe)
    }
    
    func OnTimer() {
        if m_nCountdown == 0 {
            m_nCountdown = 60
            m_timer.invalidate()//取消倒计时
            m_bGettingSmsCode = false
            m_btnSmsCode.setBackgroundImage(UIImage(named: "按钮_紫色_背景"), for: UIControlState())
            m_btnSmsCode.setTitle("验证码", for: UIControlState())
            return
        }
        m_nCountdown = m_nCountdown - 1
        let str = "\(m_nCountdown)s"
        m_btnSmsCode.setTitle(str, for: UIControlState())
    }
    
    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    
    //注册按钮点击事件
    @IBAction func OnNext(_ sender: AnyObject) {
        if m_eAccountCode.text == "" {
            m_labelInfo.text = "请输入手机号"
//            ShowNoticeDispatch("提示", content: "请输入手机号", duration: 0.8)
            return
        }
        if m_eSmsCode.text == "" {
            m_labelInfo.text = "请输入验证码"
//            ShowNoticeDispatch("提示", content: "请输入验证码", duration: 0.8)
            return
        }
        //检测验证码
        let dicts = MyWebService.sharedInstance.CheckSmsCode(phoneNum: m_eAccountCode.text!, code: m_eSmsCode.text!)
        WebCheckSmsCode(dicts)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebIsExistAccount(_ sRe:String) {
        switch sRe {
        case "WebError":
            m_labelInfo.text = "网络错误"
        case "0":
            //发送验证码
            let dicts = MyWebService.sharedInstance.SendSmsCode(phoneNum: m_eAccountCode.text!)
            WebSendSmsCode(dicts)
        case "1":
            m_labelInfo.text = "该账号已被注册"
        default:
            break
        }
    }
    
    func WebSendSmsCode(_ dicts:[String: JSON]) {
        if (dicts["info"]?.string != nil) {
            m_labelInfo.text = dicts["info"]?.string
        }
        //判断返回码是否正确，如果正确则进入倒计时
        var sCode:String! = ""
        if (dicts["code"]?.string != nil) {
            sCode = dicts["code"]?.string
        }
        if sCode == "200" {//成功发送验证码
            m_bGettingSmsCode = true
            m_btnSmsCode.setBackgroundImage(UIImage(named: "按钮_灰色_背景"), for: UIControlState())
            //设置超时，总共等待的时间为60s
            m_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RegisterViewCtrl.OnTimer),userInfo: nil, repeats: true)
            m_timer.fire()//开启倒计时
        }
    }
    
    func WebCheckSmsCode(_ dicts:[String: JSON]) {
        if (dicts["info"]?.string != nil) {
            m_labelInfo.text = dicts["info"]?.string
        }
        //判断返回码是否正确，如果正确则进入倒计时
        var sCode:String! = ""
        if (dicts["code"]?.string != nil) {
            sCode = dicts["code"]?.string
        }
        if sCode == "200" {//验证成功，否则会有错误的提示
            gDC.mAccountInfo.m_sAccountCode = m_eAccountCode.text!
            gDC.mAccountInfo.m_sAccountName = m_eAccountName.text!
            let mainStory = UIStoryboard(name: "Main", bundle: nil)
            let nextView = mainStory.instantiateViewController(withIdentifier: "setPasswordViewCtrl") as! SetPasswordViewCtrl
            self.navigationController?.pushViewController(nextView, animated: true)
        }
    }
    
}




