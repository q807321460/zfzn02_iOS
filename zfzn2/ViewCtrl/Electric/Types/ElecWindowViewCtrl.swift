//
//  ElecWindowViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/23.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecWindowViewCtrl: ElecSuperViewCtrl {

    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    
    @IBOutlet weak var m_btnClose: UIButton!
    @IBOutlet weak var m_btnStop: UIButton!
    @IBOutlet weak var m_btnOpen: UIButton!
    var m_nElectricType:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_nElectricType = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType
        m_imageElectricType.image = UIImage(named: "电器类型_窗帘")
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        RefreshState()//主要用于更新图片和按钮的状态
        g_notiCenter.addObserver(self, selector:#selector(ElecWindowViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
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
    
    func RefreshState() {
        //ZV开，ZW关，ZU停
        let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricState
        if m_nElectricType == 7 {//窗户
            if state == "ZW" {
                m_imageElectricType.image = UIImage(named: "电器类型_窗户")
            }else {
                m_imageElectricType.image = UIImage(named: "电器类型_窗户_开")
            }
        }else if m_nElectricType == 11 {//机械手
            if state == "ZW" {
                m_imageElectricType.image = UIImage(named: "电器类型_机械手")
            }else {
                m_imageElectricType.image = UIImage(named: "电器类型_机械手_开")
            }
        }
    }

    @IBAction func OnClose(_ sender: AnyObject) {
        Close()
    }
    
    @IBAction func OnStop(_ sender: AnyObject) {
        Stop()
    }
    
    @IBAction func OnOpen(_ sender: AnyObject) {
        Open()
    }

    ////////////////////////////////////////////////////////////////////////////////////
    func RefreshElectricStates() {
        RefreshState()
    }
    
}
