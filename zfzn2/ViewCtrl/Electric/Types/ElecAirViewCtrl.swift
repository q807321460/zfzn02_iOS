//
//  ElecAirConditionViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/2/12.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecAirViewCtrl: ElecSuperViewCtrl {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        RefreshState()//主要用于更新图片和按钮的状态
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        RefreshState()
    }

    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnEdit(_ sender: Any) {
        EditElec()
    }

    func RefreshState() {
    
    }
}
