//
//  DataControl.swift
//  数据量相对较大，故应当将数据分别保存在几个不同的类中
//
//  Created by Hanwen Kong on 16/7/8.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import Foundation
import UIKit

//全局的控制类
let gDC = DataControl.sharedInstance //全局数据控制对象,保存所有使用的数据
var gMySqlClass = MySqlCtrl()//自己的数据库控制类
var g_SQLiteDB:SQLiteDB!//别人的封装过的数据库控制类
var g_notiCenter = NotificationCenter.default//全局消息响应中心
var g_webSocket:SRWebSocket = SRWebSocket()

let g_sElectric_type_socket = "00"//插座
let g_sElectric_type_swift_one = "01"//一键开关
let g_sElectric_type_swift_two = "02"//两件开关
let g_sElectric_type_swift_three = "03"//三键开关
let g_sElectric_type_swift_four = "04"//四键开关
let g_sElectric_type_lock = "05"//门锁
let g_sElectric_type_curtain = "06"//窗帘
let g_sElectric_type_window = "07"//窗户
let g_sElectric_type_camera = "08"//摄像头
let g_sElectric_type_air = "09"//空调
let g_sElectric_type_scene_swift = "0A"//情景开关
let g_sElectric_type_valve = "0B"//机械手
let g_sElectric_type_tv = "09"//电视
let g_sElectric_type_temperature = "0DA1"//温度计
let g_sElectric_type_water = "0D73"//水浸
let g_sElectric_type_door = "0D31"//门磁
let g_sElectric_type_gas = "0D41"//燃气
let g_sElectric_type_wall_ir = "0D21"//壁挂红外
let g_sElectric_type_horn = "0E"//警号
let g_sElectric_type_smoke = "0D51"//烟雾
let g_sElectric_type_clothes = "0F"//晾衣架
let g_sElectric_type_air_learn = "09"//学习型空调
let g_sElectric_type_air_center = "0800" //中央空调
let g_sElectric_type_lock2 = "1000"//新门锁，这是第23种电器
let g_sElectric_type_tv_learn = "09"//学习型空调
let g_sElectric_type_air_center2 = "1100" //中央空调2
let g_sElectric_type_lampband = "1200"//灯带
let g_sElectric_type_swift_double = "0A01"//双控开关

@objc class DataControl: NSObject {
    let m_arrayElectricTypeCode:NSArray = [g_sElectric_type_socket, g_sElectric_type_swift_one, g_sElectric_type_swift_two, g_sElectric_type_swift_three, g_sElectric_type_swift_four, g_sElectric_type_lock, g_sElectric_type_curtain, g_sElectric_type_window, g_sElectric_type_camera, g_sElectric_type_air, g_sElectric_type_scene_swift, g_sElectric_type_valve, g_sElectric_type_tv, g_sElectric_type_temperature, g_sElectric_type_water, g_sElectric_type_door, g_sElectric_type_gas, g_sElectric_type_wall_ir, g_sElectric_type_horn, g_sElectric_type_smoke, g_sElectric_type_clothes, g_sElectric_type_air_learn, g_sElectric_type_air_center, g_sElectric_type_lock2, g_sElectric_type_tv_learn,g_sElectric_type_air_center2,g_sElectric_type_lampband,g_sElectric_type_swift_double]
    let m_arrayElectricImage:NSArray = ["电器类型_插座", "电器类型_一键开关", "电器类型_两键开关", "电器类型_三键开关", "电器类型_四键开关", "电器类型_门锁", "电器类型_窗帘", "电器类型_窗户", "电器类型_摄像头", "电器类型_空调", "电器类型_四键开关", "电器类型_机械手", "电器类型_电视", "电器类型_传感器_温度", "电器类型_传感器_水浸", "电器类型_传感器_门磁", "电器类型_传感器_燃气", "电器类型_传感器_壁挂红外", "电器类型_警号", "电器类型_传感器_烟雾", "电器类型_晾衣架", "电器类型_空调", "电器类型_空调", "电器类型_门锁", "电器类型_电视", "电器类型_中央空调", "电器类型_灯带", "电器类型_双控开关"]
    let m_arrayElectricLabel:NSArray = ["插座", "一键开关", "两键开关", "三键开关", "四键开关", "门锁", "窗帘", "窗户", "摄像头", "空调", "情景开关", "机械手", "电视", "温度计", "水浸", "门磁", "燃气报警", "壁挂红外", "警号", "烟雾报警", "晾衣架", "学习型空调", "中央空调", "新门锁", "学习型电视", "中央空调", "灯带", "双控开关"]
    let m_arraySensorState:NSDictionary = ["00": "普通", "01": "报警", "02": "防拆", "03": "报警+防拆", "04": "电量低", "05": "报警+电量低", "06": "防拆+电量低", "07": "报警+防拆+电量低"]
    
    let m_appVersion = "1.8.012" //每次更新版本，记得要修改这里的版本号
    
    let m_sLocalIp:String = "192.168.0.108"
    let m_sWebIp:String = "101.201.211.87"
    let m_sAddLeft = "000000"
    let m_sOrderSign:String = "X", m_sAddSign:String = "Y", m_sStateSign:String = "Z"
    let m_sOrderClose:String = "G", m_sOrderOpen:String = "H", m_sOrderStop:String = "I"
    let m_sStateClose:String = "W", m_sStateOpen:String = "V", m_sStateStop:String = "U"
    let m_sCentralAir:String = "S"
    let m_sStateClear:String = "R"
    let m_colorFont = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)//主页label使用的颜色
    let m_colorPurple = UIColor(red: 139/255, green: 39/255, blue: 114/255, alpha: 1)//紫色，整个app的主色调
    let m_colorTouching = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)//手指按下时菜单使用的背景色
    let m_dbVersion = 6//记录当前版本对应的最新数据库版本号，用于更新数据库格式
    
    //以下为天气相关，1.5版本后失效，但是变量暂时保留之
    let m_nWeatherDeltaTime:Int = 7200//两次刷新天气信息的时间间隔定位7200秒，也就是两个小时
    var m_bFirstGetWeather:Bool = true//是否第一次获取天气，如果是则不考虑7200秒的间隔，直接从web加载天气信息
    var m_timeGetWeather:Date! //上一次获取天气的时间
    var m_sProvinceName:String = "直辖市" // 保存省份，用于获取天气信息
    var m_sCityName:String = "北京" // 保存城市名，用于获取天气信息
    var m_sWeatherFrom:String = "0" // 保存初始天气图片名
    var m_sWeatherTo:String = "1" // 保存后续天气图片名
    
    var m_sWeatherTemperature:String = "获取温度失败" // 温度值，默认为失败
    var m_sWeatherInfo:String = "获取天气信息失败" // 其他天气信息，默认为失败
    
    var m_dbVersionOld:Int = -1 // 因为更新软件时，沙盒中的数据库等没有变化，因此需要判断先前的版本是多少
    var m_bUseProgramSQL:Bool = true     // 是否使用本地工程内数据库，该变量只有在调试时使用，基本用不上了
    var m_bTestRemote:Bool = false        // 是否在本地服务器下测试远程控制，这个在上传时一定要记得修改回false
    var m_bUseRemoteService:Bool = true   //【醒目】是否使用远程服务器，若不然使用本地服务器，上传新版本时一定要记得修改回true
    var m_bRemote:Bool = true            // 是否处于远程状态
    var m_sLastMasterCode:String!          // 上次登录的主机编码（确定是否为本地主机）
    
    var m_nSelectRowUser:Int = -1      //当前选中的用户行号
    var m_nSelectAreaSequ:Int = 0      //当前选中的房间号，默认为0
    var m_nSelectElecIndex:Int = -1     //当前选中的电器号
    var m_nSelectSceneSequ:Int = -1    //当前选中的情景号,默认为-1，也就是没有选择
    
    var mAccountData = AccountData()    //账户对象，对应了一个手机号
    var mAreaData = AreaData()           //区域对象
    var mElectricData = ElectricData()      //电器对象
    var mUserData = UserData()           //用户对象
    var mSceneData = SceneData()         //情景对象
    var mSceneElectricData = SceneElectricData()    //情景电器对象
    var mETData = ETData()               //红外对象
    
    var mAccountInfo = AccountInfoData()                //账户对象列表
    var mSharedAccountList = [AccountInfoData]()         //该主机被分享的账户
    var mUserInfo = UserInfoData()                      //账户对象列表
    var mAreaList = [AreaInfoData]()                     //区域对象列表
    var mSharedElectricList = [ElectricSharedInfoData]()    //分享电器对象列表
    var mUserList = [UserInfoData]()                      //用户对象列表
    var mSceneList = [SceneInfoData]()                    //情景对象列表
    var mETKeyList = [ETKeyInfoData]()                   //红外键值列表
    var mETAirDeviceList = [ETAirDeviceInfoData]()        //空调状态列表
    
    var m_bSyncing:Bool = false            //是否处于同步中
    var m_bRefreshAreaList:Bool = false     //刷新显示所有的房间和电器，此变量在删除房间和删除电器之类的操作后变更
    var m_bQuickScene:Bool = false         //是否快捷跳转情景模式

    //乐橙摄像头部分，务必不能修改
    let m_sLechangeID:String = "lce2ce9e43c32147a9"
    let m_sLechangeSecret:String = "b05c139f501149b09ecaaefcc12792"
    var m_sCameraToken:String = "origin"
    var m_sCameraID:String = ""
    var mCameraInfo:CameraInfo = CameraInfo()
    var m_sUnbindSuccess:String = "false"//用于记录是否解绑成功
    
    var mElectricState = Dictionary<String, [String]>()
    
    let m_dAnimationDuration:TimeInterval = 0.15 //弹出视图的显示时间
    let m_dAnimationStartOffset:CGFloat = -10//弹出视图从上方弹出的滑动距离
    
    internal static let sharedInstance = DataControl()//保证是单例运行
    fileprivate override init() {}
    
}

//ezCam摄像头

