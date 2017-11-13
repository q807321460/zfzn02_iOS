//
//  SceneElectricData.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/3.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SceneElectricData: NSObject {

    func AddSceneElectric(_ areaFoot:Int, electricFoot:Int, sceneFoot:Int, electricOrder:String) {
        //解析数据
        let electricCode:String = gDC.mAreaList[areaFoot].mElectricList[electricFoot].m_sElectricCode
        let electricIndex:Int = gDC.mAreaList[areaFoot].mElectricList[electricFoot].m_nElectricIndex
        let electricName:String = gDC.mAreaList[areaFoot].mElectricList[electricFoot].m_sElectricName
        let electricType:Int = gDC.mAreaList[areaFoot].mElectricList[electricFoot].m_nElectricType
        let orderInfo:String = gDC.mAreaList[areaFoot].mElectricList[electricFoot].m_sOrderInfo
        let roomIndex:Int = gDC.mAreaList[areaFoot].m_nAreaIndex
        let sceneIndex:Int = gDC.mSceneList[sceneFoot].m_nSceneIndex
//        //先添加到本地数据库
//        let dictInsert = NSMutableDictionary()
//        dictInsert.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
//        dictInsert.setObject(electricIndex, forKey: "electric_index" as NSCopying)
//        dictInsert.setObject(electricName, forKey: "electric_name" as NSCopying)
//        dictInsert.setObject(electricCode, forKey: "electric_code" as NSCopying)
//        dictInsert.setObject(electricOrder, forKey: "electric_order" as NSCopying)
//        dictInsert.setObject(electricType, forKey: "electric_type" as NSCopying)
//        dictInsert.setObject(orderInfo, forKey: "order_info" as NSCopying)
//        dictInsert.setObject(roomIndex, forKey: "room_index" as NSCopying)
//        dictInsert.setObject(sceneIndex, forKey: "scene_index" as NSCopying)
//        gMySqlClass.InsertIntoSql(dictInsert, table: "sceneelectrics")
        //添加到内存
        let sceneElectricInfo = SceneElectricInfoData()
        sceneElectricInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
        sceneElectricInfo.m_nElectricIndex = electricIndex
        sceneElectricInfo.m_sElectricName = electricName
        sceneElectricInfo.m_sElectricCode = electricCode
        sceneElectricInfo.m_sElectricOrder = electricOrder
        sceneElectricInfo.m_nElectricType = electricType
        sceneElectricInfo.m_sOrderInfo = orderInfo
        sceneElectricInfo.m_nRoomIndex = roomIndex
        sceneElectricInfo.m_nSceneIndex = sceneIndex
        for i in 0..<gDC.mSceneList.count {
            if gDC.mSceneList[i].m_nSceneIndex == sceneIndex {
                gDC.mSceneList[i].mSceneElectricList.append(sceneElectricInfo)
                break
            }
        }
    }
    
    func DeleteSceneElectric(_ masterCode:String) {
//        let dictRequired:NSMutableDictionary = ["master_code": masterCode]
//        gMySqlClass.DeleteSql(dictRequired, table: "sceneelectrics")
    }
    
    func DeleteSceneElectricByFoot(_ sceneFoot:Int, electricIndex:Int) {
//        let dictRequired:NSMutableDictionary = ["master_code": gDC.mUserInfo.m_sMasterCode, "scene_index": gDC.mSceneList[sceneFoot].m_nSceneIndex, "electric_index": electricIndex]
//        gMySqlClass.DeleteSql(dictRequired, table: "sceneelectrics")
        var nSceneElectricFoot:Int!
        for i in 0..<gDC.mSceneList[sceneFoot].mSceneElectricList.count {
            if gDC.mSceneList[sceneFoot].mSceneElectricList[i].m_nElectricIndex == electricIndex {
                nSceneElectricFoot = i
                break
            }
        }
        gDC.mSceneList[sceneFoot].mSceneElectricList.remove(at: nSceneElectricFoot)
    }
    
    //根据web返回的数据更新情景电器列表
    func UpdateSceneElectric(_ dicts:[NSDictionary]) {
        print("向内存中写入sceneElectric数据")
        for i in 0..<gDC.mSceneList.count {
            gDC.mSceneList[i].mSceneElectricList.removeAll()
        }
//        if dicts.count == 0 {//没有返回则从数据库读取
//            let dictQuery:NSMutableDictionary = ["master_code":gDC.mUserInfo.m_sMasterCode]
//            let sqlResult = gMySqlClass.QuerySql(dictQuery, table: "sceneelectrics")
//            for i in 0..<sqlResult.count {
//                let sceneElectricInfo = SceneElectricInfoData()
//                sceneElectricInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
//                sceneElectricInfo.m_sElectricCode = sqlResult[i]["electric_code"] as! String
//                sceneElectricInfo.m_sElectricName = sqlResult[i]["electric_name"] as! String
//                sceneElectricInfo.m_nElectricIndex = sqlResult[i]["electric_index"] as! Int
//                sceneElectricInfo.m_nElectricType = sqlResult[i]["electric_type"] as! Int
//                sceneElectricInfo.m_sElectricOrder = sqlResult[i]["electric_order"] as! String
//                sceneElectricInfo.m_nRoomIndex = sqlResult[i]["room_index"] as! Int
//                sceneElectricInfo.m_nSceneIndex = sqlResult[i]["scene_index"] as! Int
//                sceneElectricInfo.m_sOrderInfo = sqlResult[i]["order_info"] as! String
//                for j in 0..<gDC.mSceneList.count {
//                    if gDC.mSceneList[j].m_nSceneIndex == sceneElectricInfo.m_nSceneIndex {
//                        gDC.mSceneList[j].mSceneElectricList.append(sceneElectricInfo)
//                        break
//                    }
//                }
//            }
//            return
//        }
//        DeleteSceneElectric(gDC.mUserInfo.m_sMasterCode)
        for i in 0..<dicts.count-1 {
            let dict:NSDictionary = dicts[i]
            let sceneElectricInfo = SceneElectricInfoData()
            sceneElectricInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
            if (dict.object(forKey: "electricCode") != nil) {
                sceneElectricInfo.m_sElectricCode = dict["electricCode"] as! String
            }
            if (dict.object(forKey: "electricIndex") != nil) {
                sceneElectricInfo.m_nElectricIndex = Int(dict["electricIndex"] as! String)!
            }
            if (dict.object(forKey: "electricName") != nil) {
                sceneElectricInfo.m_sElectricName = dict["electricName"] as! String
            }
            if (dict.object(forKey: "electricOrder") != nil) {
                sceneElectricInfo.m_sElectricOrder = dict["electricOrder"] as! String
            }
            if (dict.object(forKey: "electricType") != nil) {
                sceneElectricInfo.m_nElectricType = Int(dict["electricType"] as! String)!
            }
            if (dict.object(forKey: "orderInfo") != nil) {
                sceneElectricInfo.m_sOrderInfo = dict["orderInfo"] as! String
            }
            if (dict.object(forKey: "roomIndex") != nil) {
                sceneElectricInfo.m_nRoomIndex = Int(dict["roomIndex"] as! String)!
            }
            if (dict.object(forKey: "sceneIndex") != nil) {
                sceneElectricInfo.m_nSceneIndex = Int(dict["sceneIndex"] as! String)!
            }
//            //写入到本地数据库
//            let dictInsert = NSMutableDictionary()
//            dictInsert.setObject(sceneElectricInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_sElectricCode, forKey: "electric_code" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_nElectricIndex, forKey: "electric_index" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_sElectricName, forKey: "electric_name" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_sElectricOrder, forKey: "electric_order" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_sOrderInfo, forKey: "order_info" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_nRoomIndex, forKey: "room_index" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_nElectricType, forKey: "electric_type" as NSCopying)
//            dictInsert.setObject(sceneElectricInfo.m_nSceneIndex, forKey: "scene_index" as NSCopying)
//            gMySqlClass.InsertIntoSql(dictInsert, table: "sceneelectrics")
            //写入到内存
            for j in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[j].m_nSceneIndex == sceneElectricInfo.m_nSceneIndex {
                    gDC.mSceneList[j].mSceneElectricList.append(sceneElectricInfo)
                }
            }
        }
//        //SceneElectric数组的最后一项保存着一个额外时间extraTime，也就是user的scene_electric_time
//        let dict:NSDictionary = dicts[dicts.count-1]
//        if (dict.object(forKey: "extraTime") != nil) {
//            let sTimeExtra = dict["extraTime"] as! String
//            let setDict = NSMutableDictionary()
//            setDict.setObject(sTimeExtra, forKey: "scene_electric_time" as NSCopying)
//            let requiredDict = NSMutableDictionary()
//            requiredDict.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
//            requiredDict.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
//            gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "users")
//        }
    }
    
    func UpdateSceneElectricOrder(electricFoot:Int, sceneFoot:Int, electricOrder:String) {
        //修改内存数据
        gDC.mSceneList[sceneFoot].mSceneElectricList[electricFoot].m_sElectricOrder = electricOrder
//        //修改本地数据库
//        let setDict = NSMutableDictionary()
//        setDict.setObject(electricOrder, forKey: "electric_order" as NSCopying)
//        let requiredDict = NSMutableDictionary()
//        requiredDict.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "master_code" as NSCopying)
//        requiredDict.setObject(gDC.mSceneList[sceneFoot].mSceneElectricList[electricFoot].m_nElectricIndex, forKey: "electricIndex" as NSCopying)
//        requiredDict.setObject(gDC.mSceneList[sceneFoot].m_nSceneIndex, forKey: "sceneIndex" as NSCopying)
//        gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "sceneelectrics")
    }
}

class SceneElectricInfoData:NSObject {
    var m_sMasterCode:String = ""
    var m_sElectricCode:String = ""
    var m_sElectricName:String = ""
    var m_sElectricOrder:String = ""
    var m_nElectricIndex:Int = -1
    var m_nElectricType:Int = -1
    var m_nRoomIndex:Int = -1
    var m_nSceneIndex:Int = -1
    var m_sTimeExtra:String = ""
    var m_sOrderInfo:String = ""
}
