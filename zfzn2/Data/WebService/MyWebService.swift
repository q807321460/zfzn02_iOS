 //
//  MyWebService.swift
//  zfzn
//
//  Created by Hanwen Kong on 16/7/11.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//
//用于远程网络服务器的连接
import Foundation
import UIKit

class MyWebService: NSObject,URLSessionDelegate,URLSessionDataDelegate {
    var m_URL_zfzn:URL!//兆峰服务器URL
    var m_URLNameSpace_zfzn:String!//web命名空间
    var m_URLRequest_zfzn:NSMutableURLRequest!
    
    var m_URLSession:URLSession!
    var m_URLSessionCfg:URLSessionConfiguration!
    
    var m_timerPolling:Timer!
    var m_bPolling:Bool = false
    
    internal static let sharedInstance = MyWebService()//保证是单例运行
    
    fileprivate override init() {
        //        super.init()
    }
    
    /************************************************************************************/
    //以下是基本的web处理函数//
    func InitURLSession(){
        m_URLSessionCfg = URLSessionConfiguration.default
        m_URLSessionCfg?.timeoutIntervalForRequest = 5
        m_URLNameSpace_zfzn = "\"http://ws.smarthome.zfznjj.com/\""
        m_URLSession = URLSession(configuration: m_URLSessionCfg!, delegate: self, delegateQueue: nil)
        if gDC.m_bUseRemoteService == true {//远程服务器
            m_URL_zfzn = URL(string: "http://101.201.211.87:8080/zfzn02/services/smarthome?wsdl=SmarthomeWs.wsdl")!
        }else {//本地服务器
            m_URL_zfzn = URL(string: "http://192.168.0.100:8080/zfzn02/services/smarthome?wsdl=SmarthomeWs.wsdl")!
        }
        m_URLRequest_zfzn = NSMutableURLRequest.init(url: m_URL_zfzn!)
        m_URLRequest_zfzn!.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        m_URLRequest_zfzn!.httpMethod = "POST"
    }
    
    //根据需求从返回数组中获取相关数据（这里的逻辑写的很不好。。。暂时先用着） arrayKeyRes: NSArray
    func GetReturnValue(_ methodName:String, dict:NSDictionary, returnType: String) -> (mainValue:AnyObject, bEmpty:Bool){
        var valueString:String = ""
        var valueDicts = [NSDictionary]()
        var data = [NSDictionary]()
        for _:Int in 0..<2{
            data.append(NSDictionary())
        }
        data[0] = dict.object(forKey: "soap:Body") as! NSDictionary
        data[1] = data[0].object(forKey: "ns2:\(methodName)"+"Response") as! NSDictionary
        
        if returnType=="dicts" {
            //如果返回的是结构体数组，则返回整个结构体的数组
            for _:Int in 0..<100{
                valueDicts.append(NSDictionary())
            }
            let nCount:Int = data[1].count
            if nCount==1 {//说明返回的值中没有有效数据
                return ("null" as AnyObject,true)//false说明返回的值中没有有效数据
            }
            var things:AnyObject!
            things = data[1].object(forKey: "ns2:result") as AnyObject
            switch things {
            case _ as NSDictionary:
//                print("只有一个结果")
                valueDicts.removeAll()
                valueDicts.append(data[1].object(forKey: "ns2:result") as! NSDictionary)
            case _ as [NSDictionary]:
//                print("有多个结果")
                valueDicts = data[1].object(forKey: "ns2:result") as! [NSDictionary]
            default:
                break
            }
            return (valueDicts as AnyObject, false)
        }else if returnType=="string"{
            //如果返回的是单一字符串
            if (data[1]["ns2:result"] != nil) {
                valueString = data[1].object(forKey: "ns2:result") as! String
            }else {
                valueString = ""
            }
            return (valueString as AnyObject, false)
        }else {
            return ("otherType" as AnyObject, false)
        }
    }

    /**
     设置Session的部分变量，无参数传入
     - parameter methodName: 由webservice提供的接口
     */
    func SetSessionTask(_ methodName:String){
        let soapMsg:String = String.localizedStringWithFormat(
            "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><\(methodName) xmlns=\"http://ws.smarthome.zfznjj.com/\"></\(methodName)></soap:Body></soap:Envelope>")
        m_URLRequest_zfzn!.httpBody = (soapMsg.data(using: String.Encoding.utf8))
        let msgLength:String = "\(soapMsg.characters.count)"
        m_URLRequest_zfzn!.addValue(msgLength, forHTTPHeaderField: "Content-Length")
    }
    
    /**
     设置Session的部分变量，一个或者多个参数传入
     */
    func SetSessionTask(_ methodName:String, arrayKey: Any, arrayValue: Any){
        let arrayKey2 = arrayKey as! NSArray
        let arrayValue2 = arrayValue as! NSArray
        let length = arrayKey2.count
        var mainMsg:String = ""
        for i:Int in 0..<length{
            let tempMsg:String = String.localizedStringWithFormat("<\(arrayKey2[i])>\(arrayValue2[i])</\(arrayKey2[i])>")
            mainMsg = mainMsg + tempMsg
        }
        m_URLNameSpace_zfzn = "\"http://ws.smarthome.zfznjj.com/\""
        let soapMsg:String = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><\(methodName) xmlns=\"http://ws.smarthome.zfznjj.com/\">\(mainMsg)</\(methodName)></soap:Body></soap:Envelope>"
        m_URLRequest_zfzn!.httpBody = (soapMsg.data(using: String.Encoding.utf8))
        let msgLength:String = "\(soapMsg.characters.count)"
        m_URLRequest_zfzn!.addValue(msgLength, forHTTPHeaderField: "Content-Length")
    }
    
    /**
     获取Session返回的字符串（根据Key数组的值）, arrayKeyRes:Any
     */
    func GetSessionReturn(_ methodName:String, returnType: String) -> (mainValue:AnyObject, bEmpty:Bool){
//        let arrayKeyRes2 = arrayKeyRes as! NSArray
        var sReturn:NSString!
        var xmlDoc:NSDictionary!
        var bReceiving:Bool = true
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        let task = URLSession.shared.dataTask(with: m_URLRequest_zfzn! as URLRequest) {
            (data,response,error) -> Void in
            if error != nil {
                if methodName != "getElectricStateByUser" {//轮询中，当然不能反复提示没有网络啊
                    WebError()
                }
                value = ("WebError" as AnyObject, false)
                bReceiving = false
                //只有当程序进入主线程的时候，才能退出NSRunLoop循环并更新界面
                DispatchQueue.main.async(execute: {})
            }else {
                sReturn = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                xmlDoc = NSDictionary(xmlString: sReturn as String)
//                print("——————————输出Dictionary格式——————————")
//                if methodName == "loadElectricFromWs" {
//                    print("\(xmlDoc)")
//                }
//                print("——————————输出Dictionary格式——————————")
                value = self.GetReturnValue(methodName, dict: xmlDoc, returnType: returnType)//, arrayKeyRes: arrayKeyRes2
                bReceiving = false
                DispatchQueue.main.async(execute: {})//只有当程序进入主线程的时候，才能退出NSRunLoop循环并更新界面
            }
        }
        task.resume()//开始执行命令
        //进入while循环，无限等待，但是又不能让程序锁死
        while bReceiving == true {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture as Date)
        }
        return value
    }
    
    /************************************************************************************/
    //以下是各种具体的功能，但是仍然和数据是绑定的//
    //提供一个通用的接口,可以使用但是会影响主体结构的美观
//    func WebFunc(_ methodName:String, arrayKey:NSArray, arrayValue:NSArray, returnType:String) -> AnyObject {
//        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
//        var value:(mainValue:AnyObject, bEmpty:Bool)!
//        value = GetSessionReturn(methodName, returnType: returnType)
//        if value.bEmpty == true {
//            return []
//        }
//        return value.mainValue
//    }
    
    //向远程服务器添加新的账户，包括手机号，密码，用户昵称
    func AddAccount(_ accountCode:String, passWord:String, accountName:String) -> String{
        let methodName:String = "addAccount"
        let arrayKey = ["accountCode","password","accountName"]
        let arrayValue = [accountCode, passWord, accountName]
        //        let arrayKeyRes = ["ns2:result"]
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        value = GetSessionReturn(methodName, returnType: "string") //, arrayKeyRes: arrayKeyRes
        return value.mainValue as! String
    }
    
    //添加指定user（account和master的绑定）
    func AddUser(_ accountCode:String, masterCode:String, userName:String, userIp:String) -> String{
        let methodName:String = "addUser"
        let arrayKey = ["accountCode","masterCode","userName","userIp"]
        let arrayValue = [accountCode, masterCode, userName, userIp]
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        value = GetSessionReturn(methodName, returnType: "string")
        return value.mainValue as! String
    }
    
    //检测用户名与密码是否正确
    func CheckUserPassword(_ viewCtrl:UIViewController,accountCode:String, password: String) -> String {
        let methodName:String = "validLogin"
        let arrayKey = ["accountCode","password"]
        let arrayValue = [accountCode, password]
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        value = GetSessionReturn(methodName, returnType: "string")
        return value.mainValue as! String
    }
    
    //通过当前的account获取最新的account数据
    func LoadAccount(_ accountCode:String, accountTime:String) -> [NSDictionary] {
        let methodName:String = "loadAccountFromWs"
        let arrayKey = ["accountCode", "accountTime"]
        let arrayValue = [accountCode, accountTime]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //通过当前的account获取最新的user数据
    func LoadUser(_ accountCode:String, userTime:String) -> [NSDictionary] {
        let methodName:String = "loadUserFromWs"
        let arrayKey = ["accountCode", "userTime"]
        let arrayValue = [accountCode, userTime]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //删除user
    func DeleteUser(_ accountCode:String, masterCode:String) ->String {
        let methodName:String = "deleteUser"
        let arrayKey = ["accountCode","masterCode"]
        let arrayValue = [accountCode, masterCode]
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        value = GetSessionReturn(methodName, returnType: "string")
        return value.mainValue as! String
    }
    
    //修改account信息后的更新接口
    func UpdateAccount(_ accountCode:String, accountName:String, accountPhone:String, accountAddress:String, accountEmail:String) -> String {
        let methodName:String = "updateAccount"
        let arrayKey = ["accountCode", "accountName", "accountPhone", "accountAddress", "accountEmail"]
        let arrayValue = [accountCode, accountName, accountPhone, accountAddress, accountEmail]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //判断是否存在指定的账号
    func IsExistAccount(accountCode:String) -> String {
        let methodName:String = "isExistAccount"
        let arrayKey = ["accountCode"]
        let arrayValue = [accountCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //更新AccountCode对应的密码
    func UpdateAccountPassword(_ accountCode:String, oldPassword:String, newPassword:String) -> String {
        let methodName:String = "updateAccountPassword"
        let arrayKey = ["accountCode", "oldPassword", "newPassword"]
        let arrayValue = [accountCode, oldPassword, newPassword]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //短信验证码验证通过后直接修改accountCode对应的密码
    func ResetAccountPassword(_ accountCode:String, newPassword:String) -> String {
        let methodName:String = "resetAccountPassword"
        let arrayKey = ["accountCode", "newPassword"]
        let arrayValue = [accountCode, newPassword]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //更新用户头像
    func UpdateAccountPhoto(_ accountCode:String, photo:String) ->String {
        let methodName:String = "updateAccountPhoto"
        let arrayKey = ["accountCode", "photo"]
        let arrayValue = [accountCode, photo]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //通过account和master获取最新的area列表
    func LoadUserRoom(_ accountCode:String, masterCode:String, areaTime:String) -> [NSDictionary]{
        let methodName:String = "loadUserRoomFromWs"
        let arrayKey = ["accountCode", "masterCode", "areaTime"]
        let arrayValue = [accountCode, masterCode, areaTime]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //添加新的房间
    func AddUserRoom(_ masterCode:String, roomName:String, roomIndex:Int, roomSequ:Int) -> String {
        let methodName:String = "addUserRoom"
        let arrayKey = ["masterCode", "roomName", "roomIndex", "roomSequ", "roomImg"]
        let arrayValue = [masterCode, roomName, roomIndex, roomSequ, 0] as [Any]//暂时不考虑这个img的数值
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        value = GetSessionReturn(methodName, returnType: "string")
        return value.mainValue as! String
    }
    
    //更新area数据
    func UpdateUserRoom(_ masterCode:String, roomIndex:Int, roomName:String, roomImg:Int) -> String {
        let methodName:String = "updateUserRoom"
        let arrayKey = ["masterCode", "roomIndex", "roomName", "roomImg"]//暂时不考虑这个img的数值
        let arrayValue = [masterCode, roomIndex, roomName, 0] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //更新user名字
    func UpdateUserName(accountCode:String, masterCode:String, userName:String) -> String {
        let methodName:String = "updateUserName"
        let arrayKey = ["accountCode", "masterCode", "userName"]
        let arrayValue = [accountCode, masterCode, userName]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    func DeleteRoom(_ masterCode:String, roomIndex:Int, roomSequ:Int) -> String {
        let methodName:String = "deleteRoom"
        let arrayKey = ["masterCode", "roomIndex", "roomSequ"]
        let arrayValue = [masterCode, roomIndex, roomSequ] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    func LoadElectric(_ accountCode:String, masterCode:String, electricTime:String) -> [NSDictionary] {
        let methodName:String = "loadElectricFromWs"
        let arrayKey = ["accountCode", "masterCode", "electricTime"]
        let arrayValue = [accountCode, masterCode, electricTime]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //添加电器
    func AddElectric(_ masterCode:String, electricIndex:Int, electricCode:String, roomIndex:Int, electricName:String, electricSequ:Int, electricType:Int, extra:String, orderInfo:String) ->String {
        let methodName:String = "addElectric"
        let arrayKey = ["masterCode", "electricIndex", "electricCode", "roomIndex", "electricName", "electricSequ", "electricType", "extra", "orderInfo"]
        let arrayValue = [masterCode, electricIndex, electricCode, roomIndex, electricName, electricSequ, electricType, extra, orderInfo] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //删除电器，旧的接口，现在已不再使用
//    func DeleteElectric(_ masterCode:String, electricIndex:Int, electricSequ:Int, roomIndex:Int) -> String {
//        let methodName:String = "deleteElectric"
//        let arrayKey = ["masterCode", "electricIndex", "electricSequ", "roomIndex"]
//        let arrayValue = [masterCode, electricIndex, electricSequ, roomIndex] as [Any]
//        //        //        let arrayKeyRes = ["ns2:result"]
//        var value:(mainValue:AnyObject, bEmpty:Bool)!
//        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
//        value = GetSessionReturn(methodName, arrayKeyRes: arrayKeyRes, returnType: "string")
//        return (value.mainValue as! String)
//    }
    
    //删除电器
    func DeleteElectric1(masterCode:String, electricCode:String, electricIndex:Int, electricSequ:Int, roomIndex:Int) -> String {
        let methodName:String = "deleteElectric1"
        let arrayKey = ["masterCode", "electricCode", "electricIndex", "electricSequ", "roomIndex"]
        let arrayValue = [masterCode, electricCode, electricIndex, electricSequ, roomIndex] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //获取服务器电器状态，用于轮询时使用
    func GetElectricStateByUser(_ accountCode:String, masterCode:String) -> [NSDictionary] {
        let methodName:String = "getElectricStateByUser"
        let arrayKey = ["accountCode", "masterCode"]
        let arrayValue = [accountCode, masterCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        switch value.mainValue {
        case _ as [NSDictionary]:
            return (value.mainValue as! [NSDictionary])
        default:
            return []
        }
    }
    
    //分享主机
    func AddSharedUser(_ accountCode:String, masterCode:String, userName:String, userIp:String) -> String {
        let methodName:String = "addSharedUser"
        let arrayKey = ["accountCode", "masterCode", "userName", "userIp"]
        let arrayValue = [accountCode, masterCode, userName, userIp]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //放弃管理员权限，owner是账号名
    func GiveUpAdmin(_ masterCode:String, owner:String) ->String {
        let methodName:String = "giveUpAdmin"
        let arrayKey = ["masterCode", "owner"]
        let arrayValue = [masterCode, owner]
        //        //        let arrayKeyRes = ["ns2:result"]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //获取管理员权限，owner是账号名
    func AccessAdmin(_ masterCode:String, owner:String) ->String {
        let methodName:String = "accessAdmin"
        let arrayKey = ["masterCode", "owner"]
        let arrayValue = [masterCode, owner]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //修改电器信息
    func UpdateElectric(_ masterCode:String, electricCode:String, electricIndex:Int, electricName:String, sceneIndex:Int)->String {
        let methodName:String = "updateElectric"
        let arrayKey = ["masterCode", "electricCode", "electricIndex", "electricName", "sceneIndex"]
        let arrayValue = [masterCode, electricCode, electricIndex, electricName, sceneIndex] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //修改电器信息1
    func UpdateElectric1(_ masterCode:String, electricCode:String, electricIndex:Int, electricName:String, sceneIndex:Int, electricOrder:String)->String {
        let methodName:String = "updateElectric1"
        let arrayKey = ["masterCode", "electricCode", "electricIndex", "electricName", "sceneIndex", "electricOrder"]
        let arrayValue = [masterCode, electricCode, electricIndex, electricName, sceneIndex, electricOrder] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //远程控制电器，不需要返回值
    func UpdateElectricOrder(_ masterCode:String, electricCode:String, order:String, orderInfo:String) {
        let methodName:String = "updateElectricOrder"
        let arrayKey = ["masterCode", "electricCode", "order", "orderInfo"]
        let arrayValue = [masterCode, electricCode, order, orderInfo]
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        var bReceiving:Bool = true
        let task = URLSession.shared.dataTask(with: m_URLRequest_zfzn! as URLRequest) {
            (data,response,error) -> Void in
            if error != nil{
                WebError()
                bReceiving = false
                DispatchQueue.main.async(execute: {})
            }
            else{
                bReceiving = false
                DispatchQueue.main.async(execute: {})
            }
        }
        task.resume()
        while bReceiving == true {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture as Date)
        }
    }
    
    //加载情景
    func LoadScene(_ accountCode:String, masterCode:String, sceneTime:String) -> [NSDictionary] {
        let methodName:String = "loadSceneFromWs"
        let arrayKey = ["accountCode", "masterCode", "sceneTime"]
        let arrayValue = [accountCode, masterCode, sceneTime]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //加载情景电器
    func LoadSceneElectric(_ accountCode:String, masterCode:String, sceneElectricTime:String) -> [NSDictionary] {
        let methodName:String = "loadSceneElectricFromWs"
        let arrayKey = ["accountCode", "masterCode", "sceneElectricTime"]
        let arrayValue = [accountCode, masterCode, sceneElectricTime]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //添加情景
    func AddScene(_ accountCode:String, masterCode:String, sceneName:String, sceneIndex:Int, sceneSequ:Int, sceneImg:Int)->String {
        let methodName:String = "addScene"
        let arrayKey = ["accountCode","masterCode", "sceneName", "sceneIndex", "sceneSequ", "sceneImg"]
        let arrayValue = [accountCode, masterCode, sceneName, sceneIndex, sceneSequ, 4] as [Any]//新添加的情景默认使用自定义图片
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //删除情景
    func DeleteScene(_ masterCode:String, sceneIndex:Int, sceneSequ:Int)->String {
        let methodName:String = "deleteScene"
        let arrayKey = ["masterCode", "sceneIndex", "sceneSequ"]
        let arrayValue = [masterCode, sceneIndex, sceneSequ] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //添加情景电器
    func AddSceneElectric(_ masterCode:String, electricCode:String, electricOrder:String, accountCode:String, sceneIndex:Int, orderInfo:String, electricIndex:Int, electricName:String, roomIndex:Int, electricType:Int) ->String {
        let methodName:String = "addSceneElectric"
        let arrayKey = ["masterCode", "electricCode", "electricOrder", "accountCode", "sceneIndex", "orderInfo", "electricIndex", "electricName", "roomIndex", "electricType"]
        let arrayValue = [masterCode, electricCode, electricOrder, accountCode, sceneIndex, orderInfo, electricIndex, electricName, roomIndex, electricType] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //删除情景电器
    func DeleteSceneElectric(_ masterCode:String, electricIndex:Int, sceneIndex:Int) ->String {
        let methodName:String = "deleteSceneElectric"
        let arrayKey = ["masterCode", "electricIndex", "sceneIndex"]
        let arrayValue = [masterCode, electricIndex, sceneIndex] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //更新主机ip
    func UpdateUserIP(_ masterCode:String, userIP:String)->String {
        let methodName:String = "updateUserIP"
        let arrayKey = ["masterCode", "userIP"]
        let arrayValue = [masterCode, userIP]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //通过当前master获取被分享过的account数据
    func LoadSharedAccount(_ masterCode:String) -> [NSDictionary] {
        let methodName:String = "loadSharedAccount"
        let arrayKey = ["masterCode"]
        let arrayValue = [masterCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //通过当前master获取被分享过的electric数据
    func LoadAllSharedElectric(_ masterCode:String) -> [NSDictionary] {
        let methodName:String = "loadAllSharedElectric"
        let arrayKey = ["masterCode"]
        let arrayValue = [masterCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "dicts")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! [NSDictionary])
    }
    
    //通过当前master获取被分享过的electric数据
    func AdminSharedElectric(_ bytes:String) -> String {
        let methodName:String = "adminSharedElectric"
        let arrayKey = ["bytes"]
        let arrayValue = [bytes]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //获取主账户手机号
    func GetAdminAccountCode(_ masterCode:String) -> String {
        let methodName:String = "getAdminAccountCode"
        let arrayKey = ["masterCode"]
        let arrayValue = [masterCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //更新传感器的布防状态
    func UpdateSensorExtras(masterCode:String, electricCode:String, electricIndex:Int, extras:String) ->String {
        let methodName:String = "updateSensorExtras"
        let arrayKey = ["masterCode", "electricCode", "electricIndex","extras"]
        let arrayValue = [masterCode, electricCode, electricIndex, extras] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //切换情景电器的order状态
    func UpdateSceneElectricOrder(masterCode:String, electricIndex:Int, electricCode:String, sceneIndex:Int, electricOrder:String, orderInfo:String) -> String {
        let methodName:String = "updateSceneElectricOrder"
        let arrayKey = ["masterCode", "electricIndex", "electricCode", "sceneIndex","electricOrder", "orderInfo"]
        let arrayValue = [masterCode, electricIndex, electricCode, sceneIndex, electricOrder, orderInfo] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    //获取红外传感器key_value值，首先解析xml格式文件，读取到JSON字符串，然后再返回JSON数组
    func LoadKeyByElectric(masterCode:String, electricIndex:Int) -> [JSON] {
        let methodName:String = "loadKeyByElectric"
        let arrayKey = ["masterCode", "electricIndex"]
        let arrayValue = [masterCode, electricIndex] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        //在这里处理json字符串
        let sJson = value.mainValue as! String
        if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            var json:JSON!
            do { json = try JSON(data: jsonData) }
            catch { print("json error"); return [] }
            if let array = json.array {
                return array
            }else {
                return []
            }
        }else {
            return []
        }
    }
    
    //获取空调状态值，首先解析xml格式文件，读取到JSON字符串，然后再返回JSON数组
    func LoadETAirByElectric(masterCode:String, electricIndex:Int) -> [JSON] {
        let methodName:String = "loadETAirByElectric"
        let arrayKey = ["masterCode", "electricIndex"]
        let arrayValue = [masterCode, electricIndex] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        //在这里处理json字符串
        let sJson = value.mainValue as! String
        if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            var json:JSON!
            do { json = try JSON(data: jsonData) }
            catch { print("json error"); return [] }
            if let array = json.array {
                return array
            }else {
                return []
            }
        }else {
            return []
        }
    }
    
    //获取短信验证码
    func SendSmsCode(phoneNum:String) -> [String: JSON] {
        let methodName:String = "sendSmsCode"
        let arrayKey = ["phoneNum"]
        let arrayValue = [phoneNum]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        //在这里处理json字符串
        let sJson = value.mainValue as! String
        if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            var json:JSON!
            do { json = try JSON(data: jsonData) }
            catch { print("json error"); return [:] }
            if let dict = json.dictionary {
                return dict
            }else {
                return [:]
            }
        }else {
            return [:]
        }
    }
    
    //获取短信验证码
    func CheckSmsCode(phoneNum:String, code:String) -> [String: JSON] {
        let methodName:String = "checkSmsCode"
        let arrayKey = ["phoneNum", "code"]
        let arrayValue = [phoneNum, code]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        //在这里处理json字符串
        let sJson = value.mainValue as! String
        if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            var json:JSON!
            do { json = try JSON(data: jsonData) }
            catch { print("json error"); return [:] }
            if let dict = json.dictionary {
                return dict
            }else {
                return [:]
            }
        }else {
            return [:]
        }
    }
    
    func LoadDoorRecord(masterCode:String, electricCode:String) -> [JSON] {
        let methodName:String = "loadDoorRecord"
        let arrayKey = ["masterCode", "electricCode"]
        let arrayValue = [masterCode, electricCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        //在这里处理json字符串
        let sJson = value.mainValue as! String
        if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            var json:JSON!
            do { json = try JSON(data: jsonData) }
            catch { print("json error"); return [] }
            if let array = json.array {
                return array
            }else {
                return []
            }
        }else {
            return []
        }
    }
    
    func LoadAlarmRecord(masterCode:String) -> [JSON] {
        let methodName:String = "loadAlarmRecord"
        let arrayKey = ["masterCode"]
        let arrayValue = [masterCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        //在这里处理json字符串
        let sJson = value.mainValue as! String
        if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            var json:JSON!
            do { json = try JSON(data: jsonData) }
            catch { print("json error"); return [] }
            if let array = json.array {
                return array
            }else {
                return []
            }
        }else {
            return []
        }
    }
    
    func UpdateElectricSequ(masterCode:String, electricIndex:Int, roomIndex:Int, oldElectricSequ:Int, newElectricSequ:Int) -> String {
        let methodName:String = "updateElectricSequ"
        let arrayKey = ["masterCode", "electricIndex", "roomIndex", "oldElectricSequ","newElectricSequ"]
        let arrayValue = [masterCode, electricIndex, roomIndex, oldElectricSequ, newElectricSequ] as [Any]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    func IsExistElectric(masterCode:String, electricCode:String) -> String {
        let methodName:String = "isExistElectric"
        let arrayKey = ["masterCode", "electricCode"]
        let arrayValue = [masterCode, electricCode]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "string")
        return (value.mainValue as! String)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func OpenPolling() {
//        if m_bPolling == true {
//            return
//        }
//        m_timerPolling = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(MyWebService.RunPolling), userInfo:nil, repeats:true)
//        m_bPolling = true
    }
    
    func RunPolling() {
//        let dictsElectricState = GetElectricStateByUser(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode)
//        gDC.mElectricData.UpdateElectricState(dictsElectricState)
//        g_notiCenter.post(name: Notification.Name(rawValue: "RefreshElectricStates"), object: self)//向所有注册过观测器的界面发送消息
    }
    
    func StopPolling() {
//        if m_bPolling == false {
//            return
//        }
//        m_bPolling = false
//        m_timerPolling.invalidate()
    }
    
    func LoadDataFromWeb() {
        MyWebService.sharedInstance.StopPolling()
        //从服务器加载房间列表
        let dictsArea = MyWebService.sharedInstance.LoadUserRoom(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, areaTime: gDC.mUserInfo.m_sTimeArea)
        gDC.mAreaData.UpdateArea(dictsArea)
        //从服务器加载电器列表
        let dictsElectric = MyWebService.sharedInstance.LoadElectric(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, electricTime: gDC.mUserInfo.m_sTimeElectric)
        gDC.mElectricData.UpdateElectric(dictsElectric)
        //从服务器加载红外类型电器的键值
        if dictsElectric.count != 0 {
            for i in 0..<gDC.mAreaList.count {
                for j in 0..<gDC.mAreaList[i].mElectricList.count {
                    let nType = gDC.mAreaList[i].mElectricList[j].m_nElectricType
                    if gDC.m_arrayElectricTypeCode[nType] as! String == "09" {//9是空调，12是电视，21是临时设计的学习型空调
                        let jsons = MyWebService.sharedInstance.LoadKeyByElectric(masterCode: gDC.mUserInfo.m_sMasterCode, electricIndex: gDC.mAreaList[i].mElectricList[j].m_nElectricIndex)
                        gDC.mETData.UpdateETKeys(jsons)
                        if nType == 9 || nType == 21 {//如果是空调的话，则读取
                            let jsons2 = MyWebService.sharedInstance.LoadETAirByElectric(masterCode: gDC.mUserInfo.m_sMasterCode, electricIndex: gDC.mAreaList[i].mElectricList[j].m_nElectricIndex)
                            gDC.mETData.UpdateETAir(jsons2)
                        }
                    }
                }
            }
        }
        //从服务器加载情景列表
        let dictsScene = MyWebService.sharedInstance.LoadScene(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, sceneTime: gDC.mUserInfo.m_sTimeScene)
        gDC.mSceneData.UpdateScene(dictsScene)
        //从服务器加载情景电器列表
        let dictSceneElectric = MyWebService.sharedInstance.LoadSceneElectric(gDC.mAccountInfo.m_sAccountCode, masterCode: gDC.mUserInfo.m_sMasterCode, sceneElectricTime: gDC.mUserInfo.m_sTimeSceneElectric)
        gDC.mSceneElectricData.UpdateSceneElectric(dictSceneElectric)
    }
    
}
