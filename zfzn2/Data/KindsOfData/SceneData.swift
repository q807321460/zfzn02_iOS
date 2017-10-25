//
//  SceneData.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/3.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SceneData: NSObject {

    func AddScene(_ sceneName:String, sceneIndex:Int, sceneSequ:Int, sceneImageIndex:Int) {
        //写入到本地数据库
        let dictInsert = NSMutableDictionary()
        dictInsert.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
        dictInsert.setObject(sceneName, forKey: "scene_name" as NSCopying)
        dictInsert.setObject(sceneIndex, forKey: "scene_index" as NSCopying)
        dictInsert.setObject(sceneSequ, forKey: "scene_sequ" as NSCopying)
        gMySqlClass.InsertIntoSql(dictInsert, table: "scenes")
        //写入到内存
        let sceneInfo = SceneInfoData()
        sceneInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
        sceneInfo.m_sSceneName = sceneName
        sceneInfo.m_nSceneIndex = sceneIndex
        sceneInfo.m_nSceneSequ = sceneSequ
        sceneInfo.m_nSceneImageIndex = sceneImageIndex
        switch sceneImageIndex {
        case 0:
            sceneInfo.m_imageScene = UIImage(named: "情景_回家")
        case 1:
            sceneInfo.m_imageScene = UIImage(named: "情景_离家")
        case 2:
            sceneInfo.m_imageScene = UIImage(named: "情景_起床")
        case 3:
            sceneInfo.m_imageScene = UIImage(named: "情景_睡觉")
        case 4:
            sceneInfo.m_imageScene = UIImage(named: "情景_自定义")
        default:
            break
        }
        gDC.mSceneList.append(sceneInfo)
    }
    
    //删除当前主机下的所有情景
    func DeleteScene(_ masterCode:String) {
        let dictRequired:NSMutableDictionary = ["master_code": masterCode]
        gMySqlClass.DeleteSql(dictRequired, table: "scenes")
    }
    
    //根据情景脚标删除对应情景
    func DeleteSceneByFoot(_ foot:Int) {
        //在数据库中删除指定情景
        let requiredDict:NSMutableDictionary = ["master_code":gDC.mUserInfo.m_sMasterCode, "scene_index":gDC.mSceneList[foot].m_nSceneIndex]
        gMySqlClass.DeleteSql(requiredDict, table: "scenes")
        //在内存中删除指定情景
        let deleteSequ:Int = gDC.mSceneList[foot].m_nSceneSequ
        gDC.mSceneList.remove(at: foot)
        for i in 0..<gDC.mSceneList.count {
            if gDC.mSceneList[i].m_nSceneSequ > deleteSequ {
                let tempSequ:Int = gDC.mSceneList[i].m_nSceneSequ
                gDC.mSceneList[i].m_nSceneSequ = tempSequ - 1
                //将数据库中的对应sequ减1
                let requiredDict2:NSMutableDictionary = ["master_code":gDC.mUserInfo.m_sMasterCode, "scene_index":gDC.mSceneList[i].m_nSceneIndex]
                let setDict:NSMutableDictionary = ["scene_sequ": gDC.mSceneList[i].m_nSceneSequ]
                gMySqlClass.UpdateSql(setDict, requiredData: requiredDict2, table: "scenes")
            }
        }
    }

    //根据web返回的数据更新情景列表
    func UpdateScene(_ dicts:[NSDictionary]) {
        gDC.mSceneList.removeAll()
        if dicts.count == 0 {//没有返回则从数据库读取
            let dictQuery:NSMutableDictionary = ["master_code":gDC.mUserInfo.m_sMasterCode]
            let sqlResult = gMySqlClass.QuerySql(dictQuery, table: "scenes")
            for i in 0..<sqlResult.count {
                let sceneInfo = SceneInfoData()
                sceneInfo.m_nSceneIndex = sqlResult[i]["scene_index"] as! Int
                sceneInfo.m_nSceneImageIndex = sqlResult[i]["scene_img"] as! Int
                switch sceneInfo.m_nSceneImageIndex {
                case 0:
                    sceneInfo.m_imageScene = UIImage(named: "情景_回家")
                case 1:
                    sceneInfo.m_imageScene = UIImage(named: "情景_离家")
                case 2:
                    sceneInfo.m_imageScene = UIImage(named: "情景_起床")
                case 3:
                    sceneInfo.m_imageScene = UIImage(named: "情景_睡觉")
                case 4:
                    sceneInfo.m_imageScene = UIImage(named: "情景_自定义")
                default:
                    break
                }
                sceneInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
                sceneInfo.m_sSceneName = sqlResult[i]["scene_name"] as! String
                sceneInfo.m_nSceneIndex = sqlResult[i]["scene_index"] as! Int
                sceneInfo.m_nSceneSequ = sqlResult[i]["scene_sequ"] as! Int
                sceneInfo.m_sTimeBuild = sqlResult[i]["build_time"] as! String
                gDC.mSceneList.append(sceneInfo)
            }
            return
        }
        DeleteScene(gDC.mUserInfo.m_sMasterCode)
        //有返回则写入本地和内存
        for i in 0..<dicts.count-1 {
            let dict:NSDictionary = dicts[i]
            let sceneInfo = SceneInfoData()
            if (dict.object(forKey: "masterCode") != nil) {
                sceneInfo.m_sMasterCode = dict["masterCode"] as! String
            }
            if (dict.object(forKey: "sceneName") != nil) {
                sceneInfo.m_sSceneName = dict["sceneName"] as! String
            }
            if (dict.object(forKey: "buildTime") != nil) {
                sceneInfo.m_sTimeBuild = dict["buildTime"] as! String
            }
            if (dict.object(forKey: "sceneIndex") != nil) {
                sceneInfo.m_nSceneIndex = Int(dict["sceneIndex"] as! String)!
            }
            if (dict.object(forKey: "sceneSequ") != nil) {
                sceneInfo.m_nSceneSequ = Int(dict["sceneSequ"] as! String)!
            }
            if (dict.object(forKey: "sceneImg") != nil) {
                sceneInfo.m_nSceneImageIndex = Int(dict["sceneImg"] as! String)!
            }
            switch sceneInfo.m_nSceneImageIndex {
            case 0:
                sceneInfo.m_imageScene = UIImage(named: "情景_回家")
            case 1:
                sceneInfo.m_imageScene = UIImage(named: "情景_离家")
            case 2:
                sceneInfo.m_imageScene = UIImage(named: "情景_起床")
            case 3:
                sceneInfo.m_imageScene = UIImage(named: "情景_睡觉")
            case 4:
                sceneInfo.m_imageScene = UIImage(named: "情景_自定义")
            default:
                break
            }
            gDC.mSceneList.append(sceneInfo)
            //写入到数据库
            let dictInsert = NSMutableDictionary()
            dictInsert.setObject(sceneInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
            dictInsert.setObject(sceneInfo.m_sSceneName, forKey: "scene_name" as NSCopying)
            dictInsert.setObject(sceneInfo.m_nSceneIndex, forKey: "scene_index" as NSCopying)
            dictInsert.setObject(sceneInfo.m_nSceneSequ, forKey: "scene_sequ" as NSCopying)
            dictInsert.setObject(sceneInfo.m_nSceneImageIndex, forKey: "scene_img" as NSCopying)
            dictInsert.setObject(sceneInfo.m_sTimeBuild, forKey: "build_time" as NSCopying)
            gMySqlClass.InsertIntoSql(dictInsert, table: "scenes")
        }
        //scene数组的最后一项保存着一个额外时间extraTime，也就是user的electric_time
        let dict:NSDictionary = dicts[dicts.count-1]
        if (dict.object(forKey: "extraTime") != nil) {
            let sTimeExtra = dict["extraTime"] as! String
            let setDict:NSMutableDictionary = ["scene_time": sTimeExtra]
            let requiredDict:NSMutableDictionary = ["master_code" : gDC.mUserInfo.m_sMasterCode]
            gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "users")
        }
    }
 
}

class SceneInfoData:NSObject {
    var m_sAccountCode:String = ""
    var m_sMasterCode:String = ""
    var m_sSceneName:String = ""
    var m_nSceneIndex:Int = -1
    var m_nSceneSequ:Int = -1
    var m_nSceneImageIndex:Int = -1
    var m_imageScene:UIImage!
    var m_sTimeBuild:String = ""
    var mSceneElectricList = [SceneElectricInfoData]()
}
