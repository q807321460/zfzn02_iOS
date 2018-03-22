//
//  ElecSwitchViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/6.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//
//  

import UIKit

class ElecSwitchViewCtrl: ElecSuperViewCtrl {

    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_switchCtrl: UISwitch!//开关控件
    @IBOutlet weak var m_layoutHeight: NSLayoutConstraint!
    
    var m_timer:Timer!
//    var m_bPermit:Bool! = true//远程控制后，几秒内不允许继续控制，防止出现bug
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_switchCtrl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        RefreshState()//主要用于更新图片和按钮的状态
        m_switchCtrl.addTarget(self, action: #selector(SwitchDidChange), for: UIControlEvents.valueChanged)
        g_notiCenter.addObserver(self, selector:#selector(ElecSwitchViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
    }

    deinit {
        g_notiCenter.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnEdit(_ sender: Any) {
        EditElec()
    }
    
    func SwitchDidChange(){
//        if m_bPermit == false {//处于禁用状态，需要过一段时间才能继续控制
//            print("处于禁用状态，需要过一段时间才能继续控制")
//            return
//        }
//        if gDC.m_bRemote == true {
//            m_bPermit = false
//            MyWebService.sharedInstance.StopPolling()//临时关闭电器的轮询
//            m_timer = Timer.scheduledTimer(timeInterval: 2, target:self,selector:#selector(ElecSwitchViewCtrl.OnTimer), userInfo:nil, repeats:false)
//        }
        m_sElectricOrder = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo + "********"
        if m_switchCtrl.isOn {
            Open()
        }else {
            Close()
        }
    }

    func RefreshState() {
        switch gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType {
        case 0: 
            //ZV：开，ZW：关
            let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricState
            if state=="ZV" {
                m_imageElectricType.image = UIImage(named: "电器类型_插座_开")
                m_switchCtrl.isOn = true
            }else {
                m_imageElectricType.image = UIImage(named: "电器类型_插座")
                m_switchCtrl.isOn = false
            }
            
        case 1:
            //Z0：关，Z1：开
            let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricState
            if state=="Z1" {
                m_imageElectricType.image = UIImage(named: "电器_一键开关_开")
                m_switchCtrl.isOn = true
            }else {
                m_imageElectricType.image = UIImage(named: "电器_一键开关_关")
                m_switchCtrl.isOn = false
            }
        case 2:
            //Z0：两边关，Z1：仅左开，Z2：仅右开，Z3：都开
            let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricState
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "01" {//左边开关
                if state=="00" || state=="Z0" ||  state=="Z2" {
                    m_imageElectricType.image = UIImage(named: "电器_两键开关_左关")
                    m_switchCtrl.isOn = false
                }else {
                    m_imageElectricType.image = UIImage(named: "电器_两键开关_左开")
                    m_switchCtrl.isOn = true
                }
            }else {//右边开关
                if state=="00" || state=="Z0" ||  state=="Z1" {
                    m_imageElectricType.image = UIImage(named: "电器_两键开关_右关")
                    m_switchCtrl.isOn = false
                }else {
                    m_imageElectricType.image = UIImage(named: "电器_两键开关_右开")
                    m_switchCtrl.isOn = true
                }
            }
        case 3:
            //Z0：都关，Z1：仅←开，Z2：仅↑开，Z3：仅←↑开，Z4：仅→开，Z5：←→开，Z6：↑→开，Z7：都开
            let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricState
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "01" {
                if state=="00" || state=="Z0" ||  state=="Z2" || state=="Z4" || state=="Z6" {
                    m_imageElectricType.image = UIImage(named: "电器_三键开关_左关")
                    m_switchCtrl.isOn = false
                }else {
                    m_imageElectricType.image = UIImage(named: "电器_三键开关_左开")
                    m_switchCtrl.isOn = true
                }
            }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "02" {
                if state=="00" || state=="Z0" || state=="Z1" ||  state=="Z4" || state=="Z5" {
                    m_imageElectricType.image = UIImage(named: "电器_三键开关_中关")
                    m_switchCtrl.isOn = false
                }else {
                    m_imageElectricType.image = UIImage(named: "电器_三键开关_中开")
                    m_switchCtrl.isOn = true
                }
            }else {
                if state=="00" || state=="Z0" ||  state=="Z1" || state=="Z2" || state=="Z3" {
                    m_imageElectricType.image = UIImage(named: "电器_三键开关_右关")
                    m_switchCtrl.isOn = false
                }else {
                    m_imageElectricType.image = UIImage(named: "电器_三键开关_右开")
                    m_switchCtrl.isOn = true
                }
            }
        default:
            break
        }
    }
    
    func OnTimer() {
//        m_bPermit = true
        MyWebService.sharedInstance.OpenPolling()
    }

    ///////////////////////////////////////////////////////////////////////////////////
    func RefreshElectricStates() {
        RefreshState()
    }
    
}



