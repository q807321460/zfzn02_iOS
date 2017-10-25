//
//  AreaData.swift
//  zfzn
//
//  Created by Hanwen Kong on 16/8/25.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import Foundation

class AreaData: NSObject {
    func AddArea(_ areaName:String, areaIndex:Int, areaSequ:Int) {
        //写入到本地数据库
        let dictInsert = NSMutableDictionary()
        dictInsert.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
        dictInsert.setObject(areaName, forKey: "room_name" as NSCopying)
        dictInsert.setObject(areaIndex, forKey: "room_index" as NSCopying)
        dictInsert.setObject(areaSequ, forKey: "room_sequ" as NSCopying)
        gMySqlClass.InsertIntoSql(dictInsert, table: "userroom")
        //写入到内存
        let areaInfo = AreaInfoData()
        areaInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
        areaInfo.m_sAreaName = areaName
        areaInfo.m_nAreaIndex = areaIndex
        areaInfo.m_nAreaSequ = areaSequ
        gDC.mAreaList.append(areaInfo)
    }
    
    func DeleteAreaByMaster(_ masterCode:String) {
        let dictRequired = NSMutableDictionary()
        dictRequired.setObject(masterCode, forKey: "master_code" as NSCopying)
        gMySqlClass.DeleteSql(dictRequired, table: "userroom")
    }
    
    func DeleteAreaByFoot(_ foot:Int) {
        //在数据库中删除对应房间号
        let requiredDict:NSMutableDictionary = ["master_code":gDC.mUserInfo.m_sMasterCode, "room_index":gDC.mAreaList[foot].m_nAreaIndex]
        gMySqlClass.DeleteSql(requiredDict, table: "userroom")
        //在内存数组中移除指定房间
        let deleteSequ:Int = gDC.mAreaList[foot].m_nAreaSequ
        gDC.mAreaList.remove(at: foot)
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_nAreaSequ > deleteSequ {
                let tempSequ:Int = gDC.mAreaList[i].m_nAreaSequ
                gDC.mAreaList[i].m_nAreaSequ = tempSequ - 1
            }
        }
    }
    
    func UpdateArea(_ dicts:[NSDictionary]) {
        gDC.mAreaList.removeAll()
        if dicts.count == 0 {
            //说明本地是最新的数据，不需要同步，读取本地数据库数据
            let dictQuery:NSMutableDictionary = ["master_code":gDC.mUserInfo.m_sMasterCode]
            let sqlResult = gMySqlClass.QuerySql(dictQuery, table: "userroom")
            for i in 0..<sqlResult.count {
                let areaInfo = AreaInfoData()
                areaInfo.m_sMasterCode = sqlResult[i]["master_code"] as! String
                areaInfo.m_sAreaName = sqlResult[i]["room_name"] as! String
                areaInfo.m_nAreaIndex = sqlResult[i]["room_index"] as! Int
                areaInfo.m_nAreaSequ = sqlResult[i]["room_sequ"] as! Int
                //从本地读取图片
                let fullPath:String = GetFileFullPath(gDC.mUserInfo.m_sMasterCode+"/area/", fileName: "\(areaInfo.m_sAreaName).png")
                let fileManager:FileManager = FileManager.default
                if fileManager.fileExists(atPath: fullPath) {//判断文件是否存在
                    areaInfo.m_imageArea = UIImage(contentsOfFile: fullPath)!
                }else {
                    areaInfo.m_imageArea = nil
                }
                gDC.mAreaList.append(areaInfo)
            }
            return
        }
        //需要同步的话，先删除数据库中所有当前master对应的area
        DeleteAreaByMaster(gDC.mUserInfo.m_sMasterCode)
        for i in 0..<dicts.count-1 {
            let dict:NSDictionary = dicts[i]
            let areaInfo = AreaInfoData()
            if (dict.object(forKey: "masterCode") != nil) {
                areaInfo.m_sMasterCode = dict["masterCode"] as! String
            }
            if (dict.object(forKey: "roomName") != nil) {
                areaInfo.m_sAreaName = dict["roomName"] as! String
            }
            if (dict.object(forKey: "roomIndex") != nil) {
                areaInfo.m_nAreaIndex = Int(dict["roomIndex"] as! String)!
            }
            if (dict.object(forKey: "roomSequ") != nil) {
                areaInfo.m_nAreaSequ = Int(dict["roomSequ"] as! String)!
            }
            //从本地读取图片
            let fullPath:String = GetFileFullPath(gDC.mUserInfo.m_sMasterCode+"/area/", fileName: "\(areaInfo.m_sAreaName).png")
            let fileManager:FileManager = FileManager.default
            if fileManager.fileExists(atPath: fullPath) {//判断文件是否存在
                areaInfo.m_imageArea = UIImage(contentsOfFile: fullPath)!
            }else {
                areaInfo.m_imageArea = nil
            }
            gDC.mAreaList.append(areaInfo)
            //并重新写入本地数据库
            let dictInsert = NSMutableDictionary()
            dictInsert.setObject(areaInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
            dictInsert.setObject(areaInfo.m_sAreaName, forKey: "room_name" as NSCopying)
            dictInsert.setObject(areaInfo.m_nAreaIndex, forKey: "room_index" as NSCopying)
            dictInsert.setObject(areaInfo.m_nAreaSequ, forKey: "room_sequ" as NSCopying)
            gMySqlClass.InsertIntoSql(dictInsert, table: "userroom")
        }
        //返回的[NSDictionary]的最后一项，保存了area_time的数据，需要更新到user表中
        let dict:NSDictionary = dicts[dicts.count-1]
        if (dict.object(forKey: "extraTime") != nil) {
            let sTimeExtra = dict["extraTime"] as! String
            let setDict = NSMutableDictionary()
            setDict.setObject(sTimeExtra, forKey: "area_time" as NSCopying)
            let requiredDict = NSMutableDictionary()
            requiredDict.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
            gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "users")
        }
    }
    
    
}

class AreaInfoData: NSObject {
    var m_sAreaName:String = ""//区域描述,该区域名字
    var m_sMasterCode:String = ""//区域所属的主机
    var m_imageArea:UIImage? = nil//区域图片
    var m_nAreaIndex:Int = -1//区域编号
    var m_nAreaSequ:Int = -1//区域序号
    var m_nElecNum:Int = -1//区域存贮电器数目
    var mElectricList = [ElectricInfoData]()
}
