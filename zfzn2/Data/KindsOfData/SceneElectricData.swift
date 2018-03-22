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
        for i in 0..<gDC.mSceneList.count {
            gDC.mSceneList[i].mSceneElectricList.removeAll()
        }
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
            //写入到内存
            for j in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[j].m_nSceneIndex == sceneElectricInfo.m_nSceneIndex {
                    gDC.mSceneList[j].mSceneElectricList.append(sceneElectricInfo)
                }
            }
        }
    }
    
    func UpdateSceneElectricOrder(electricFoot:Int, sceneFoot:Int, electricOrder:String) {
        gDC.mSceneList[sceneFoot].mSceneElectricList[electricFoot].m_sElectricOrder = electricOrder
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
