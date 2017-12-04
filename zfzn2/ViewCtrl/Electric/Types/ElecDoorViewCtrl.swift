//
//  ElecDoorViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/3/13.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  门锁类型，需要输入密码

import UIKit

class ElecDoorViewCtrl: ElecSuperViewCtrl {

    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_ePassword: UITextField!
    @IBOutlet weak var m_layoutHeight: NSLayoutConstraint!
    @IBOutlet weak var m_btnClose: UIButton!
    @IBOutlet weak var m_btnOpen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        RefreshState()//主要用于更新图片和按钮的状态
        g_notiCenter.addObserver(self, selector:#selector(ElecDoorViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
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
    
    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
    }

    func RefreshState() {
        m_imageElectricType.image = UIImage(named: "电器类型_门锁")
//        let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricState
//        if state=="ZW" {
//            m_imageElectricType.image = UIImage(named: "电器类型_门锁")
//        }else{
//            m_imageElectricType.image = UIImage(named: "电器类型_门锁")
//        }
    }

    @IBAction func OnClose(_ sender: AnyObject) {
        if m_ePassword.text == "" {
            ShowNoticeDispatch("提示", content: "请输入门锁密码", duration: 0.8)
            return
        }
        if m_ePassword.text!.count > 10 {
            ShowNoticeDispatch("提示", content: "密码长度过长", duration: 0.8)
            return
        }
        m_sElectricOrder = m_ePassword.text!
        while m_sElectricOrder.count < 10 {
            m_sElectricOrder = m_sElectricOrder + "*"
        }
        Close()
    }

    @IBAction func OnOpen(_ sender: AnyObject) {
        if m_ePassword.text == "" {
            ShowNoticeDispatch("提示", content: "请输入门锁密码", duration: 0.8)
            return
        }
        if m_ePassword.text!.count > 10 {
            ShowNoticeDispatch("提示", content: "您输入的密码长度过长", duration: 0.8)
            return
        }
        m_sElectricOrder = m_ePassword.text!
        while m_sElectricOrder.count < 10 {
            m_sElectricOrder = m_sElectricOrder + "*"
        }
        Open()
    }
    
    ///////////////////////////////////////////////////////////////////////////////////
    func RefreshElectricStates() {
        RefreshState()
    }
    
}
