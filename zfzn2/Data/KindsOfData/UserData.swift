//
//  UserData.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/26.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import Foundation

class UserData: NSObject {
    //通过搜索主节点的方式添加user
    func AddUser(_ userName:String, masterCode:String, userIP:String) {
        //写入到内存
        let userInfo = UserInfoData()
        userInfo.m_sAccountCode = gDC.mAccountInfo.m_sAccountCode
        userInfo.m_sMasterCode = masterCode
        userInfo.m_sUserIP = userIP
        userInfo.m_sUserName = userName
        userInfo.m_nIsAdmin = 1
        gDC.mUserList.append(userInfo)
    }
    
    //通过account删除所有该账户下的users
    func DeleteUser(_ accountCode:String) {
    }
    
    //通过user脚标删除之
    func DeleteUserByFoot(_ foot:Int) {
        //在本地内存中删除
        gDC.mUserList.remove(at: foot)
    }
    
    //通过web返回的数据同步本地user数据
    func UpdateUser(_ dicts:[NSDictionary]) {
        gDC.mUserList.removeAll()
        for i in 0..<dicts.count-1 {
            let dict:NSDictionary = dicts[i]
            //将从web中同步到的数据，加载入内存中
            let userInfo = UserInfoData()
            if (dict.object(forKey: "accountCode") != nil) {
                userInfo.m_sAccountCode = dict["accountCode"] as! String
            }
            if (dict.object(forKey: "masterCode") != nil) {
                userInfo.m_sMasterCode = dict["masterCode"] as! String
            }
            if (dict.object(forKey: "userName") != nil) {
                userInfo.m_sUserName = dict["userName"] as! String
            }
            if (dict.object(forKey: "userIp") != nil) {
                userInfo.m_sUserIP = dict["userIp"] as! String
            }
            if (dict.object(forKey: "isAdmin") != nil) {
                userInfo.m_nIsAdmin = Int(dict["isAdmin"] as! String)!
            }
            gDC.mUserList.append(userInfo)
        }
        var bFlag = false
        for i in 0..<gDC.mUserList.count {
            if (gDC.mUserList[i].m_sMasterCode == gDC.mUserInfo.m_sMasterCode) {
                gDC.mUserInfo = gDC.mUserList[i]
                bFlag = true
                break
            }
        }
        if (bFlag == false) {
            gDC.mUserInfo = gDC.mUserList[0]//默认为最新使用的user
        }
    }
    
    //根据是否拥有管理员权限来更新当前用户
    func UpdateAdmin(_ masterCode:String, isAdmin:Int) {
        //更新内存数据
        for i in 0..<gDC.mUserList.count {
            if gDC.mUserList[i].m_sMasterCode == masterCode {
                gDC.mUserList[i].m_nIsAdmin = isAdmin
                break
            }
        }
        if gDC.mUserInfo.m_sMasterCode == masterCode {
            gDC.mUserInfo.m_nIsAdmin = isAdmin
        }
    }
    
    func UpdateUserName(accountCode:String, masterCode:String, userName:String) {
        //更新内存数据
        gDC.mUserInfo.m_sUserName = userName
    }
}

class UserInfoData: NSObject {
    var m_sAccountCode:String = ""  //区域描述,该区域名字
    var m_sMasterCode:String = ""   //主机编号
    var m_sUserName:String = ""     //用户名称
    var m_sUserIP:String = ""        //用户ip
    
    var m_nUserPort:Int = -1//用户端口
    var m_nIsAdmin:Int = -1//是否为管理员
    
    var m_sTimeScene:String = ""
    var m_sTimeArea:String = ""
    var m_sTimeElectric:String = ""
    var m_sTimeSceneElectric:String = ""
}

