//
//  ElecHornViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/24.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecHornViewCtrl: ElecSuperViewCtrl {

    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_btnOpen: UIButton!
    @IBOutlet weak var m_btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_imageElectricType.image = UIImage(named: "电器类型_警号")
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_btnOpen.layer.cornerRadius = 5.0
        m_btnOpen.layer.masksToBounds = true
        m_btnClose.layer.cornerRadius = 5.0
        m_btnClose.layer.masksToBounds = true
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
    
    @IBAction func OnOpen(_ sender: Any) {
        Open()
    }
    
    @IBAction func OnClose(_ sender: Any) {
        Close()
    }

}
