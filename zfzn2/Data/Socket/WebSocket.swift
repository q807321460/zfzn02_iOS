//
//  WebSocket.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/10/19.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class WebSocket: NSObject, SRWebSocketDelegate {
    let m_urlLocal:String = "http://192.168.0.100:8080/zfzn02/websocket_app/"
    let m_url:String = "http://101.201.211.87:8080/zfzn02/websocket_app/"
    var m_bConnected = false
    var m_bPolling:Bool = false
    var m_timerPolling:Timer!//心跳包定时器，判断本地连接状态
    var m_timerSync:Timer!//接收到同步的消息后，大约在1秒后才执行同步（因为可能另一个手机的做了好几个操作，比如三键开关的重加，有6步操作）
    var m_timerForbidSync:Timer!//接收到同步消息后，大约3秒之内不再接收同步消息
    var m_bSyncing:Bool = false//是否正处于自动同步中，如果是则不同步
    let m_queueSync = DispatchQueue(label: "com.WebSocket.Sync")//自动从服务器同步数据
    
    //使用单例模式
    internal static let sharedInstance = WebSocket()
    fileprivate override init() {}
    
    func InitWebSocket() {
//        webSocket.delegate = self
    }
    
    func ConnectToWebSocket(masterCode:String) {
        m_bConnected = true
        var url:NSURL!
        if (gDC.m_bUseRemoteService == false) {//使用本地服务器
            url = NSURL(string: m_urlLocal + masterCode)
        }else {//使用远程服务器
            url = NSURL(string: m_url + masterCode)
        }
        g_webSocket = SRWebSocket(url: url! as URL)
        g_webSocket.delegate = self
        g_webSocket.open()
    }
    
    func CloseWebSocket() {
        if (m_bConnected==true) {
            g_webSocket.close()
            g_webSocket.delegate = nil
            m_bConnected = false
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //开启心跳包，确定本地连接状态
    func OpenPolling() {
        if m_bPolling == true {
            return
        }
        m_timerPolling = Timer.scheduledTimer(timeInterval: 5, target:self,selector:#selector(WebSocket.RunPolling), userInfo:nil, repeats:true)
        m_bPolling = true
    }
    
    //运行心跳包检测
    func RunPolling() {
        if (gDC.m_bRemote) {//仍然处于远程状态则需要继续尝试websocket连接，否则不连接
            ConnectToWebSocket(masterCode: gDC.mUserInfo.m_sMasterCode)
        }
    }
    
    //结束心跳包检测
    func StopPolling() {
        if m_bPolling == false {
            return
        }
        m_bPolling = false
        m_timerPolling.invalidate()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("【web_socket】连接成功")
        StopPolling()
        //重连后，从服务器调用最新的所有电器的状态
        let dictsElectricState = MyWebService.sharedInstance.GetElectricStateByUser(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode)
        gDC.mElectricData.UpdateElectricState(dictsElectricState)
        g_notiCenter.post(name: Notification.Name(rawValue: "RefreshElectricStates"), object: self)//向所有注册过观测器的界面发送消息
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("【web_socket】发生错误")
        CloseWebSocket()
        OpenPolling()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("【web_socket】关闭——code:\(code) reason:\(reason) wasClean:\(wasClean)")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print("【web_socket】接收到消息——\(message as! String)")
        if (message as! String == "Sync") {
            if (gDC.m_bSyncing == true) {//如果正处于同步中，则忽略这个同步消息
                return
            }
            self.m_timerForbidSync = Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(WebSocket.ForbidSync), userInfo: nil, repeats: false)
            self.m_timerSync = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(WebSocket.AutomaticSync), userInfo: nil, repeats: false)
        }else if ((message as! String).subStringTo(1) == "<") {//说明是电器状态的更新
            if (gDC.m_bRemote == false) {//如果当前是本地连接状态，则自动忽略接收的websocket消息
                return
            }
            if (RefreshElectricStates(message as! String) == true) {
                g_notiCenter.post(name: Notification.Name(rawValue: "RefreshElectricStates"), object: self)//向所有注册过观测器的界面发送消息
            }
        }else {
            print("【web_socket】接收到其他的消息")
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        print("【web_socket】接收到pong消息")
    }

    ////////////////////////////////////////////////////////////////////////////////////
    //同步所有数据
    func AutomaticSync() {
        let bFlag = MyWebService.sharedInstance.ManualSync()
        if (bFlag == 1) {
            //向所有注册过观测器的界面发送消息
            g_notiCenter.post(name: Notification.Name(rawValue: "SyncData"), object: self)
        }else if (bFlag == 0) {
            //向所有注册过观测器的界面发送消息，当前主机被删除，需要退出并重新登录
            g_notiCenter.post(name: Notification.Name(rawValue: "Quit"), object: self)
        }
    }
    
    func ForbidSync() {
        gDC.m_bSyncing = false
    }
    
}
