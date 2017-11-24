//
//  ElectricData.swift
//  zfzn
//
//  Created by Hanwen Kong on 16/8/25.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import Foundation

class ElectricData: NSObject {
    
    func AddElectric(_ electricType:Int, electricCode:String, electricName:String, electricIndex:Int, electricSequ:Int, areaFoot:Int, extras:String, orderInfo:String) {
        //写入到内存中
        let electricInfo = ElectricInfoData()
        electricInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
        electricInfo.m_nElectricIndex = electricIndex
        electricInfo.m_sElectricCode = electricCode
        electricInfo.m_sElectricName = electricName
        electricInfo.m_nElectricType = electricType
        electricInfo.m_nElectricSequ = electricSequ
        electricInfo.m_nRoomIndex = gDC.mAreaList[areaFoot].m_nAreaIndex
        electricInfo.m_nSceneIndex = -1
        electricInfo.m_sOrderInfo = orderInfo
        electricInfo.m_sExtras = extras
        gDC.mAreaList[areaFoot].mElectricList.append(electricInfo)
//        //写入到本地数据库
//        let dictInsert = NSMutableDictionary()
//        dictInsert.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "master_code" as NSCopying)
////        if gDC.m_dbVersion >= 3 {//版本3之后才有account_code这个字段
//        dictInsert.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
////        }
//        dictInsert.setObject(electricCode, forKey: "electric_code" as NSCopying)
//        dictInsert.setObject(electricIndex, forKey: "electric_index" as NSCopying)
//        dictInsert.setObject(electricName, forKey: "electric_name" as NSCopying)
//        dictInsert.setObject(electricType, forKey: "electric_type" as NSCopying)
//        dictInsert.setObject(electricSequ, forKey: "electric_sequ" as NSCopying)
//        dictInsert.setObject(gDC.mAreaList[areaFoot].m_nAreaIndex, forKey: "room_index" as NSCopying)
//        dictInsert.setObject(orderInfo, forKey: "order_info" as NSCopying)
//        dictInsert.setObject(extras, forKey: "extras" as NSCopying)
//        //        dictInsert.setObject(-1, forKey: "scene_index")//将来添加场景时用
//        gMySqlClass.InsertIntoSql(dictInsert, table: "electrics")
    }
    
    //向web添加电器，这个需要执行在本地添加之前
    func AddElectricToWeb(_ masterCode:String, areaFoot: Int, electricCode: String, electricName:String, electricType:Int, extra:String) ->String {
        var arrayWebReturn = [String]()
        //找到当前房间最大的电器index
        var electricIndex:Int = 0
        for i in 0..<gDC.mAreaList.count {
            for j in 0..<gDC.mAreaList[i].mElectricList.count {
                if gDC.mAreaList[i].mElectricList[j].m_nElectricIndex > electricIndex {
                    electricIndex = gDC.mAreaList[i].mElectricList[j].m_nElectricIndex
                }
            }
        }
        electricIndex = electricIndex + 1
        if electricType == 2 || electricType == 3 || electricType == 4 || electricType == 10 {
            let arrayElectricName = electricName.components(separatedBy: ",")
            var nCount:Int!
            switch electricType {
            case 2:
                nCount = 2
            case 3:
                nCount = 3
            case 4, 10:
                nCount = 4
            default:
                nCount = 0
            }
            for i in 0..<nCount {
                let name:String! = arrayElectricName[i]
                let index:Int = electricIndex
                electricIndex = electricIndex + 1
                let sequ:Int = gDC.mAreaList[areaFoot].mElectricList.count
                let orderInfo:String = "0\(i+1)"
                let webReturn = MyWebService.sharedInstance.AddElectric(masterCode, electricIndex:index, electricCode:electricCode, roomIndex:gDC.mAreaList[areaFoot].m_nAreaIndex, electricName:name, electricSequ:sequ, electricType:electricType, extra:"", orderInfo:orderInfo)
                arrayWebReturn.append(webReturn)
                switch webReturn {
                case "WebError":
                    return "WebError"//立刻退出这个函数，回到界面代码
                case "1":
                    gDC.mElectricData.AddElectric(electricType, electricCode:electricCode, electricName:name, electricIndex:index, electricSequ:sequ, areaFoot:areaFoot, extras:"", orderInfo:orderInfo)
                case "2":
                    return "2"
                default:
                    break
                }
            }
        }else if electricType == 8 {//添加摄像头
            let webReturn = MyWebService.sharedInstance.AddElectric(masterCode, electricIndex:electricIndex, electricCode:gDC.m_sCameraID, roomIndex:gDC.mAreaList[areaFoot].m_nAreaIndex, electricName:electricName, electricSequ:gDC.mAreaList[areaFoot].mElectricList.count, electricType:electricType, extra:gDC.mAccountInfo.m_sAccountCode, orderInfo:"**")
            switch webReturn {
            case "WebError":
                return "WebError"//立刻退出这个函数，回到界面代码
            case "1":
                gDC.mElectricData.AddElectric(electricType, electricCode:gDC.m_sCameraID, electricName:electricName, electricIndex:electricIndex, electricSequ:gDC.mAreaList[areaFoot].mElectricList.count, areaFoot:areaFoot, extras:gDC.mAccountInfo.m_sAccountCode, orderInfo:"**")
            default:
                break
            }
        }else {
            let webReturn = MyWebService.sharedInstance.AddElectric(masterCode, electricIndex:electricIndex, electricCode:electricCode, roomIndex:gDC.mAreaList[areaFoot].m_nAreaIndex, electricName:electricName, electricSequ:gDC.mAreaList[areaFoot].mElectricList.count, electricType:electricType, extra:"", orderInfo:"**")
            switch webReturn {
            case "WebError":
                return "WebError"//立刻退出这个函数，回到界面代码
            case "1":
                gDC.mElectricData.AddElectric(electricType, electricCode:electricCode, electricName:electricName, electricIndex:electricIndex, electricSequ:gDC.mAreaList[areaFoot].mElectricList.count, areaFoot:areaFoot, extras:"", orderInfo:"**")
            default:
                break
            }
        }
        for re in arrayWebReturn {
            if re == "WebError" {
                return "WebError"
            }
        }
        return "1"
    }
    
    func DeleteElectrics(_ masterCode:String) {
//        let requiredDict:NSMutableDictionary = ["master_code": masterCode, "account_code": gDC.mAccountInfo.m_sAccountCode]
//        gMySqlClass.DeleteSql(requiredDict, table: "electrics")
    }
    
    func DeleteElectric(masterCode:String, electricIndex:Int, electricSequ:Int, areaFoot:Int) {
        //首先从本地数据库中删除
//        let requiredDict:NSMutableDictionary = ["master_code": masterCode, "electric_index": electricIndex]
//        gMySqlClass.DeleteSql(requiredDict, table: "electrics")
        //在内存数据中删除，由于在服务器端已经删除了情景中的相同电器，所以这里也需要在本地数据库和内存中删除
        for i in 0..<gDC.mSceneList.count {
            //双重for循环是为了防止出现数组越界
            for _ in 0..<gDC.mSceneList[i].mSceneElectricList.count {
                for j in 0..<gDC.mSceneList[i].mSceneElectricList.count {
                    if gDC.mSceneList[i].mSceneElectricList[j].m_nElectricIndex == electricIndex {
                        gDC.mSceneElectricData.DeleteSceneElectricByFoot(i, electricIndex:gDC.mSceneList[i].mSceneElectricList[j].m_nElectricIndex)
                        break//删除当前情景电器后一定要break，否则会导致数组越界
                    }
                }
            }
        }
        //在当前房间删除
        for i in 0..<gDC.mAreaList[areaFoot].mElectricList.count {
            if gDC.mAreaList[areaFoot].mElectricList[i].m_nElectricIndex == electricIndex {
                gDC.mAreaList[areaFoot].mElectricList.remove(at: i)
                break
            }
        }
        //调整在当前房间中的序号sequ
        for i in 0..<gDC.mAreaList[areaFoot].mElectricList.count {
            if gDC.mAreaList[areaFoot].mElectricList[i].m_nElectricSequ > electricSequ {
                gDC.mAreaList[areaFoot].mElectricList[i].m_nElectricSequ = gDC.mAreaList[areaFoot].mElectricList[i].m_nElectricSequ - 1
                //将新的sequ重新写到本地数据库中，其实这一步是没有必要的
//                let dictSet:NSMutableDictionary = ["electric_sequ":gDC.mAreaList[areaFoot].mElectricList[i].m_nElectricSequ]
//                let dictRequired:NSMutableDictionary = ["electric_index":gDC.mAreaList[areaFoot].mElectricList[i].m_nElectricIndex]
//                gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "electrics")
            }
        }
    }
    
    func UpdateElectric(_ dicts:[NSDictionary]) {
        print("向内存中写入electric数据")
        for i in 0..<gDC.mAreaList.count {
            gDC.mAreaList[i].mElectricList.removeAll()
        }
        DeleteElectrics(gDC.mUserInfo.m_sMasterCode)
        for i in 0..<dicts.count-1 {
            let dict:NSDictionary = dicts[i]
            let electricInfo = ElectricInfoData()
            electricInfo.m_sMasterCode = gDC.mUserInfo.m_sMasterCode
            if (dict.object(forKey: "roomIndex") != nil) {
                electricInfo.m_nRoomIndex = Int(dict["roomIndex"] as! String)!
            }
            if (dict.object(forKey: "electricIndex") != nil) {
                electricInfo.m_nElectricIndex = Int(dict["electricIndex"] as! String)!
            }
            if (dict.object(forKey: "electricName") != nil) {
                electricInfo.m_sElectricName = dict["electricName"] as! String
            }
            if (dict.object(forKey: "electricSequ") != nil) {
                electricInfo.m_nElectricSequ = Int(dict["electricSequ"] as! String)!
            }
            if (dict.object(forKey: "electricCode") != nil) {
                electricInfo.m_sElectricCode = dict["electricCode"] as! String
            }
            if (dict.object(forKey: "electricType") != nil) {
                electricInfo.m_nElectricType = Int(dict["electricType"] as! String)!
//                if electricInfo.m_nElectricType == 21 {//TODO：临时设置一个仅供学习的空调类型，具体该怎么改待定
//                    electricInfo.m_nElectricType = 9
//                }
            }
            if (dict.object(forKey: "sceneIndex") != nil) {
                electricInfo.m_nSceneIndex = Int(dict["sceneIndex"] as! String)!
            }
            if (dict.object(forKey: "extras") != nil) {
                electricInfo.m_sExtras = dict["extras"] as! String
            }
            if (dict.object(forKey: "orderInfo") != nil) {
                electricInfo.m_sOrderInfo = dict["orderInfo"] as! String
            }else {
                electricInfo.m_sOrderInfo = "**"
            }
            //同时根据电器所在的房间号，分配给不同的房间，如果没有找到对应的房间则不更新这个电器（可能是调试时只删除了房间导致的）
            for j in 0..<gDC.mAreaList.count {
                if gDC.mAreaList[j].m_nAreaIndex == electricInfo.m_nRoomIndex {
                    gDC.mAreaList[j].mElectricList.append(electricInfo)
                    break
                }else {
//                    print("多余的无效电器")
                }
            //按房间index的遍历结束
            }
        //按web获取的electric数据的遍历结束
        }
    }
    
    //根据从数据库中获取的电器状态来重置本地电器状态
    func UpdateElectricState(_ dicts:[NSDictionary]) {
        //依次获取各个电器的信息
        for i in 0..<dicts.count {
            let electricCode = dicts[i]["electricCode"] as! String
            var stateInfo:String!
            if (dicts[i].object(forKey: "stateInfo") != nil) {
                stateInfo = dicts[i]["stateInfo"] as! String
            }else {
                break
            }
            var electricState:String!
            if (dicts[i].object(forKey: "electricState") != nil) {
                electricState = dicts[i]["electricState"] as! String
                switch dicts[i]["electricState"] {
                case _ as String:
                    ChangeElectricState(electricCode, electricState: electricState, stateInfo: stateInfo)
                default:
                    break
                }
            }else {
                break
            }
        }
    }
    
    func ChangeElectricState(_ electricCode:String, electricState:String, stateInfo:String) {
        //更新内存中的数据，针对各个区域的电器
        for i in 0..<gDC.mAreaList.count {
            for j in 0..<gDC.mAreaList[i].mElectricList.count {
                if gDC.mAreaList[i].mElectricList[j].m_sElectricCode == electricCode {
                    gDC.mAreaList[i].mElectricList[j].m_sElectricState = electricState
                    gDC.mAreaList[i].mElectricList[j].m_sStateInfo = stateInfo
                }
            }
        }
    }
    
    //在电器视图中更新电器名
    func UpdateElectricInfo(_ electricIndex:Int, electricName:String, sceneIndex:Int) {
        //针对各个区域的电器
        for i in 0..<gDC.mAreaList.count {
            for j in 0..<gDC.mAreaList[i].mElectricList.count {
                if gDC.mAreaList[i].mElectricList[j].m_nElectricIndex == electricIndex {
                    gDC.mAreaList[i].mElectricList[j].m_sElectricName = electricName
                    gDC.mAreaList[i].mElectricList[j].m_nSceneIndex = sceneIndex
                }
            }
        }
        //针对各个情景模式中的电器
        for i in 0..<gDC.mSceneList.count {
            for j in 0..<gDC.mSceneList[i].mSceneElectricList.count {
                if gDC.mSceneList[i].mSceneElectricList[j].m_nElectricIndex == electricIndex {
                    gDC.mSceneList[i].mSceneElectricList[j].m_sElectricName = electricName
                }
            }
        }
    }
    
    //在电器视图中更新电器名，还要更新extras的值（为门磁使用而设计，开触发时extras为SH，关触发时extras为SG）
    func UpdateElectricInfo1(_ electricIndex:Int, electricName:String, sceneIndex:Int, electricOrder:String) {
        var sJson:String! = ""
        //获取extras的初始数据
        for i in 0..<gDC.mAreaList.count {
            for j in 0..<gDC.mAreaList[i].mElectricList.count {
                if gDC.mAreaList[i].mElectricList[j].m_nElectricIndex == electricIndex {
                    sJson = gDC.mAreaList[i].mElectricList[j].m_sExtras
                    if sJson == "" {
                        sJson = "{}"
                    }
                }
            }
        }
        //在本地数据库中更新 
        var json:JSON!
        var json2:JSON!
        if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do { json = try JSON(data: jsonData)
                var dict = json.dictionary
                let sSceneIndex:String = String(sceneIndex)
                if (dict?[electricOrder]?.string == nil) {
                    dict?[electricOrder] = JSON(jsonString: sSceneIndex)
                }
                json2 = JSON(object: dict!)
                print(json2)
            }catch { print("json error") }
        }
        let sJson2:String = json2.rawString() ?? "{}"
        //修改内存中的extras的数据
        for i in 0..<gDC.mAreaList.count {
            for j in 0..<gDC.mAreaList[i].mElectricList.count {
                if gDC.mAreaList[i].mElectricList[j].m_nElectricIndex == electricIndex {
                    gDC.mAreaList[i].mElectricList[j].m_sElectricName = electricName
                    gDC.mAreaList[i].mElectricList[j].m_nSceneIndex = sceneIndex
                    gDC.mAreaList[i].mElectricList[j].m_sExtras = sJson2
                }
            }
        }
        
        //针对各个情景模式中的电器
        for i in 0..<gDC.mSceneList.count {
            for j in 0..<gDC.mSceneList[i].mSceneElectricList.count {
                if gDC.mSceneList[i].mSceneElectricList[j].m_nElectricIndex == electricIndex {
                    gDC.mSceneList[i].mSceneElectricList[j].m_sElectricName = electricName
                }
            }
        }
    }
    
    //把通过web得到的所有分享电器保存在本地数据库
    func UpdateSharedElectric(_ dicts:[NSDictionary]) {
        gDC.mSharedElectricList.removeAll()
        for i in 0..<dicts.count {
            let dict:NSDictionary = dicts[i]
            let electricSharedInfoData = ElectricSharedInfoData()
            if (dict.object(forKey: "masterCode") != nil) {
                electricSharedInfoData.m_sMasterCode = dict["masterCode"] as! String
            }
            if (dict.object(forKey: "accountCode") != nil) {
                electricSharedInfoData.m_sAccountCode = dict["accountCode"] as! String
            }
            if (dict.object(forKey: "electricCode") != nil) {
                electricSharedInfoData.m_sElectricCode = dict["electricCode"] as! String
            }
            if (dict.object(forKey: "electricIndex") != nil) {
                electricSharedInfoData.m_nElectricIndex = Int(dict["electricIndex"] as! String)!
            }
            if (dict.object(forKey: "electricType") != nil) {
                electricSharedInfoData.m_nElectricType = Int(dict["electricType"] as! String)!
            }
            if (dict.object(forKey: "electricName") != nil) {
                electricSharedInfoData.m_sElectricName = dict["electricName"] as! String
            }
            if (dict.object(forKey: "roomIndex") != nil) {
                electricSharedInfoData.m_nRoomIndex = Int(dict["roomIndex"] as! String)!
            }
            if (dict.object(forKey: "isShared") != nil) {
                electricSharedInfoData.m_nIsShared = Int(dict["isShared"] as! String)!
            }
            gDC.mSharedElectricList.append(electricSharedInfoData)
        }
    }
    
    func UpdateSensorExtras(_ nAreaFoot:Int, nElectricFoot:Int, sExtras:String) {
        let nType = gDC.mAreaList[nAreaFoot].mElectricList[nElectricFoot].m_nElectricType
        if nType != 15 {
            //首先修改内存
            gDC.mAreaList[nAreaFoot].mElectricList[nElectricFoot].m_sExtras = sExtras
        }else {
            //门磁类型的电器稍有不同
            var json:JSON!
            var json2:JSON!
            var sJson:String = gDC.mAreaList[nAreaFoot].mElectricList[nElectricFoot].m_sExtras
            if sJson == "" {
                sJson = "{}"
            }
            if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do { json = try JSON(data: jsonData)
                    var dict = json.dictionary
                    dict?["BuFang"] = JSON(jsonString: sExtras)
                    json2 = JSON(object: dict!)
                    print(json2)
                }catch { print("json error") }
            }
            let sJson2:String = json2.rawString() ?? "{}"
            gDC.mAreaList[nAreaFoot].mElectricList[nElectricFoot].m_sExtras = sJson2
        }
    }
    
    func UpdateElectricSequ(electricIndex:Int, roomFoot:Int, oldSequ:Int, newSequ:Int) {
        //只修改内存数据，数据库讲道理是没有必要更新的？
        if (oldSequ < newSequ) {
            for electric in gDC.mAreaList[roomFoot].mElectricList {
                if (electric.m_nElectricSequ > oldSequ && electric.m_nElectricSequ <= newSequ) {
                    electric.m_nElectricSequ = electric.m_nElectricSequ - 1
                }
            }
        }else {
            for electric in gDC.mAreaList[roomFoot].mElectricList {
                if (electric.m_nElectricSequ >= newSequ && electric.m_nElectricSequ < oldSequ) {
                    electric.m_nElectricSequ = electric.m_nElectricSequ + 1
                }
            }
        }
        for electric in gDC.mAreaList[roomFoot].mElectricList {
            if (electric.m_nElectricIndex == electricIndex) {
                electric.m_nElectricSequ = newSequ
            }
        }
    }
    
 }

class ElectricInfoData:NSObject {
    var m_nElectricID:Int = -1//电器id，可以从web获取
    var m_sMasterCode:String = ""//电器所属的主机
    var m_nRoomIndex:Int = -1//电器所属的房间编号
    var m_nElectricIndex:Int = -1//电器唯一编号
    var m_sElectricCode:String = ""//电器编码
    var m_sElectricName:String = ""//电器名
    var m_nElectricSequ:Int = -1//电器排序号
    var m_nElectricType:Int = -1//电器类型
    var m_nSceneIndex:Int = -1//情景控制开关控制哪种情景模式
    var m_sBelong:String = ""//是否属于主控，比如摄像头就是独立的电器，暂时没用上
    var m_sExtras:String = ""//一些额外的信息，比如在摄像头中指的是摄像头拥有者的手机号
    var m_sOrderInfo:String = ""//在开关中，标记是多键开关中的哪一个
    var m_sElectricState:String = "00"//电器状态
    var m_sStateInfo:String = ""//状态信息
    //设置一个用于删除时的标志变量
    var m_bSelected:Bool = false
}

//存贮在本地数据库中的分享电器信息
class ElectricSharedInfoData:NSObject {
    var m_sMasterCode:String = ""
    var m_sAccountCode:String = ""
    var m_sElectricCode:String = ""
    var m_nElectricIndex:Int = -1
    var m_nElectricType:Int = -1
    var m_sOrderInfo:String = ""
    var m_sElectricName:String = ""
    var m_nRoomIndex:Int = -1
    var m_nIsShared:Int = -1
}

class CameraInfo:NSObject {
    var m_sID:String = ""//设备唯一编号
    var m_sAbility:String = ""//可使用情况？
    var m_sCameraFoot:String = ""//设备列表中的脚标
    var m_sChannelFoot:String = ""//通道列表中的脚标
    var m_sChannel:String = "origin"//通道号
}

