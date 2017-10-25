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
        m_sElectricOrder = "00********"
        Open()
    }

}
