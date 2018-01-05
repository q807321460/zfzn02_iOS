//
//  EditSceneElectricViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/23.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class EditSceneElectricViewCtrl: UIViewController {

    @IBOutlet weak var m_imageElectric: UIImageView!
    @IBOutlet weak var m_labelArea: UILabel!
    @IBOutlet weak var m_switch: UISwitch!
    @IBOutlet weak var m_btnAdd: UIButton!
    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
//    var m_nElectricIndex:Int!
    var m_nSceneListFoot:Int!
    var m_nSceneIndex:Int!
    var m_sElectricOrder:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_btnAdd.layer.cornerRadius = 5.0
        m_btnAdd.layer.masksToBounds = true
        let nType:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType
        switch nType {
        case 0,1,2,3,4,6,7,11,18,20:
            m_imageElectric.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)
        default:
            break
        }
        m_labelArea.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_switch.addTarget(self, action: #selector(SwitchDidChange), for: UIControlEvents.valueChanged)
        g_notiCenter.addObserver(self, selector:#selector(EditSceneElectricViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnAdd(_ sender: Any) {
        //var sElectricOrder:String = ""
        if m_switch.isOn == true {
            m_sElectricOrder = "SH"
        }else {
            m_sElectricOrder = "SG"
        }
        let electricIndex:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex
        let electricCode:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode
        let sceneIndex:Int = gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex
        let orderInfo:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo
        let electricName:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        let electricType:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType
        let roomIndex:Int = gDC.mAreaList[m_nAreaListFoot].m_nAreaIndex
        //判断当前电器是否被重复添加入情景
        for i in 0..<gDC.mSceneList[m_nSceneListFoot].mSceneElectricList.count {
            if gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[i].m_sElectricCode == electricCode && gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[i].m_sOrderInfo == orderInfo {
                ShowNoticeDispatch("提示", content: "该电器已被添加到当前情景，请不要重复添加", duration: 1.5)
                return
            }
        }
        let webReturn = MyWebService.sharedInstance.AddSceneElectric(gDC.mUserInfo.m_sMasterCode, electricCode:electricCode, electricOrder:m_sElectricOrder, accountCode:gDC.mAccountInfo.m_sAccountCode, sceneIndex:sceneIndex, orderInfo:orderInfo, electricIndex:electricIndex, electricName:electricName, roomIndex:roomIndex, electricType:electricType)
        WebAddSceneElectric(webReturn)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    func WebAddSceneElectric(_ responseValue:String){
        switch responseValue{
        case "WebError":
            break
        case "1":
            //向本地数据库添加情景电器
            gDC.mSceneElectricData.AddSceneElectric(m_nAreaListFoot, electricFoot:m_nElectricListFoot, sceneFoot:m_nSceneListFoot, electricOrder:m_sElectricOrder)
            self.navigationController?.popViewController(animated: true)
        default:
            ShowNoticeDispatch("错误", content: "未知的失败", duration: 0.8)
            break
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////
    func SwitchDidChange() {
        //不用做什么
    }
    
    func SyncData() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

}
