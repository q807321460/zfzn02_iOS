//
//  MasterSocket.swift
//  zfzn
//
//  Created by Hanwen Kong on 16/9/3.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//  

import Foundation
import UIKit

let SEARCH_MASTER_CODE = 0
let GET_MASTER_CODE = 1
let GET_ELECTRIC_CODE = 2
let GET_ELECTRIC_STATE = 3
let SOCKET_POLLING = 4
let SOCKET_WIFI = 5
let RECEIVE_FROM_MASTER = 100

class MySocket:NSObject, GCDAsyncSocketDelegate, GCDAsyncUdpSocketDelegate {
    
    var m_socketUdp = GCDAsyncUdpSocket()//udp套接字对象
//    var m_socketSendTcp = GCDAsyncSocket()//tcp套接字对象，用于本地
//    var m_socketReceiveTcp = GCDAsyncSocket()//tcp套接字对象，不断接收主机返回的数据，用于本地
    var m_socketTcp = GCDAsyncSocket()//tcp套接字对象，用于本地，即实现发送，又实现接受
    
    var mainQueue = DispatchQueue.main
    var m_timerPolling:Timer!//心跳包定时器，判断本地连接状态
    var m_dispatch_source_timer:DispatchSource?
    var m_currentQueue:DispatchQueue?
    
    var tag:Int = 0
    var m_sReturn:String = ""
    var m_bReceiveTimeout:Bool = false//用于判断接收是否超时
    var m_bDisconnectTimeout:Bool = false//用于判断断开连接是否成功
    var m_dTimeOut:Double!//用于设置定时器的延时
    var m_sArrayUdpReturn = [String]()
    var m_sArrayTcpReturn = [String]()
    var m_sUdpMasterReturn:String = ""
    var m_sTcpMasterReturn:String = ""//点对点发送时返回的字符串
    
    var m_bPolling:Bool = false

    internal static let sharedInstance = MySocket()//使用单例模式
    
    fileprivate override init() {
//        super.init()
    }
    
    //这里的参数至少是1，否则效果可能不好
    func SetTimeOut(_ timeout:Double) {
        self.m_dTimeOut = timeout
    }
    
    func InitUdpSocket() {
        m_socketUdp = GCDAsyncUdpSocket(delegate: self, delegateQueue: mainQueue)
        m_socketUdp?.setIPv6Enabled(false)
        
        do { try m_socketUdp?.bind(toPort: 8001) }//只要不是8899或是48899就可以
        catch { print("bindToPort error");return }
        
        do { try m_socketUdp?.enableBroadcast(true) }
        catch { print("enableBroadcast error");return }
        
        do {try m_socketUdp?.joinMulticastGroup("230.0.0.255")}
        catch {print("joinMulticastGroup error");return}
        
        do { try m_socketUdp?.beginReceiving() }
        catch { print("beginReceiving error");return }
        
        print("【local_socket】成功打开udp socket —— port:\(m_socketUdp?.localPort() ?? UInt16(0)) ip:\(m_socketUdp?.localHost() ?? "0.0.0.0")\n")
    }
    
    func InitTcpSocket() {
        m_socketTcp?.delegate = self
        m_socketTcp?.delegateQueue = DispatchQueue.main
        m_socketTcp?.isIPv6Enabled = true
    }
    
    func OpenTcpSocekt() {
        m_socketTcp?.disconnect()
        m_socketTcp?.delegate = self
        m_socketTcp?.delegateQueue = DispatchQueue.main
        m_socketTcp?.isIPv6Enabled = true
        do { try m_socketTcp?.connect(toHost: gDC.mUserInfo.m_sUserIP, onPort: 8899) }
        catch { print("【local_socket】Tcp connectToHost error") }
        m_socketTcp?.readData(withTimeout: -1, tag: RECEIVE_FROM_MASTER)//无限等待主机的返回
    }
    
    func SearchLocalMaster() {
        //需要搜索本地的主节点，以确定是远程控制还是本地socket通信，同时还要确保获取的主机编号没有问题
        print("上一次使用的主节点编号为：\(gDC.mUserInfo.m_sMasterCode)")//这个应该也是从本地数据库中读取到的，正常不可能为nil
        let sResult:String = GetMasterCode(gDC.mUserInfo.m_sUserIP, style: GET_MASTER_CODE)
        print("根据上一次登录使用的ip值，搜索到的主节点编号为：\(sResult)")
        if gDC.mUserInfo.m_sMasterCode == sResult {
            ShowInfoDispatch("成功", content: "本地连接成功", duration: 0.8)
            gDC.m_bRemote = false
            MySocket.sharedInstance.OpenTcpSocekt()//05.02添加
            let dictsElectricState = MyWebService.sharedInstance.GetElectricStateByUser(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode)
            gDC.mElectricData.UpdateElectricState(dictsElectricState)
            //            WebSocket.sharedInstance.CloseWebSocket()
        }else {
            ShowNoticeDispatch("提示", content: "本地连接失败", duration: 0.8)
            MyWebService.sharedInstance.OpenPolling()
            gDC.m_bRemote = true
        }
        //不论是否本地连接，都要开启websocket服务
        WebSocket.sharedInstance.CloseWebSocket()
        WebSocket.sharedInstance.ConnectToWebSocket(masterCode: gDC.mUserInfo.m_sMasterCode)
    }

    //开启心跳包，确定本地连接状态
    func OpenPolling() {
        m_timerPolling = Timer.scheduledTimer(timeInterval: 3, target:self,selector:#selector(MySocket.RunPolling), userInfo:nil, repeats:true)
    }
    
    //运行心跳包检测
    func RunPolling() {
        CheckLocalConnection()
    }
    
    //结束心跳包检测
    func StopPolling() {
        m_timerPolling.invalidate()
    }
    
    func InitAndStartTimer(_ timeOut:Double) {
        m_bReceiveTimeout = false//确保程序不退出NSRunLoop循环
        if m_dispatch_source_timer != nil {//首先保证函数执行前timer是空的
            self.m_dispatch_source_timer!.cancel()
            m_dispatch_source_timer = nil
        }
        if m_currentQueue == nil {//初始化一个新队列
            m_currentQueue = DispatchQueue(label: "com.my.timeout", attributes: [])
        }
        /*Migrator FIXME: Use DispatchSourceTimer to avoid the cast*/
        m_dispatch_source_timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0), queue: m_currentQueue)  as? DispatchSource//初始化消息响应
        var nTimeOut:UInt64 = UInt64(timeOut)//设置多线程的倒计时处理 nTimeOut*NSEC_PER_SEC)

        m_dispatch_source_timer!.scheduleRepeating(deadline: .now(), interval: .seconds(Int(timeOut)))
        //设置定时处理的具体实现
        m_dispatch_source_timer!.setEventHandler {
            if nTimeOut <= 0 {//如果超时
                self.m_dispatch_source_timer!.cancel()
                self.m_bReceiveTimeout = true
                DispatchQueue.main.async(execute: {//触发主线程时，可以退出NSRunLoop循环
//                    print("倒计时结束，socket接收完成")
                })
            }else {
                nTimeOut = 0//第一次会进入这里
            }
        }
        m_dispatch_source_timer!.resume()//开启多线程的倒计时
        //进入while循环，无限等待，但是又不能让程序锁死，等待超时的结束并且程序进入主线程
        while m_bReceiveTimeout == false {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture as Date)
        }
    }
    
    //配网
    func ConfWifi(sWifi:String, sPassWord:String) {
        m_socketTcp?.disconnect()
        do { try m_socketTcp?.connect(toHost: "192.168.4.1", onPort: 8899) }
        catch { print("connectToHost error") }
        let sCmd:String = "<<" + sWifi + "," + sPassWord + ">>\r\n"
        print("【local_socket】tcp发送的数据为——\(sCmd)")
        let data:Data = sCmd.data(using: String.Encoding.utf8)!
        m_socketTcp?.write(data, withTimeout: -1, tag: 0)
    }
    
    //获得主节点Code，在这里首次执行sendSocket的连接
    @discardableResult func GetMasterCode(_ ip:String, style:Int) -> String {
        m_socketTcp?.disconnect()
        do { try m_socketTcp?.connect(toHost: ip, onPort: 8899) }
        catch { print("connectToHost error");return "" }
        SetTimeOut(3)
        let sCmd = "<00000000U0**********A9>\r\n"
        print("【local_socket】tcp发送——\(sCmd) 目标IP——\(ip)")
        let data:Data = sCmd.data(using: String.Encoding.utf8)!
        m_sTcpMasterReturn = ""
        m_socketTcp?.write(data, withTimeout: -1, tag: 0)
        if style == SEARCH_MASTER_CODE {
            m_socketTcp?.readData(withTimeout: -1, tag: SEARCH_MASTER_CODE)//主节点tag为0
            InitAndStartTimer(m_dTimeOut)//初始化超时等的设置
            return ""
        } else {
            m_socketTcp?.readData(withTimeout: -1, tag: GET_MASTER_CODE)//主节点tag为1
            InitAndStartTimer(m_dTimeOut)//初始化超时等的设置
            return m_sTcpMasterReturn
        }
    }
    
    //搜索主节点IP
    func SearchMasterNodeIP() -> ([String], [String]) {
        //每次socket通信前，一定要清空通信时的缓存数据
        self.m_sArrayTcpReturn.removeAll()
        self.m_sArrayUdpReturn.removeAll()
        //在这里应当使用的是当前局域网的IP
        let sCmd = "HF-A11ASSISTHREAD"
        print("udp发送——\(sCmd)")
        let data:Data = sCmd.data(using: String.Encoding.utf8)!
        let sRouterIP:String! = GetRouterAddress()
        //利用点号将ip分成4段，将最后一段改为255
        let splitedArray = sRouterIP.components(separatedBy: ".")
        print("拆分后的数组：\(splitedArray)")
        let sRouterUdpIP:String! = splitedArray[0] + "." + splitedArray[1] + "." + splitedArray[2] + ".255"
        print("当前路由广播IP：\(sRouterUdpIP)")
        SetTimeOut(3)
        m_socketUdp?.send(data, toHost: sRouterUdpIP, port: 48899, withTimeout: -1, tag: 0)
        InitAndStartTimer(m_dTimeOut)//初始化超时等的设置
        print("【local_socket】总共接收到\(m_sArrayUdpReturn.count)组IP数据")
        for i in 0..<m_sArrayUdpReturn.count {
            GetMasterCode(m_sArrayUdpReturn[i], style: SEARCH_MASTER_CODE)
        }
        print("MasterIP: \(m_sArrayTcpReturn)  \(m_sArrayUdpReturn)")
        return (m_sArrayTcpReturn, m_sArrayUdpReturn)
    }

    //从本地主机获取所有电器状态
    func GetElectricStatesAll(_ ip:String) {
        for _ in 0..<3 {
            let sCmd = "230000000003000023\r\n"
            print("GetElectricStatesAll tcp发送——\(sCmd)")
            let data:Data = sCmd.data(using: String.Encoding.utf8)!
            m_sTcpMasterReturn = ""
            m_socketTcp?.write(data, withTimeout: -1, tag: 0)
            m_socketTcp?.readData(withTimeout: -1, tag: GET_ELECTRIC_STATE)//主节点tag为1
            InitAndStartTimer(m_dTimeOut)//初始化超时等的设置
            print("GET_ELECTRIC_STATE return: \(m_sTcpMasterReturn)")
            if m_sTcpMasterReturn != "" {
                break
            }
        }
    }
    
    //添加电器时使用的函数，获取电器编号
    func GetElectricCodeFromMaster(_ sendString:String) -> String {
        let sCmd:String = ModifyMarkBit(sendString)//做一个校验位的改动，将末位的校验位00修改掉，并不影响socket的正常通信
        SetTimeOut(2.0)//提供...秒的搜索时间
        for _ in 0..<2 {
            print("【local_socket】tcp发送数据——\(sendString)")
            let data:Data = sCmd.data(using: String.Encoding.utf8)!
            m_sTcpMasterReturn = ""
            m_socketTcp?.write(data, withTimeout: -1, tag: 0)
            m_socketTcp?.readData(withTimeout: -1, tag: GET_ELECTRIC_CODE)
            InitAndStartTimer(m_dTimeOut)//初始化超时等的设置
            if m_sTcpMasterReturn.characters.count == 0 {
                print("没有接收到有效的电器编号")
            }else {
                let sStartChar:String = (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(0, 1))
                if sStartChar == "#" {
                    var sReturn:String = ""
                    let sEndChar:String = (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(23, 1))
                    if sEndChar == "#" {
                        sReturn = (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(1, 8))
                    }else {
                        sReturn = (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(1, 12))
                    }
                    if sReturn == gDC.mUserInfo.m_sMasterCode {//有可能接收到的是主机编号......
                        print("接收到的编号是有问题的——\(sReturn)")
                        return ""
                    }else {
                        print("接收到有效的电器编号——\(sReturn)")
                        return sReturn
                    }
                }else {
                    print("没有接收到有效的电器编号")
                }
            }
        }
        return ""
    }
    
    //用于控制电器
    func OperateElectric(_ sendString:String) {
        let sCmd:String = ModifyMarkBit(sendString)
        let data:Data = sCmd.data(using: String.Encoding.utf8)!
        m_socketTcp?.write(data, withTimeout: -1, tag: 0)//只需要发送，不需要接收
        print("【local_socket】tcp发送数据——\(sCmd)")
    }

    //每次控制电器时都测试一下本次连接状态，如果连接不上就使用远程控制
    func CheckLocalConnection() {
        if gDC.m_bRemote == true {//只能从本socekt控制切换为web控制，而不能从web切换为本地socket
            return
        }
        if m_socketTcp?.isConnected == true {
            gDC.m_bRemote = false
        }else {
            print("【local_socket】状态——断开，启用远程web控制")
            DispatchQueue.main.async(execute: {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.showNotice("提示", subTitle: "已断开本地连接", duration: 1.5)
            })
            gDC.m_bRemote = true
            g_notiCenter.post(name: Notification.Name(rawValue: "RefreshRemoteState"), object: self)
            MyWebService.sharedInstance.OpenPolling()//开启web的轮询,如果已经开启则不需要继续开启
//            WebSocket.sharedInstance.ConnectToWebSocket(masterCode: gDC.mUserInfo.m_sMasterCode)
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////
    //udp delegate 接收
    internal func udpSocket(_ sock: GCDAsyncUdpSocket!, didReceive data: Data!, fromAddress address: Data!, withFilterContext filterContext: Any!) {
        //获得从主节点返回的数据，为IP地址
        m_sUdpMasterReturn = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        print("【local_socket】udp返回数据——\(m_sUdpMasterReturn)")
        let splitedArray = m_sUdpMasterReturn.components(separatedBy: ",")
        //向这个地址发送tcp消息，从而获得Code
        m_sArrayUdpReturn.append(splitedArray[0])
    }
    
    //tcp delegate 成功连接后
    internal func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
//        print("local tcp socket—— ip:\(sock.localHost) port:\(sock.localPort)")
    }
    
    //tcp delegate 取消连接
    internal func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error) {
//        print("关闭tcp socket —— ip:\(sock.localHost) port:\(sock.localPort)")
    }
    
    //tcp delegate 接收消息
    func socket(_ sock: GCDAsyncSocket!, didRead data: Data!, withTag tag: Int) {
        if tag == SEARCH_MASTER_CODE {//搜索主机，可能返回多个主机
            m_sTcpMasterReturn = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            print("【local_socket】tcp返回数据——\(m_sTcpMasterReturn)")
            if (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(0, 1)) == "#" {//确保不出现乱码
                m_sTcpMasterReturn = (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(1, 8))
                m_sArrayTcpReturn.append(m_sTcpMasterReturn)
            }
        }else if tag == GET_MASTER_CODE {//只搜索单个的主机编号
            m_sTcpMasterReturn = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            print("【local_socket】tcp返回数据——\(m_sTcpMasterReturn)")
            if (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(0, 1)) == "#" {//确保不出现乱码
                m_sTcpMasterReturn = (m_sTcpMasterReturn as NSString).substring(with: NSMakeRange(1, 8))
            }
        }else if tag == GET_ELECTRIC_CODE {//从主机获取返回的电器编号，一般是添加电器时使用
            m_sTcpMasterReturn = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        }else if tag == GET_ELECTRIC_STATE {//用于接收所有的电器状态，同时用于判断当前的连接状态，这里有待改进
            m_sTcpMasterReturn = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            m_bReceiveTimeout = true
        }else if tag == RECEIVE_FROM_MASTER {//只用于接收主机主动返回的数据，一般是手动控制某个电器后返回的新状态
            var sReceive:String = ""
            sReceive = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String//TODO：这里发生过闪退
            print("【local_socket】tcp返回——\(sReceive)")
            if (RefreshElectricStates(sReceive) == true) {
                g_notiCenter.post(name: Notification.Name(rawValue: "RefreshElectricStates"), object: self)//向所有注册过观测器的界面发送消息
            }
            m_socketTcp?.readData(withTimeout: -1, tag: RECEIVE_FROM_MASTER)//继续等待主机的返回
        }else{
            print("【local_socket】没有接收到期望的tag，当前tag为\(tag)")
        }
    }
}















