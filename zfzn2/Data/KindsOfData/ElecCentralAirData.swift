//
//  ElecCentralAirData.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/3/15.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecCentralAirData: NSObject {
var mCentralAir=[CentralAirInfoData]()
}

class CentralAirInfoData: NSObject {
    var m_CentralAirNumber:String = "编号"
    var m_CentralAirPattern:String = "模式"
    var m_CentralAirSwitch:String = "开/关"
    var m_CentralAirRoomtemperature:String = "室内温度"
    var m_CentralAirSettemperature:String = "设定温度"
    var m_CentralAirWindspeed:String = "风速"
    var m_CentralAirErrorcode:String = "错误码"
    var m_CentralAirState=UIImage(named: "中央空调红色")//没有判断是否在线状态
    var m_CentralAircheck=UIImage(named: "登录_对钩")
    
}
