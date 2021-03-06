//
//  ETData.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/7/10.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  红外相关代码

import UIKit

let g_nKey_AIR_POWER:Int = 48153
let g_nKey_AIR_POWER_OFF:Int = 48154
let g_nKey_AIR_COLD_16:Int = 48116
let g_nKey_AIR_COLD_18:Int = 48118
let g_nKey_AIR_COLD_20:Int = 48120
let g_nKey_AIR_COLD_22:Int = 48122
let g_nKey_AIR_COLD_24:Int = 48124
let g_nKey_AIR_COLD_26:Int = 48126
let g_nKey_AIR_COLD_28:Int = 48128
let g_nKey_AIR_COLD_30:Int = 48130
let g_nKey_AIR_HOT_18:Int = 48218
let g_nKey_AIR_HOT_20:Int = 48220
let g_nKey_AIR_HOT_22:Int = 48222
let g_nKey_AIR_HOT_24:Int = 48224
let g_nKey_AIR_HOT_26:Int = 48226
let g_nKey_AIR_HOT_28:Int = 48228

class ETData: NSObject {
    
    func UpdateETKeys(_ jsons:[JSON]) {
        gDC.mETKeyList.removeAll()
        for i in 0..<jsons.count {
            let etkeyInfo = ETKeyInfoData()
            if (jsons[i]["masterCode"].string != nil) {
                etkeyInfo.m_sMasterCode = jsons[i]["masterCode"].string!
            }
            if (jsons[i]["electricIndex"].int != nil) {
                etkeyInfo.m_nElectricIndex = jsons[i]["electricIndex"].int!
            }
            if (jsons[i]["keyName"].string != nil) {
                etkeyInfo.m_sKeyName = jsons[i]["keyName"].string!
            }
            if (jsons[i]["keyValue"].string != nil) {
                etkeyInfo.m_sKeyValue = jsons[i]["keyValue"].string!
            }
            if (jsons[i]["keyKey"].int != nil) {
                etkeyInfo.m_nKeyKey = jsons[i]["keyKey"].int!
            }
            if (jsons[i]["keyBrandIndex"].int != nil) {
                etkeyInfo.m_nKeyBrandIndex = jsons[i]["keyBrandIndex"].int!
            }
            if (jsons[i]["keyBrandPos"].int != nil) {
                etkeyInfo.m_nKeyBrandPos = jsons[i]["keyBrandPos"].int!
            }
            if (jsons[i]["did"].int != nil) {
                etkeyInfo.m_nDid = jsons[i]["did"].int!
            }
            if (jsons[i]["keyX"].int != nil) {
                etkeyInfo.m_nKeyX = jsons[i]["keyX"].int!
            }
            if (jsons[i]["keyY"].int != nil) {
                etkeyInfo.m_nKeyY = jsons[i]["keyY"].int!
            }
            if (jsons[i]["keyRes"].int != nil) {
                etkeyInfo.m_nKeyRes = jsons[i]["keyRes"].int!
            }
            if (jsons[i]["keyRow"].int != nil) {
                etkeyInfo.m_nKeyRow = jsons[i]["keyRow"].int!
            }
            if (jsons[i]["keyState"].int != nil) {
                etkeyInfo.m_nKeyState = jsons[i]["keyState"].int!
            }
            gDC.mETKeyList.append(etkeyInfo)
        }
    }
    
    func DeleteETKeysByMaster(_ masterCode:String) {
    }
    
    func UpdateETAir(_ jsons:[JSON]) {
        gDC.mETKeyList.removeAll()
        DeleteETAirByMaster(gDC.mUserInfo.m_sMasterCode)
        for i in 0..<jsons.count {
            let etAirDeviceInfo = ETAirDeviceInfoData()
            if (jsons[i]["masterCode"].string != nil) {
                etAirDeviceInfo.m_sMasterCode = jsons[i]["masterCode"].string!
            }
            if (jsons[i]["electricIndex"].int != nil) {
                etAirDeviceInfo.m_nElectricIndex = jsons[i]["electricIndex"].int!
            }
            if (jsons[i]["airBrand"].int != nil) {
                etAirDeviceInfo.m_nAirBrand = jsons[i]["airBrand"].int!
            }
            if (jsons[i]["airIndex"].int != nil) {
                etAirDeviceInfo.m_nAirIndex = jsons[i]["airIndex"].int!
            }
            if (jsons[i]["airTemp"].int != nil) {
                etAirDeviceInfo.m_nAirTemp = jsons[i]["airTemp"].int!
            }
            if (jsons[i]["airRate"].int != nil) {
                etAirDeviceInfo.m_nAirRate = jsons[i]["airRate"].int!
            }
            if (jsons[i]["airDir"].int != nil) {
                etAirDeviceInfo.m_nAirDir = jsons[i]["airDir"].int!
            }
            if (jsons[i]["airAutoDir"].int != nil) {
                etAirDeviceInfo.m_nAirAutoDir = jsons[i]["airAutoDir"].int!
            }
            if (jsons[i]["airMode"].int != nil) {
                etAirDeviceInfo.m_nAirMode = jsons[i]["airMode"].int!
            }
            if (jsons[i]["airPower"].int != nil) {
                etAirDeviceInfo.m_nAirPower = jsons[i]["airPower"].int!
            }
            
            gDC.mETAirDeviceList.append(etAirDeviceInfo)
            //并重新写入本地数据库
            let dictInsert = NSMutableDictionary()
            dictInsert.setObject(etAirDeviceInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nElectricIndex, forKey: "electric_index" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirBrand, forKey: "air_brand" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirIndex, forKey: "air_index" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirTemp, forKey: "air_temp" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirRate, forKey: "air_rate" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirDir, forKey: "air_dir" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirAutoDir, forKey: "air_auto_dir" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirMode, forKey: "air_mode" as NSCopying)
            dictInsert.setObject(etAirDeviceInfo.m_nAirPower, forKey: "air_power" as NSCopying)
            gMySqlClass.InsertIntoSql(dictInsert, table: "etairdevice")
        }
    }
    
    func DeleteETAirByMaster(_ masterCode:String) {
    }
    
}

class ETKeyInfoData:NSObject {
    var m_sMasterCode:String = ""
    var m_nElectricIndex:Int = -1
    var m_nDid:Int = -1//暂不知道是干什么用的
    var m_sKeyName:String = ""
    var m_nKeyRes:Int = -1
    var m_nKeyX:Int = -1
    var m_nKeyY:Int = -1
    var m_sKeyValue:String = ""
    var m_nKeyKey:Int = -1
    var m_nKeyBrandIndex:Int = -1
    var m_nKeyBrandPos:Int = -1
    var m_nKeyRow:Int = -1
    var m_nKeyState:Int = -1
}

class ETAirDeviceInfoData:NSObject {
    var m_sMasterCode:String = ""
    var m_nElectricIndex:Int = -1
    var m_nAirBrand:Int = -1
    var m_nAirIndex:Int = -1
    var m_nAirTemp:Int = -1
    var m_nAirRate:Int = -1
    var m_nAirDir:Int = -1
    var m_nAirAutoDir:Int = -1
    var m_nAirMode:Int = -1
    var m_nAirPower:Int = -1
}








