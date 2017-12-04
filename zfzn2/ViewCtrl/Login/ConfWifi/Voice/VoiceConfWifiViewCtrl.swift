//
//  ViewController.swift
//  CooeeDemo
//
//  Created by guang on 2/8/15.
//  Copyright (c) 2015 guang. All rights reserved.
//

import UIKit
import SystemConfiguration

class VoiceConfWifiViewCtrl : UIViewController, SmartConfigReciverDelegate{
    
    var m_sSsid:String = ""
    var m_sPassword:String = ""
    var m_queue:OperationQueue? = nil
    let m_tapRec = UITapGestureRecognizer()
    var sendInProgress: Bool = false {
        didSet {
            if sendInProgress {
                print("start sending")
            } else {
                print("end sending")
            }
        }
    }
    // MyReachability必须一直存在，所以需要设置为全局变量
    let reachability = VoiceReachability()!
    @IBOutlet weak var m_eSsid: UITextField!
    @IBOutlet weak var m_ePassword: UITextField!
    @IBOutlet weak var m_btnConf: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.m_btnConf.layer.cornerRadius = 5.0
        self.m_btnConf.layer.masksToBounds = true
        self.m_tapRec.addTarget(self, action: #selector(VoiceConfWifiViewCtrl.tappedView))
        self.view.addGestureRecognizer(m_tapRec)
        SmartConfigClient.enableDebugMode(true)
        self.setNetworkStatusListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!self.reachability.isReachableViaWiFi){
            DispatchQueue.main.async {
                self.view.makeToast("未连接到WiFi网络")
            }
        }
        else{
            let s = getSSIDForCurrentWiFi()
            if s != nil {
                DispatchQueue.main.async {
                    self.m_eSsid.text = s
                    var userInfo:Dictionary<String, String>? = nil;
                    userInfo = VoiceUserInfo.getUserInfo(forKey: s!)
                    self.m_ePassword.text = userInfo?["password"]
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SmartConfigClient.stopReciver()
        self.sendInProgress = false;
        self.m_btnConf.setTitle("开始配网", for:UIControlState())
        if(m_queue != nil){
            m_queue?.cancelAllOperations()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {
            print("从语音配网界面返回到登录界面")
        })
    }
    
    @IBAction func OnConf(_ sender: UIButton) {
        m_sSsid = m_eSsid.text ?? ""
        print("ssid: \(m_sSsid)")
        m_sPassword = m_ePassword.text ?? ""
        print("password: \(m_sPassword)")
        self.tappedView()
        if (m_queue != nil)  {
            print("last queue exist")
            m_queue?.cancelAllOperations()
            m_queue = nil
        }
        if !sendInProgress {
            if !self.reachability.isReachableViaWiFi {
                print("wifi not connected")
                DispatchQueue.main.async {
                    self.view.makeToast("WiFi not connected")
                }
                return
            }
            print("wifi connected")
            sendInProgress = true
            sender.setTitle("停止配网", for:UIControlState())
            m_queue = OperationQueue()
            m_queue?.maxConcurrentOperationCount = 5
            m_queue?.addOperation { () -> Void in
                while self.sendInProgress {
                    let ipAddress = self.getIPAddressForCurrentWiFi()
                    print("ip :\(ipAddress ?? "")")
                    let ip: UInt32 = self.getIPForCurrentWiFi()
                    let ret = SmartConfigClient.send(withSSID: self.m_sSsid, password: self.m_sPassword, ip: ip)
                    print("ret=\(ret)")
                }
            }
            if(!m_sSsid.isEmpty && !m_sPassword.isEmpty){
                var userInfo:Dictionary<String, String> = Dictionary(minimumCapacity: 2);
                userInfo["password"] = m_sPassword
                VoiceUserInfo.setUserInfo(forKey: m_sSsid, userInfoDic: userInfo)
            }
            SmartConfigClient.setRecvTimeout(30)
            SmartConfigClient.startReciver(self)
        } else {
            SmartConfigClient.stopReciver()
            sendInProgress = false
            sender.setTitle("开始配网", for:UIControlState())
        }
    }
//  MARK: -
    
    @objc func tappedView(){
        DispatchQueue.main.async {
            self.m_eSsid.resignFirstResponder()
            self.m_ePassword.resignFirstResponder()
        }
    }
    
    
    func getSSIDForCurrentWiFi() -> String? {
        if !reachability.isReachableViaWiFi {
            return nil
        }
        
        if let ifs:NSArray = CNCopySupportedInterfaces() {
            for x in ifs {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    let ssid = (dict as! NSMutableDictionary)["SSID"]
                    return ssid as? String
                }
            }
        }
        
        return nil
    }
    
    // 获取当前wifi的IP地址
    func getIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return address
    }
    
    // 获取当前wifi的IP地址
    func getIPForCurrentWiFi() -> UInt32{
        let address = self.getIPAddressForCurrentWiFi()
        var ad = ["0","0","0","0"]
        ad = (address?.components(separatedBy: "."))!

        return ((UInt32(ad[3])! & 0xff)<<24) | ((UInt32(ad[2])! & 0xff)<<16) | ((UInt32(ad[1])! & 0xff)<<8) | ((UInt32(ad[0])! & 0xff))
    }
    
    func setNetworkStatusListener() {
        // 1、设置网络状态消息监听
        // 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! VoiceReachability
        if reachability.isReachable {
            print("网络连接：可用")
            if reachability.isReachableViaWiFi {
                DispatchQueue.main.async {
                    self.view.makeToast("已切换到WIFI网络")
                }
                let s = getSSIDForCurrentWiFi()
                if s != nil {
                    DispatchQueue.main.async {
                        self.m_eSsid.text = s
                        var userInfo:Dictionary<String, String>? = nil;
                        userInfo = VoiceUserInfo.getUserInfo(forKey: s!)
                        self.m_ePassword.text = userInfo?["password"]
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    self.view.makeToast("已切换到移动网络")
                }
            }
        } else {
            print("网络连接：不可用")
            DispatchQueue.main.async {
                self.view.makeToast("未连接到网络")
            }
        }
    }


//  MARK: - SmartConfigReciverDelegate
    
    func onReceived(_ message: SmartConfigNotifyMessage!) {
        print("onReceived ip:\(message.ip)  port:\(message.port)  mac:\(message.mac)  hostname:\(message.hostName)")
        DispatchQueue.main.async {
            self.view.makeToast("onReceived ip:\(message.ip)  port:\(message.port)  mac:\(message.mac)  hostname:\(message.hostName)")
            self.sendInProgress = false
            self.m_btnConf.setTitle("开始配网", for:UIControlState())
        }
    }
    
    func onError(_ errorCode: Int32) {
        print("onError \(errorCode)")
        let errorDesc = String(describing: SmartConfigError.errorDescription(errorCode))
        DispatchQueue.main.async {
            if(errorCode != 2003) {
                self.view.makeToast("onError \(errorDesc)")
                self.sendInProgress = false
                self.m_btnConf.setTitle("开始配网", for:UIControlState())
            } else{
                self.view.makeToast("\(errorDesc)")
            }

        }
    }
    
    func onTimeout() {
        print("timeout")
        DispatchQueue.main.async {
            self.view.makeToast("timeout")
            self.sendInProgress = false
            self.m_btnConf.setTitle("开始配网", for:UIControlState())
        }
    }
    
}

