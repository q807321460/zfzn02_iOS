//
//  PublicWebService.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/4/11.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  已弃置的类
import Foundation
import UIKit

class PublicWebService: NSObject,URLSessionDelegate,URLSessionDataDelegate {
    var m_URL_weather:URL?//网上通用URL，用于查询天气等
    var m_URLNameSpace_weather:String = ""//web命名空间
    var m_URLRequest_weather:NSMutableURLRequest?
    
    var m_URLSession:URLSession?
    var m_URLSessionCfg:URLSessionConfiguration?
    
    internal static let sharedInstance = PublicWebService()//保证是单例运行
    
    fileprivate override init() {
        //        super.init()
    }
    
    /************************************************************************************/
    //以下是基本的web处理函数//
    func InitURLSession(){
        m_URLSessionCfg = URLSessionConfiguration.default
        m_URLSessionCfg?.timeoutIntervalForRequest = 15
        m_URLNameSpace_weather = "\"http://WebXml.com.cn/\""
        m_URLSession = URLSession(configuration: m_URLSessionCfg!, delegate: self, delegateQueue: nil)
        m_URL_weather = URL(string: "http://www.webxml.com.cn/WebServices/WeatherWebService.asmx?wsdl")!
        m_URLRequest_weather = NSMutableURLRequest.init(url: m_URL_weather!)
        m_URLRequest_weather!.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        m_URLRequest_weather!.httpMethod = "POST"
    }
    
    //根据需求从返回数组中获取相关数据（这里的逻辑写的很不好。。。暂时先用着）
    func GetReturnValue(_ methodName:String, dict:NSDictionary, returnType: String) -> (mainValue:AnyObject, bEmpty:Bool){
//        var valueString:String = ""
        var valueArray = NSArray()
//        var valueDicts = [NSDictionary]()
        var data = [NSDictionary]()
        for _:Int in 0..<3{
            data.append(NSDictionary())
        }
        data[0] = dict.object(forKey: "soap:Body") as! NSDictionary
        data[1] = data[0].object(forKey: "\(methodName)"+"Response") as! NSDictionary
        data[2] = data[1].object(forKey: "\(methodName)"+"Result") as! NSDictionary
        if returnType=="array" {
            valueArray = data[2].object(forKey: "string") as! NSArray
            return (valueArray, false)
        }
//        else if returnType=="dict" {
//            //如果返回的是结构体数组，则返回整个结构体的数组
//            let array = data[2].objectForKey("string") as! NSArray
//            valueArray.removeAll()
//            valueArray.append(data[3])
//            return (valueArray, false)
//        }
//        else if returnType=="string"{
//            //如果返回的是单一字符串
//            valueString = data[i-1].objectForKey(arrayKeyRes[i-2]) as! String
//            return (valueString, false)
//        }
        else {
            return ("otherType" as AnyObject, false)
        }
    }
    
    /**
     设置Session的部分变量，无参数传入
     - parameter methodName: 由webservice提供的接口
     */
    func SetSessionTask(_ methodName:String){
        let soapMsg:String = String.localizedStringWithFormat(
            "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><\(methodName) xmlns=\(m_URLNameSpace_weather)></\(methodName)></soap:Body></soap:Envelope>")
        m_URLRequest_weather!.httpBody = (soapMsg.data(using: String.Encoding.utf8))
        let msgLength:String = "\(soapMsg.characters.count)"
        m_URLRequest_weather!.addValue(msgLength, forHTTPHeaderField: "Content-Length")
    }
    
    /**
     设置Session的部分变量，一个或者多个参数传入
     */
    func SetSessionTask(_ methodName:String, arrayKey: Any, arrayValue: Any){
        let arrayKey2:NSArray = arrayKey as! NSArray
        let arrayValue2:NSArray = arrayValue as! NSArray
        let length = arrayKey2.count
        var mainMsg:String = ""
        for i:Int in 0..<length{
            let tempMsg:String = String.localizedStringWithFormat("<\(arrayKey2[i])>\(arrayValue2[i])</\(arrayKey2[i])>")
            mainMsg = mainMsg + tempMsg
        }
        let soapMsg:String = String.localizedStringWithFormat("<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><\(methodName) xmlns=\(m_URLNameSpace_weather)>\(mainMsg)</\(methodName)></soap:Body></soap:Envelope>")
        m_URLRequest_weather!.httpBody = (soapMsg.data(using: String.Encoding.utf8))
        let msgLength:String = "\(soapMsg.characters.count)"
        m_URLRequest_weather!.addValue(msgLength, forHTTPHeaderField: "Content-Length")
    }
    
    /**
     获取Session返回的字符串（根据Key数组的值）
     */
    func GetSessionReturn(_ methodName:String, returnType: String) -> (mainValue:AnyObject, bEmpty:Bool){
        var theXML:NSString!
        var xmlDoc:NSDictionary!
        var bReceiving:Bool = true
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        let task = URLSession.shared.dataTask(with: m_URLRequest_weather! as URLRequest) {
//        let task = m_URLSession!.dataTask(with: m_URLRequest_weather!, completionHandler: {
            (data,response,error) -> Void in
            if error != nil{
                if methodName != "getElectricStateByUser" {//轮询中，当然不能反复提示没有网络啊
                    WebError()//这里不弹出提示？还是弹出比较好
                }
                value = (["WebError"] as AnyObject, false)//必须返回一个NSArray数组而不是String字符串
                bReceiving = false
                DispatchQueue.main.async(execute: {
                    //print("连接webservice发生了错误")
                })
            }
            else{
                theXML = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                xmlDoc = NSDictionary(xmlString: theXML as String)
                print("——————————输出Dictionary格式——————————")
                print("\(xmlDoc)")
                print("——————————输出Dictionary格式——————————")
                value = self.GetReturnValue(methodName, dict: xmlDoc, returnType: returnType)
                bReceiving = false
                //只有当程序进入主线程的时候，才能退出NSRunLoop循环并更新界面
                DispatchQueue.main.async(execute: {
//                    print("webservice接口\(methodName)调用成功")
                })
            }
        }
        task.resume()
        //进入while循环，无限等待，但是又不能让程序锁死
        while bReceiving == true {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture as Date)
        }
        return value
    }
    
    /************************************************************************************/
    //以下是各种具体的功能，但是仍然和数据是绑定的//
    //获取支持的省份
    func getSupportProvince() -> NSArray {
        let methodName:String = "getSupportProvince"
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName)
        value = GetSessionReturn(methodName, returnType: "array")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! NSArray)
    }
    
    //获取指定省份支持的城市
    func GetSupportCity(_ byProvinceName:String) -> NSArray {
        let methodName:String = "getSupportCity"
        let arrayKey = ["byProvinceName"]
        let arrayValue = [byProvinceName]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "array")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! NSArray)
    }
    
    //获取指定城市的天气
    func GetWeatherbyCityName(_ theCityName:String) -> NSArray {
        let methodName:String = "getWeatherbyCityName"
        let arrayKey = ["theCityName"]
        let arrayValue = [theCityName]
        var value:(mainValue:AnyObject, bEmpty:Bool)!
        SetSessionTask(methodName, arrayKey: arrayKey, arrayValue: arrayValue)
        value = GetSessionReturn(methodName, returnType: "array")
        if value.bEmpty == true {
            return []
        }
        return (value.mainValue as! NSArray)
    }
    
}




