//
//  ElecClothesViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/24.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecClothesViewCtrl: ElecSuperViewCtrl {

    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_btnUp: UIButton!
    @IBOutlet weak var m_btnStop: UIButton!
    @IBOutlet weak var m_btnDown: UIButton!
    @IBOutlet weak var m_labelUp: UILabel!
    @IBOutlet weak var m_labelStop: UILabel!
    @IBOutlet weak var m_labelDown: UILabel!
    @IBOutlet weak var m_btnLight: UIButton!
    @IBOutlet weak var m_btnDisinfect: UIButton!
    @IBOutlet weak var m_btnKilnDry: UIButton!
    @IBOutlet weak var m_btnAirDry: UIButton!
    @IBOutlet weak var m_btnClose: UIButton!
    @IBOutlet weak var m_btnMatchCode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_imageElectricType.image = UIImage(named: "电器类型_晾衣架")
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_btnLight.layer.cornerRadius = 5.0
        m_btnLight.layer.masksToBounds = true
        m_btnDisinfect.layer.cornerRadius = 5.0
        m_btnDisinfect.layer.masksToBounds = true
        m_btnKilnDry.layer.cornerRadius = 5.0
        m_btnKilnDry.layer.masksToBounds = true
        m_btnAirDry.layer.cornerRadius = 5.0
        m_btnAirDry.layer.masksToBounds = true
        m_btnClose.layer.cornerRadius = 5.0
        m_btnClose.layer.masksToBounds = true
        m_btnMatchCode.layer.cornerRadius = 5.0
        m_btnMatchCode.layer.masksToBounds = true
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
    
    @IBAction func OnUp(_ sender: Any) {
        m_sElectricOrder = "01********"
        Open()
    }
    
    @IBAction func OnStop(_ sender: Any) {
        m_sElectricOrder = "02********"
        Open()
    }
    
    @IBAction func OnDown(_ sender: Any) {
        m_sElectricOrder = "03********"
        Open()
    }
    
    @IBAction func OnLight(_ sender: Any) {
        m_sElectricOrder = "04********"
        Open()
    }
    
    @IBAction func OnDisinfect(_ sender: Any) {
        m_sElectricOrder = "05********"
        Open()
    }
    
    @IBAction func OnKilnDry(_ sender: Any) {
        m_sElectricOrder = "06********"
        Open()
    }
    
    @IBAction func OnAirDry(_ sender: Any) {
        m_sElectricOrder = "07********"
        Open()
    }
    
    @IBAction func OnClose(_ sender: Any) {
        m_sElectricOrder = "08********"
        Open()
    }
    
    @IBAction func OnMatchCode(_ sender: Any) {
        //晾衣架射频对码不能执行两次，否则会出现无法控制的情况
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("继续对码", action: {
                () -> Void in
                self.m_sElectricOrder = "00********"
                self.Open()
            })
            alertView.addButton("返回检查", action: {
                () -> Void in
                return
            })
            alertView.showInfo("菜单", subTitle: "请先确认模块没有与晾衣架对码，如果已经对过码，再次添加会导致设备无法控制", duration: 0)//时间间隔为0时不会自动退出
        })
    }

}
