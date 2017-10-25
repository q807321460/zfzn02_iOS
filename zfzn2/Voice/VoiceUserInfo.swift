//
//  User.swift
//  SmartConfigClientDemo
//
//  Created by JzProl.m.Qiezi on 2017/4/24.
//  Copyright © 2017年 Broadcom. All rights reserved.
//

import Foundation

class VoiceUserInfo{
    class func getUserInfo(forKey ssid:String) -> Dictionary<String, String>? {
        var dic:Dictionary<String,String>? = nil;
        guard (UserDefaults.standard.object(forKey: ssid) != nil) else {
            return nil
        }
        dic = UserDefaults.standard.object(forKey: ssid) as? Dictionary<String, String>
        return dic
    }
    
    class func setUserInfo(forKey ssid:String , userInfoDic: Dictionary<String, String>)->Void{
        UserDefaults.standard.set(userInfoDic, forKey: ssid)
    }
    
}
