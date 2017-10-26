//
//  AppDelegate.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/10/17.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {//, GCDAsyncSocketDelegate, GCDAsyncUdpSocketDelegate

    var window: UIWindow?
    var m_bBlockRotation:Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        InitPlistData()//初始化plist文件数据，用于确定一些简单的设置
        g_SQLiteDB = SQLiteDB.shared//获得该类的单例
        g_SQLiteDB.openDB()
        MyWebService.sharedInstance.InitURLSession()//初始化服务器对象，用于和远程webservice通信
        PublicWebService.sharedInstance.InitURLSession()//初始化服务器对象，用于和远程webservice通信
        //初始化tcp和udp的连接
        MySocket.sharedInstance.InitUdpSocket()
        MySocket.sharedInstance.InitSendTcpSocket()
        MySocket.sharedInstance.OpenPolling()
        //初始化websocket连接
        WebSocket.sharedInstance.InitWebSocket()
        //测试函数
        TempFunc()
        //将来可能需要在这里添加小智的功能
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        JdPlay_appOnSuspend()
        //程序进入后台保持socket长连接
        let app:UIApplication = UIApplication.shared
        var bgTask = UIBackgroundTaskIdentifier()
        bgTask = app.beginBackgroundTask(expirationHandler: {
            DispatchQueue.main.async() {
                if (bgTask != UIBackgroundTaskInvalid) {
                    bgTask = UIBackgroundTaskInvalid
                }
            }
        })
        DispatchQueue.global().async(){
            DispatchQueue.main.async() {
                if (bgTask != UIBackgroundTaskInvalid) {
                    bgTask = UIBackgroundTaskInvalid
                }
            }
        }
        //进入后台后，需要断开与web的连接，不再进行轮询
        MyWebService.sharedInstance.StopPolling()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        JdPlay_appOnResume()
        //进入前台后，需要重新与web保持连接
        MyWebService.sharedInstance.OpenPolling()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.m_bBlockRotation{
            return UIInterfaceOrientationMask.all//各个方向都可以
        }else{
            return UIInterfaceOrientationMask.portrait//仅竖屏
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////









