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
        //写入到内存
        let areaInfo = AreaInfoData()
        areaInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
        areaInfo.m_sAreaName = areaName
        areaInfo.m_nAreaIndex = areaIndex
        areaInfo.m_nAreaSequ = areaSequ
        gDC.mAreaList.append(areaInfo)
    }
    
    func DeleteAreaByMaster(_ masterCode:String) {
    }
    
    func DeleteAreaByFoot(_ foot:Int) {
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
