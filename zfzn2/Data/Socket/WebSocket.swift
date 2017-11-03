//
//  WebSocket.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/10/19.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class WebSocket: NSObject, SRWebSocketDelegate {
    let m_url:String = "http://101.201.211.87:8080/zfzn02/websocket_app/"
    var m_bConnected = false
    var m_bPolling:Bool = false
    var m_timerPolling:Timer!//心跳包定时器，判断本地连接状态
    
    //使用单例模式
    internal static let sharedInstance = WebSocket()
    fileprivate override init() {}
    
    func InitWebSocket() {
//        webSocket.delegate = self
    }
    
    func ConnectToWebSocket(masterCode:String) {
        m_bConnected = true
        let url = NSURL(string: m_url + masterCode)
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
        print("【websocket】连接成功")
        StopPolling()
        //重连后，从服务器调用最新的所有电器的状态
        let dictsElectricState = MyWebService.sharedInstance.GetElectricStateByUser(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode)
        gDC.mElectricData.UpdateElectricState(dictsElectricState)
        g_notiCenter.post(name: Notification.Name(rawValue: "RefreshElectricStates"), object: self)//向所有注册过观测器的界面发送消息
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("【websocket】发生错误")
        CloseWebSocket()
        OpenPolling()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("【websocket】关闭——code:\(code) reason:\(reason) wasClean:\(wasClean)")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print("【websocket】接收到消息——\(message as! String)")
        if (RefreshElectricStates(message as! String) == true) {
            g_notiCenter.post(name: Notification.Name(rawValue: "RefreshElectricStates"), object: self)//向所有注册过观测器的界面发送消息
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        print("【websocket】接收到pong消息")
    }

}
