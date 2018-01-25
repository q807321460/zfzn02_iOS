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
    }
    
    //根据情景脚标删除对应情景
    func DeleteSceneByFoot(_ foot:Int) {
        //在内存中删除指定情景
        let deleteSequ:Int = gDC.mSceneList[foot].m_nSceneSequ
        gDC.mSceneList.remove(at: foot)
        for i in 0..<gDC.mSceneList.count {
            if gDC.mSceneList[i].m_nSceneSequ > deleteSequ {
                let tempSequ:Int = gDC.mSceneList[i].m_nSceneSequ
                gDC.mSceneList[i].m_nSceneSequ = tempSequ - 1
            }
        }
    }

    //根据web返回的数据更新情景列表
    func UpdateScene(_ dicts:[NSDictionary]) {
        print("向内存中写入scene数据")
        gDC.mSceneList.removeAll()
//        DeleteScene(gDC.mUserInfo.m_sMasterCode)
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
            if (dict.object(forKey: "detailTiming") != nil) {
                sceneInfo.m_sDetailTiming = dict["detailTiming"] as! String
            }
            if (dict.object(forKey: "weeklyDays") != nil) {
                sceneInfo.m_sWeeklyDays = dict["weeklyDays"] as! String
            }
            if (dict.object(forKey: "daliyTiming") != nil) {
                sceneInfo.m_sDaliyTiming = dict["daliyTiming"] as! String
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
        }
    }
 
    func UpdateSceneTiming(sceneFoot:Int, Timing:String, weeklyDays:String) {
        if (Timing == "") { // no timing
            gDC.mSceneList[sceneFoot].m_sDetailTiming = ""
            gDC.mSceneList[sceneFoot].m_sWeeklyDays = ""
            gDC.mSceneList[sceneFoot].m_sDaliyTiming = ""
        } else if (weeklyDays == "") { // detail timing
            gDC.mSceneList[sceneFoot].m_sDetailTiming = Timing
            gDC.mSceneList[sceneFoot].m_sWeeklyDays = ""
            gDC.mSceneList[sceneFoot].m_sDaliyTiming = ""
        } else { // daliy timing
            gDC.mSceneList[sceneFoot].m_sDetailTiming = ""
            gDC.mSceneList[sceneFoot].m_sWeeklyDays = weeklyDays
            gDC.mSceneList[sceneFoot].m_sDaliyTiming = Timing
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
    var m_sDetailTiming:String = "" // 具体的某个时刻的定时，无法循环
    var m_sWeeklyDays:String = "" // 每周哪几天定时
    var m_sDaliyTiming:String = "" // 每天的定时时间
    
    var mSceneElectricList = [SceneElectricInfoData]()
}
