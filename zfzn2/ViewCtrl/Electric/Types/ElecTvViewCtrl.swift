//
//  ElecTvViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/21.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecTvViewCtrl: ElecSuperViewCtrl {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
