//
//  ElecCurtainViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/3/11.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  窗帘是一种界面风格

import UIKit

class ElecCurtainViewCtrl: ElecSuperViewCtrl {

    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_slider: UISlider!
    
    @IBOutlet weak var m_labelClose: UILabel!
    @IBOutlet weak var m_labelRatio: UILabel!
    @IBOutlet weak var m_labelOpen: UILabel!
    @IBOutlet weak var m_btnClose: UIButton!
    @IBOutlet weak var m_btnStop: UIButton!
    @IBOutlet weak var m_btnOpen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_slider.minimumValue = 0
        m_slider.maximumValue = 100
        m_slider.isContinuous = false  //滑块滑动停止后才触发ValueChanged事件
        RefreshState()
        m_slider.addTarget(self,action:#selector(ElecCurtainViewCtrl.SliderDidchange(_:)), for:UIControlEvents.valueChanged)
        g_notiCenter.addObserver(self, selector:#selector(ElecCurtainViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func RefreshState() {
        var sStateInfo:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sStateInfo
        if sStateInfo.count < 2 {//这是不允许出现的情况
            sStateInfo = "00"
        }else {
            sStateInfo = (sStateInfo as NSString).substring(with: NSMakeRange(0, 2)) 
        }
        let nPercent:Int = GetPercentByString(sStateInfo)
        if nPercent == 0 {//完全关闭时显示关状态图片
            m_imageElectricType.image = UIImage(named: "电器类型_窗帘")
        }else {//只要打开一点点，就可以显示开状态的图片
            m_imageElectricType.image = UIImage(named: "电器类型_窗帘_开")
        }
        m_slider.setValue(Float(nPercent), animated: true)
    }
    
    
    func SliderDidchangeForScene(_ slider:UISlider){
        let percent = Int(slider.value)
        m_labelRatio.text = "比例：\(percent)%"
        m_sElectricOrder = GetStringByPercent(percent)
    }
    
    func SliderDidchange(_ slider:UISlider){
        let percent = Int(slider.value)
        m_labelRatio.text = "比例：\(percent)%"
        m_sElectricOrder = GetStringByPercent(percent)
        Open()
    }
    
    @IBAction func OnClose(_ sender: AnyObject) {
        m_slider.setValue(0, animated: true)
        m_labelRatio.text = "比例：0%"
        m_sElectricOrder = GetStringByPercent(0)
        Close()
    }
    
    @IBAction func OnStop(_ sender: AnyObject) {
        Stop()
    }
    
    @IBAction func OnOpen(_ sender: AnyObject) {
        m_slider.setValue(100, animated: true)
        m_labelRatio.text = "比例：100%"
        m_sElectricOrder = GetStringByPercent(100)
        Open()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func RefreshElectricStates() {
        RefreshState()
    }

}
