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
    
    var strSsid:String = ""
    var strPassword:String = ""
    
    var queue:OperationQueue? = nil
    
    let tapRec = UITapGestureRecognizer()
    
    @IBOutlet weak var mSsid: UITextField!
    @IBOutlet weak var mPassword: UITextField!
    
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
    
    @IBOutlet weak var mBtn: UIButton!
    @IBAction func onToggleSend(_ sender: UIButton) {
        
        strSsid = mSsid.text ?? ""
        print("ssid: \(strSsid)")
        strPassword = mPassword.text ?? ""
        print("password: \(strPassword)")
        
        self.tappedView()
        
        if (queue != nil)  {
            print("last queue exist")
            queue?.cancelAllOperations()
            queue = nil
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
            sender.setTitle("Stop", for:UIControlState())

            queue = OperationQueue()
            queue?.maxConcurrentOperationCount = 5
            queue?.addOperation { () -> Void in
                while self.sendInProgress {
                    let ipAddress = self.getIPAddressForCurrentWiFi()
                    print("ip :\(ipAddress ?? "")")
                    let ip: UInt32 = self.getIPForCurrentWiFi()
                    let ret = SmartConfigClient.send(withSSID: self.strSsid, password: self.strPassword, ip: ip)
                    print("ret=\(ret)")
                }
            }
            
            if(!strSsid.isEmpty && !strPassword.isEmpty){
                var userInfo:Dictionary<String, String> = Dictionary(minimumCapacity: 2);
                userInfo["password"] = strPassword
                VoiceUserInfo.setUserInfo(forKey: strSsid, userInfoDic: userInfo)
            }
            
            SmartConfigClient.setRecvTimeout(120)
            SmartConfigClient.startReciver(self)
        } else {
            SmartConfigClient.stopReciver()
            sendInProgress = false
            sender.setTitle("Start", for:UIControlState())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mBtn.layer.borderWidth = 1.0
        mBtn.layer.borderColor = UIColor.lightGray.cgColor
        mBtn.layer.cornerRadius = 5.0
        
        self.tapRec.addTarget(self, action: #selector(VoiceConfWifiViewCtrl.tappedView))
        self.view.addGestureRecognizer(tapRec)
        
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
                    self.mSsid.text = s
                    var userInfo:Dictionary<String, String>? = nil;
                    userInfo = VoiceUserInfo.getUserInfo(forKey: s!)
                    self.mPassword.text = userInfo?["password"]
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SmartConfigClient.stopReciver()
        self.sendInProgress = false;
        self.mBtn.setTitle("Start", for:UIControlState())
        if(queue != nil){
            queue?.cancelAllOperations()
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
    
//  MARK: -
    
    @objc func tappedView(){
        DispatchQueue.main.async {
            self.mSsid.resignFirstResponder()
            self.mPassword.resignFirstResponder()
        }
    }
    
    
    func getSSIDForCurrentWiFi() -> String? {
        if !reachability.isReachableViaWiFi {
            return nil
        }
        
        if let ifs:NSArray = CNCopySupportedInterfaces() {
            for x in ifs {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    let ssid = dict["SSID"]
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
                        self.mSsid.text = s
                        var userInfo:Dictionary<String, String>? = nil;
                        userInfo = VoiceUserInfo.getUserInfo(forKey: s!)
                        self.mPassword.text = userInfo?["password"]
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
            self.mBtn.setTitle("Start", for:UIControlState())
        }
    }
    
    func onError(_ errorCode: Int32) {
        print("onError \(errorCode)")
        let errorDesc = String(describing: SmartConfigError.errorDescription(errorCode))
        DispatchQueue.main.async {
            if(errorCode != 2003) {
                self.view.makeToast("onError \(errorDesc)")
                self.sendInProgress = false
                self.mBtn.setTitle("Start", for:UIControlState())
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
            self.mBtn.setTitle("Start", for:UIControlState())
        }
    }
    
}

