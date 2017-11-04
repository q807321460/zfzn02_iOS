//
//  LeftMenuViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/2.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class LeftMenuViewCtrl: MyViewController {

    @IBOutlet weak var m_vTopArea: UIView!
    @IBOutlet weak var m_btnAccountLogo: UIButton!
    
    @IBOutlet weak var m_vMyMaster: UIView!
    @IBOutlet weak var m_labelMyMaster: UILabel!
    @IBOutlet weak var m_vReconnect: UIView!
    @IBOutlet weak var m_labelReconnect: UILabel!
    @IBOutlet weak var m_vJdPlay: UIView!
    @IBOutlet weak var m_labelJdPlay: UILabel!
    @IBOutlet weak var m_vSetting: UIView!
    @IBOutlet weak var m_labelSetting: UILabel!
   
    
    @IBOutlet weak var m_vHelp: UIView!
    
    @IBOutlet weak var m_labelAccountCode: UILabel!
    @IBOutlet weak var m_labelAccountName: UILabel!
    @IBOutlet weak var m_labelLocalVersion: UILabel!
    
    var m_viewLoading:SCLAlertView! = nil
    var conn: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        m_vJdPlay.isHidden = true
        m_vHelp.isHidden = true
//        m_vSetting.isHidden = false
        //设置logo图片的圆角
        m_btnAccountLogo.setImage(gDC.mAccountInfo.m_imageAccountHead, for: UIControlState())
//        print("TopArea尺寸为——\(m_vTopArea.bounds.size)")
        let btnWidth = m_btnAccountLogo.layer.bounds.size.width
//        print("按钮尺寸为——\(btnWidth)")
        self.m_btnAccountLogo.layer.cornerRadius = (btnWidth*3/4)/2
//        print("按钮圆角半径为——\((btnWidth*3/4)/2)")
        self.m_btnAccountLogo.layer.masksToBounds = true
        //将手机号中间4位数字修改为****
        var sPhone:String = gDC.mAccountInfo.m_sAccountCode
        let range = (sPhone.index(sPhone.startIndex, offsetBy: 3) ..< sPhone.index(sPhone.startIndex, offsetBy: 7)) //Swift 3.0
        sPhone.replaceSubrange(range, with: "****")
        m_labelAccountCode.text = sPhone
        //显示账户姓名和版本号
        m_labelAccountName.text = gDC.mAccountInfo.m_sAccountName
        m_labelLocalVersion.text = "version: \(gDC.m_appVersion)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        m_btnAccountLogo.setImage(gDC.mAccountInfo.m_imageAccountHead, for: UIControlState())
        m_labelAccountName.text = gDC.mAccountInfo.m_sAccountName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //手指初次按下
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            return
        }
        let touch:UITouch = touches.first! as UITouch
        var point = touch.location(in: self.view)
        point.y = point.y - 20
        if (m_vMyMaster.frame.contains(point)) {
            m_vMyMaster.backgroundColor = gDC.m_colorTouching
            m_labelMyMaster.backgroundColor = gDC.m_colorTouching
        }else if (m_vReconnect.frame.contains(point)) {
            m_vReconnect.backgroundColor = gDC.m_colorTouching
            m_labelReconnect.backgroundColor = gDC.m_colorTouching
        }else if (m_vSetting.frame.contains(point)) {
            m_vSetting.backgroundColor = gDC.m_colorTouching
            m_labelSetting.backgroundColor = gDC.m_colorTouching
        }else if (m_vJdPlay.frame.contains(point)) {
            m_vJdPlay.backgroundColor = gDC.m_colorTouching
            m_labelJdPlay.backgroundColor = gDC.m_colorTouching
        }
    }

    //手指移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            return
        }
        let touch:UITouch = touches.first! as UITouch
        var point = touch.location(in: self.view)
        point.y = point.y - 20
        if (m_vMyMaster.frame.contains(point)) {
            m_vMyMaster.backgroundColor = gDC.m_colorTouching
            m_labelMyMaster.backgroundColor = gDC.m_colorTouching
            m_vReconnect.backgroundColor = UIColor.white
            m_labelReconnect.backgroundColor = UIColor.white
            m_vJdPlay.backgroundColor = UIColor.white
            m_labelJdPlay.backgroundColor = UIColor.white
            m_vSetting.backgroundColor = UIColor.white
            m_labelSetting.backgroundColor = UIColor.white
        }else if (m_vReconnect.frame.contains(point)) {
            m_vMyMaster.backgroundColor = UIColor.white
            m_labelMyMaster.backgroundColor = UIColor.white
            m_vReconnect.backgroundColor = gDC.m_colorTouching
            m_labelReconnect.backgroundColor = gDC.m_colorTouching
            m_vJdPlay.backgroundColor = UIColor.white
            m_labelJdPlay.backgroundColor = UIColor.white
            m_vSetting.backgroundColor = UIColor.white
            m_labelSetting.backgroundColor = UIColor.white
        }else if (m_vJdPlay.frame.contains(point)){
            m_vMyMaster.backgroundColor = UIColor.white
            m_labelMyMaster.backgroundColor = UIColor.white
            m_vReconnect.backgroundColor = UIColor.white
            m_labelReconnect.backgroundColor = UIColor.white
            m_vJdPlay.backgroundColor = gDC.m_colorTouching
            m_labelJdPlay.backgroundColor = gDC.m_colorTouching
            m_vSetting.backgroundColor = UIColor.white
            m_labelSetting.backgroundColor = UIColor.white
        }else if (m_vSetting.frame.contains(point)) {
            m_vMyMaster.backgroundColor = UIColor.white
            m_labelMyMaster.backgroundColor = UIColor.white
            m_vReconnect.backgroundColor = UIColor.white
            m_labelReconnect.backgroundColor = UIColor.white
            m_vJdPlay.backgroundColor = UIColor.white
            m_labelJdPlay.backgroundColor = UIColor.white
            m_vSetting.backgroundColor = gDC.m_colorTouching
            m_labelSetting.backgroundColor = gDC.m_colorTouching
        }else {
            m_vMyMaster.backgroundColor = UIColor.white
            m_labelMyMaster.backgroundColor = UIColor.white
            m_vReconnect.backgroundColor = UIColor.white
            m_labelReconnect.backgroundColor = UIColor.white
            m_vJdPlay.backgroundColor = UIColor.white
            m_labelJdPlay.backgroundColor = UIColor.white
            m_vSetting.backgroundColor = UIColor.white
            m_labelSetting.backgroundColor = UIColor.white
        }
    }
    
    //判断手指在哪里点击结束，用于判断选择了哪个功能选项，待扩展
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 1 {
            return
        }
        m_vMyMaster.backgroundColor = UIColor.white
        m_labelMyMaster.backgroundColor = UIColor.white
        m_vReconnect.backgroundColor = UIColor.white
        m_labelReconnect.backgroundColor = UIColor.white
        m_vJdPlay.backgroundColor = UIColor.white
        m_labelJdPlay.backgroundColor = UIColor.white
        m_vSetting.backgroundColor = UIColor.white
        m_labelSetting.backgroundColor = UIColor.white
        let touch:UITouch = touches.first! as UITouch
        var point = touch.location(in: self.view)
        point.y = point.y - 20
        if (m_vMyMaster.frame.contains(point)) {
            print("点击了我的主机菜单")
            self.performSegue(withIdentifier: "myMaster", sender: self)
        }else if (m_vReconnect.frame.contains(point)) {
            print("点击了本地重连菜单")
            ReconnectToLocal()
        }else if (m_vJdPlay.frame.contains(point)) {
            print("点击了背景音乐菜单")
            OnJdPlay()
        }else if (m_vSetting.frame.contains(point)) {
            print("点击了设置菜单")
            self.performSegue(withIdentifier: "setting", sender: self)
        }
    }
    
    //重连到本地主机
    func ReconnectToLocal() {
        if gDC.m_bRemote == false {//说明是本地，不需要执行
            return
        }
        DispatchQueue.main.async {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            self.m_viewLoading = SCLAlertView(appearance: appearance)
            self.m_viewLoading.showInfo("提示", subTitle: " 正在重新连接......", duration: 0)
        }
        MyWebService.sharedInstance.StopPolling()
        //需要搜索本地的主节点，以确定是远程控制还是本地socket通信，同时还要确保获取的主机编号没有问题
        print("当前主节点标号为：\(gDC.mUserInfo.m_sMasterCode)")
        print("当前主节点IP为：  \(gDC.mUserInfo.m_sUserIP)")
        var sResult:String = ""
        var bLegalMaster:Bool = false
        for _ in 0..<3 {
            sResult = MySocket.sharedInstance.GetMasterCode(gDC.mUserInfo.m_sUserIP, style: GET_MASTER_CODE)
            var bLegal:Bool = true
            for ch in sResult.characters {
                if (ch>="0"&&ch<="9") || (ch>="a"&&ch<="z") || (ch>="A"&&ch<="Z") {//如果满足三个条件任意一个，可以认为符号没有问题
                    continue
                }else {
                    bLegal = false
                    break
                }
            }
            if bLegal == true {
                bLegalMaster = true
                break
            }
        }
        if bLegalMaster == false {
            ShowNoticeDispatch("错误", content: "搜索到的主机编码有问题，请试着重新搜索主机", duration: 1.5)
            self.m_viewLoading.hideView()
            return
        }
        print("搜索到的主节点编号为：\(sResult)")
        if gDC.mUserInfo.m_sMasterCode == sResult {
            ShowInfoDispatch("提示", content: "本地连接成功", duration: 0.8)
            let dictsElectricState = MyWebService.sharedInstance.GetElectricStateByUser(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode)
            gDC.mElectricData.UpdateElectricState(dictsElectricState)
            gDC.m_bRemote = false
            MySocket.sharedInstance.InitReceiveTcpSocekt()//05.02添加
//            WebSocket.sharedInstance.CloseWebSocket()
        }else {
            ShowNoticeDispatch("提示", content: "本地连接失败", duration: 0.8)
            MyWebService.sharedInstance.OpenPolling()
            gDC.m_bRemote = true
        }
        self.m_viewLoading.hideView()
        g_notiCenter.post(name: Notification.Name(rawValue: "RefreshRemoteState"), object: self)
    }
    
    func OnJdPlay() {
        JdPlayManagerInit()
        NotificationCenter.default.addObserver(self, selector: #selector(LeftMenuViewCtrl.NetworkStateChange), name: NSNotification.Name.reachabilityChanged, object: nil)
        conn = Reachability.forInternetConnection()
        conn?.startNotifier()
        UpdateInterfaceWithReachability(conn!)
        
        let jdCtrl:JdMyDeviceViewController = JdMyDeviceViewController()
        let naviCtrl:UINavigationController = UINavigationController.init(rootViewController: jdCtrl)
        naviCtrl.navigationBar.isHidden = true
        self.present(naviCtrl, animated: true, completion: nil)
    }
    
    //监听网路状态改变
    func NetworkStateChange(note:NSNotification) {
        let curReach:Reachability = note.object as! Reachability
        UpdateInterfaceWithReachability(curReach)
    }
    
    func UpdateInterfaceWithReachability(_ reachability:Reachability) {
        let netStatus:NetworkStatus = reachability.currentReachabilityStatus()
        if (netStatus == ReachableViaWiFi) {
            JdPlay_appOnNetChange(0)
            JdPlay_appOnNetChange(1)
        }else{
            JdPlay_appOnNetChange(0)
        }
    }
    
}





