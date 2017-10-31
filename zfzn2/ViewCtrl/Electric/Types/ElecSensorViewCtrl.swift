//
//  ElecSensorViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/20.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.

import UIKit

class ElecSensorViewCtrl: ElecSuperViewCtrl {//, UITableViewDelegate, UITableViewDataSource
    
    @IBOutlet weak var m_imageElectric: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_labelScene: UILabel!
    @IBOutlet weak var m_imageScene: UIImageView!
    @IBOutlet weak var m_labelSceneName: UILabel!
    
    @IBOutlet weak var m_labelScene2: UILabel!
    @IBOutlet weak var m_imageScene2: UIImageView!
    @IBOutlet weak var m_labelSceneName2: UILabel!
    
    var m_nSceneSelectedIndex:Int! = -1//当前情景开关绑定的情景index
    var m_nSceneSelectedIndex2:Int! = -1//当前情景开关绑定的情景index
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        let nType:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType
        m_imageElectric.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)
        if (nType == 15) {
            m_labelScene2.isHidden = false
            m_imageScene2.isHidden = false
            m_labelSceneName2.isHidden = false
        }
//        switch type {
//        case 13:
//            m_imageElectric.image = UIImage(named: "电器类型_传感器_温度")
//        case 14:
//            m_imageElectric.image = UIImage(named: "电器类型_传感器_水浸")
//        case 15:
//            m_imageElectric.image = UIImage(named: "电器类型_传感器_门磁")
//            m_labelScene2.isHidden = false
//            m_imageScene2.isHidden = false
//            m_labelSceneName2.isHidden = false
//        case 16:
//            m_imageElectric.image = UIImage(named: "电器类型_传感器_燃气")
//        case 17:
//            m_imageElectric.image = UIImage(named: "电器类型_传感器_壁挂红外")
//        case 19:
//            m_imageElectric.image = UIImage(named: "电器类型_传感器_烟雾")
//        default:
//            break
//        }
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        //m_nSceneSelectedIndex = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nSceneIndex
        RefreshUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        RefreshUI()
//        m_nSceneSelectedIndex = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nSceneIndex
//        if m_nSceneSelectedIndex != -1 {
//            for i in 0..<gDC.mSceneList.count {
//                if gDC.mSceneList[i].m_nSceneIndex == m_nSceneSelectedIndex {
//                    m_imageScene.image = gDC.mSceneList[i].m_imageScene
//                    m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
//                    break
//                }
//            }
//        }
    }
    
    func RefreshUI() {
        let type:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType
        if type == 15 {//如果是门磁的话，需要判断两个绑定的情景模式
            m_labelScene.text = "开触发："
            m_labelScene2.text = "关触发："
            var json:JSON!
            let sJson:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras
            if sJson == "" {
                m_nSceneSelectedIndex = -1
                m_nSceneSelectedIndex2 = -1
            }else {
                if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do { json = try JSON(data: jsonData) }
                    catch { print("json error"); return; }
                    if json["SH"].string == nil {
                        m_nSceneSelectedIndex = -1
                    }else {
                        m_nSceneSelectedIndex = Int(json["SH"].string!)
                    }
                    if json["SG"].string == nil {
                        m_nSceneSelectedIndex2 = -1
                    }else {
                        m_nSceneSelectedIndex2 = Int(json["SG"].string!)
                    }
                }
            }
            if m_nSceneSelectedIndex != -1 {
                for i in 0..<gDC.mSceneList.count {
                    if gDC.mSceneList[i].m_nSceneIndex == m_nSceneSelectedIndex {
                        m_imageScene.image = gDC.mSceneList[i].m_imageScene
                        m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
                        break
                    }
                }
            }
            if m_nSceneSelectedIndex2 != -1 {
                for i in 0..<gDC.mSceneList.count {
                    if gDC.mSceneList[i].m_nSceneIndex == m_nSceneSelectedIndex2 {
                        m_imageScene2.image = gDC.mSceneList[i].m_imageScene
                        m_labelSceneName2.text = gDC.mSceneList[i].m_sSceneName
                        break
                    }
                }
            }
        }else {//否则只需要显示第一个绑定的情景
            m_nSceneSelectedIndex = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nSceneIndex
            if m_nSceneSelectedIndex != -1 {
                for i in 0..<gDC.mSceneList.count {
                    if gDC.mSceneList[i].m_nSceneIndex == m_nSceneSelectedIndex {
                        m_imageScene.image = gDC.mSceneList[i].m_imageScene
                        m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
                        break
                    }
                }
            }
        }
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnEdit(_ sender: Any) {
        EditElec()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
