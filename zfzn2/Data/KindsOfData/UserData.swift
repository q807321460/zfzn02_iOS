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
//        let dictQuery = NSMutableDictionary()
//        dictQuery.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code")
//        dictQuery.setObject(masterCode, forKey: "master_code")
//        let result = gMySqlClass.QuerySql(dictQuery, table: "users")//向本地数据库中添加这个user
//        
//        if result.count > 0 {//如果没有找到对应项，说明可以添加这个user，反之退出
//            print("已添加过这个主机")
//            ShowNoticeDispatch("错误", content: "已添加过这个主机", duration: 1.5)
//            return
//        }
        //向本地数据库中添加这个user
        let dictInsert = NSMutableDictionary()
        dictInsert.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
        dictInsert.setObject(masterCode, forKey: "master_code" as NSCopying)
        dictInsert.setObject(userName, forKey: "user_name" as NSCopying)
        dictInsert.setObject(userIP, forKey: "user_ip" as NSCopying)
        dictInsert.setObject(1, forKey: "is_admin" as NSCopying)
        gMySqlClass.InsertIntoSql(dictInsert, table: "users")
        //同时需要更新accounts表中对应的user_time
//        let dictSet = NSMutableDictionary()
//        dictSet.setObject(GetCurrentTime(), forKey: "user_time")
//        let dictRequired:NSMutableDictionary = ["account_code":gDC.mAccountInfo.m_sAccountCode]
//        gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "accounts")
        //写入到内存
        let userInfo = UserInfoData()
        userInfo.m_sAccountCode = gDC.mAccountInfo.m_sAccountCode
        userInfo.m_sMasterCode = masterCode
        userInfo.m_sUserIP = userIP
        userInfo.m_sUserName = userName
        userInfo.m_nIsAdmin = 1
//        gDC.mUserInfo = userInfo
        gDC.mUserList.append(userInfo)
    }
    
    //通过account删除所有该账户下的users
    func DeleteUser(_ accountCode:String) {
        let dictRequired = NSMutableDictionary()
        dictRequired.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
        gMySqlClass.DeleteSql(dictRequired, table: "users")
    }
    
    //通过user脚标删除之
    func DeleteUserByFoot(_ foot:Int) {
        //在本地数据库中删除
        let dictRequired = NSMutableDictionary()
        dictRequired.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
        dictRequired.setObject(gDC.mUserList[foot].m_sMasterCode, forKey: "master_code" as NSCopying)
        gMySqlClass.DeleteSql(dictRequired, table: "users")
        //在本地内存中删除
        gDC.mUserList.remove(at: foot)
    }
    
    //通过web返回的数据同步本地user数据
    func UpdateUser(_ dicts:[NSDictionary]) {
        gDC.mUserList.removeAll()
        if dicts.count == 0 {
            //返回空的话，说明本地的数据是最新的，则不用同步，直接读取本地数据库中的数据
            let dictQuery:NSMutableDictionary = ["account_code":gDC.mAccountInfo.m_sAccountCode]
            let sqlResult = gMySqlClass.QuerySql(dictQuery, table: "users")
            for i in 0..<sqlResult.count {
                let userInfo = UserInfoData()
                userInfo.m_sAccountCode = sqlResult[i]["account_code"] as! String
                userInfo.m_sMasterCode = sqlResult[i]["master_code"] as! String
                userInfo.m_sUserName = sqlResult[i]["user_name"] as! String
                userInfo.m_sUserIP = sqlResult[i]["user_ip"] as! String
                userInfo.m_nIsAdmin = sqlResult[i]["is_admin"] as! Int
                if (sqlResult[i]["scene_time"] != nil) {
                    userInfo.m_sTimeScene = sqlResult[i]["scene_time"] as! String
                }
                if (sqlResult[i]["area_time"] != nil) {
                    userInfo.m_sTimeArea = sqlResult[i]["area_time"] as! String
                }
                if (sqlResult[i]["electric_time"] != nil) {
                    userInfo.m_sTimeElectric = sqlResult[i]["electric_time"] as! String
                }
                if (sqlResult[i]["scene_electric_time"] != nil) {
                    userInfo.m_sTimeSceneElectric = sqlResult[i]["scene_electric_time"] as! String
                }
                gDC.mUserList.append(userInfo)
            }
            gDC.mUserInfo = gDC.mUserList[0]//默认列表中第一个主机，防止切换用户时找不到对应的主机
            for i in 0..<sqlResult.count {
                //如果不需要同步的话，这里的gDC.m_sLastMasterCode一定是有一个值的
                if gDC.mAccountInfo.m_sLastMasterCode == (sqlResult[i]["master_code"] as! String) {
                    //将这个user作为当前活动的user
                    gDC.mUserInfo = gDC.mUserList[i]
                    break
                }
            }
            return
        }
        //需要同步的话，先删除数据库中当前account对应的所有user
        DeleteUser(gDC.mAccountInfo.m_sAccountCode)
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
            //并重新写入本地数据库
            let dictInsert = NSMutableDictionary()
            dictInsert.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
            dictInsert.setObject(userInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
            dictInsert.setObject(userInfo.m_sUserName, forKey: "user_name" as NSCopying)
            dictInsert.setObject(userInfo.m_sUserIP, forKey: "user_ip" as NSCopying)
            dictInsert.setObject(userInfo.m_nIsAdmin, forKey: "is_admin" as NSCopying)
            if (dict.object(forKey: "sceneTime") != nil) {
                dictInsert.setObject(dict["sceneTime"] as! String, forKey: "scene_time" as NSCopying)
            }
            if (dict.object(forKey: "areaTime") != nil) {
                dictInsert.setObject(dict["areaTime"] as! String, forKey: "area_time" as NSCopying)
            }
            if (dict.object(forKey: "electricTime") != nil) {
                dictInsert.setObject(dict["electricTime"] as! String, forKey: "electric_time" as NSCopying)
            }
            if (dict.object(forKey: "sceneElectricTime") != nil) {
                dictInsert.setObject(dict["sceneElectricTime"] as! String, forKey: "scene_electric_time" as NSCopying)
            }
            gMySqlClass.InsertIntoSql(dictInsert, table: "users")
        }
        gDC.mUserInfo = gDC.mUserList[0]//默认为最新使用的user
        //返回的[NSDictionary]的最后一项，保存了user_time的数据，需要更新到accounts表中
        let dict:NSDictionary = dicts[dicts.count-1]
        if (dict.object(forKey: "extraTime") != nil) {
            let sTimeExtra = dict["extraTime"] as! String
            let setDict = NSMutableDictionary()
            setDict.setObject(sTimeExtra, forKey: "user_time" as NSCopying)
            let requiredDict = NSMutableDictionary()
            requiredDict.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
            gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "accounts")
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
        //向本地数据库中更新
        let dictSet:NSMutableDictionary = ["is_admin":isAdmin]
        let dictRequired:NSMutableDictionary = ["master_code":masterCode, "account_code":gDC.mAccountInfo.m_sAccountCode]
        gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "users")
    }
    
    func UpdateUserName(accountCode:String, masterCode:String, userName:String) {
        //更新内存数据
        gDC.mUserInfo.m_sUserName = userName
        //向本地数据库中更新
        let dictSet:NSMutableDictionary = ["user_name":userName]
        let dictRequired:NSMutableDictionary = ["master_code":masterCode, "account_code":gDC.mAccountInfo.m_sAccountCode]
        gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "users")
    }
}

class UserInfoData: NSObject {
    var m_sAccountCode:String = ""  //区域描述,该区域名字
    var m_sMasterCode:String = ""   //主机编号
    var m_sUserName:String = ""     //用户名称
    var m_sUserIP:String = ""        //用户ip
    
    var m_nUserPort:Int = -1//用户端口
    var m_nIsAdmin:Int = -1//是否为管理员
//    var m_nAreaIndexMax:Int!//最大的房间序号
    
    var m_sTimeScene:String = ""
    var m_sTimeArea:String = ""
    var m_sTimeElectric:String = ""
    var m_sTimeSceneElectric:String = ""
}

