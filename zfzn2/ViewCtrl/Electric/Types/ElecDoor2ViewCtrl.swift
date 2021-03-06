//
//  ElecDoor2ViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/8/14.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecDoor2ViewCtrl: ElecSuperViewCtrl {

    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_btnOpen: UIButton!
    @IBOutlet weak var m_btnClose: UIButton!
    @IBOutlet weak var m_labelStateInfo: UILabel!
    @IBOutlet weak var m_btnQureyRecord: UIButton!
    var m_bOpenState:Bool!
    var m_bClicked:Bool! = false
    var m_timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_btnOpen.layer.cornerRadius = 5.0
        m_btnOpen.layer.masksToBounds = true
        m_btnClose.layer.cornerRadius = 5.0
        m_btnClose.layer.masksToBounds = true
        m_btnQureyRecord.layer.cornerRadius = 5.0
        m_btnQureyRecord.layer.masksToBounds = true
        RefreshState()//主要用于更新图片和按钮的状态
        g_notiCenter.addObserver(self, selector:#selector(ElecDoorViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnEdit(_ sender: Any) {
        EditElec()
    }
    
    @IBAction func OnOpen(_ sender: Any) {
        m_sElectricOrder = "01********"
        m_bClicked = true
        //设置超时，总共等待的时间为2s
        m_timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ElecDoor2ViewCtrl.OnTimer), userInfo: nil, repeats: false)
        m_timer.fire()//开启倒计时
        Open()
    }

    @IBAction func OnClose(_ sender: Any) {
        m_sElectricOrder = "02********"
        Close()
    }
    
    @IBAction func OnQureyRecord(_ sender: Any) {
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "doorRecordViewCtrl") as! DoorRecordViewCtrl
        nextView.m_sElectricCode = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    func OnTimer() {
        m_bClicked = false // 两秒之后，设置为非点击状态
    }
    
    func RefreshState() {
        let stateinfo:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sStateInfo
        if (stateinfo == "") {
            return
        }
        let flag:String = (stateinfo as NSString).substring(with: NSMakeRange(0, 1))
        switch flag {
        case "2":
            m_imageElectricType.image = UIImage(named: "门锁_打开")
            m_labelStateInfo.text = "电量足，开锁"
            m_bOpenState = true
        case "3":
            m_imageElectricType.image = UIImage(named: "门锁_关闭")
            m_labelStateInfo.text = "电量足，关锁"
            m_bOpenState = false
        case "4":
            m_imageElectricType.image = UIImage(named: "门锁_打开")
            m_labelStateInfo.text = "电量不足，开锁"
            m_bOpenState = true
        case "5":
            m_imageElectricType.image = UIImage(named: "门锁_关闭")
            m_labelStateInfo.text = "电量不足，关锁"
            m_bOpenState = false
        default:
            m_imageElectricType.image = UIImage(named: "门锁_关闭")
            m_labelStateInfo.text = "电量足，关锁"
            m_bOpenState = false
        }
        
        // 如果状态从关锁变成开锁，同时有人在前两秒之内按下了开锁键，则认为是APP开的锁，需要调用服务器提供的接口：updateDoorOpenPerson，将当前账户告知服务器
        if (m_bOpenState == true && m_bClicked == true) {
            MyWebService.sharedInstance.UpdateDoorOpenPerson(electricCode: gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, accountCode: gDC.mAccountInfo.m_sAccountCode)
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    func RefreshElectricStates() {
        RefreshState()
        
    }
}
