//
//  SensorViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/22.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  type为15的传感器：门磁，需要做特殊的处理

import UIKit

class SensorViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource, MySensorCellDelegate {

    @IBOutlet weak var m_imageNull: UIImageView!
    @IBOutlet weak var m_labelNull: UILabel!
    @IBOutlet weak var m_tableSensor: UITableView!
    
    var m_nCount:Int = 0
    var mAreaFootList = [Int]()//保存传感器所在房间foot的列表
    var mElectricFootList = [Int]()//保存传感器对应的电器foot的列表
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false//保证对齐顶端，去除的话，会在上部留出空白
        m_tableSensor.register(MySensorCell.self, forCellReuseIdentifier: "mySensorCell")
        let nib = UINib(nibName: "MySensorCell", bundle: nil)
        m_tableSensor.register(nib, forCellReuseIdentifier: "mySensorCell")
        m_tableSensor.bounces = false//不需要弹簧效果
        m_tableSensor.tableFooterView = UIView()//隐藏多余行
        
        InitTable()
        m_tableSensor.reloadData()
        g_notiCenter.addObserver(self, selector:#selector(SensorViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
        g_notiCenter.addObserver(self, selector:#selector(AddSceneElectricViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        InitTable()
        m_tableSensor.reloadData()
    }
    
    func InitTable() {
        m_nCount = 0
        mAreaFootList.removeAll()
        mElectricFootList.removeAll()
        for i in 0..<gDC.mAreaList.count {
            for j in 0..<gDC.mAreaList[i].mElectricList.count {
                let nType:Int = gDC.mAreaList[i].mElectricList[j].m_nElectricType
                if (nType>=13 && nType<=17) || nType==19 {
                    m_nCount = m_nCount + 1
                    mAreaFootList.append(i)
                    mElectricFootList.append(j)
                }
            }
        }
        if m_nCount == 0 {//没有传感器的话，隐藏table，显示图片和文本
            m_tableSensor.isHidden = true
        }else {
            m_tableSensor.isHidden = false
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_nCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i:Int = mAreaFootList[indexPath.row]
        let j:Int = mElectricFootList[indexPath.row]
        let nType:Int = gDC.mAreaList[i].mElectricList[j].m_nElectricType
        let cell:MySensorCell = tableView.dequeueReusableCell(withIdentifier: "mySensorCell", for: indexPath) as! MySensorCell
        cell.m_imageView.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)
        cell.m_labelArea.text = gDC.mAreaList[i].m_sAreaName
        cell.m_labelElectric.text = gDC.mAreaList[i].mElectricList[j].m_sElectricName
        var sExtras:String = gDC.mAreaList[i].mElectricList[j].m_sExtras
        if nType != 15 {
            if sExtras == "0" {
                cell.m_switch.isOn = false
            }else {
                cell.m_switch.isOn = true
            }
        }else {
            var json:JSON = JSON.null
            if sExtras == "" {
                sExtras = "{}"
            }
            if let jsonData = sExtras.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do { json = try JSON(data: jsonData)
                    var dict = json.dictionary
                    if (dict?["BuFang"]?.string == nil || dict?["BuFang"]?.string == "1") {
                        cell.m_switch.isOn = true
                    }else {
                        cell.m_switch.isOn = false
                    }
                }catch { print("json error") }
            }
        }
        let sStateInfo:String = gDC.mAreaList[i].mElectricList[j].m_sStateInfo
        let sInfo:String = (sStateInfo as NSString).substring(with: NSMakeRange(0, 2))
        cell.m_labelStateInfo.text = gDC.m_arraySensorState[sInfo] as? String
        cell.m_nAreaFoot = i
        cell.m_nElectricFoot = j
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateSensorExtras(_ responseValue:String, nAreaFoot:Int, nElectricFoot:Int, sExtras:String) {
        switch responseValue{
        case "WebError":
            break
        case "1":
            if sExtras == "1" {
                ShowInfoDispatch("提示", content: "布防成功", duration: 0.5)
            }else {//sExtras == "0"
                ShowInfoDispatch("提示", content: "撤防成功", duration: 0.5)
            }
            gDC.mElectricData.UpdateSensorExtras(nAreaFoot, nElectricFoot: nElectricFoot, sExtras: sExtras)
        default:
            if sExtras == "1" {
                ShowNoticeDispatch("错误", content: "布防失败", duration: 0.5)
            }else {//sExtras == "0"
                ShowNoticeDispatch("错误", content: "撤防失败", duration: 0.5)
            }
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func didSwitchChange(_ bSwitchOn:Bool, nAreaFoot:Int, nElectricFoot:Int) {
        let sMasterCode:String = gDC.mUserInfo.m_sMasterCode
        let sElectricCode:String = gDC.mAreaList[nAreaFoot].mElectricList[nElectricFoot].m_sElectricCode
        let nElectricIndex:Int = gDC.mAreaList[nAreaFoot].mElectricList[nElectricFoot].m_nElectricIndex
        if bSwitchOn == true {//布防
            let webReturn:String = MyWebService.sharedInstance.UpdateSensorExtras(masterCode: sMasterCode, electricCode: sElectricCode, electricIndex: nElectricIndex, extras: "1")
            WebUpdateSensorExtras(webReturn, nAreaFoot:nAreaFoot, nElectricFoot:nElectricFoot, sExtras: "1")
        }else {//撤防
            let webReturn:String = MyWebService.sharedInstance.UpdateSensorExtras(masterCode: sMasterCode, electricCode: sElectricCode, electricIndex: nElectricIndex, extras: "0")
            WebUpdateSensorExtras(webReturn, nAreaFoot:nAreaFoot, nElectricFoot:nElectricFoot, sExtras: "0")
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    func RefreshElectricStates() {
        m_tableSensor.reloadData()
    }
    
    func SyncData() {
        m_tableSensor.reloadData()
    }
}





