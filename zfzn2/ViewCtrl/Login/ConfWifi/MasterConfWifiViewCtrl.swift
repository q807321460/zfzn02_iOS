//
//  ConfWifiViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/10/9.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class MasterConfWifiViewCtrl: UIViewController {

    @IBOutlet weak var m_btnConf: UIButton!
    @IBOutlet weak var m_labelWifi: UITextField!
    @IBOutlet weak var m_labelPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.m_btnConf.layer.cornerRadius = 5.0
        self.m_btnConf.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            print("从主机配网界面返回到登录界面")
        })
    }
    
    @IBAction func OnConf(_ sender: Any) {
        MySocket.sharedInstance.ConfWifi(sWifi: m_labelWifi.text!, sPassWord: m_labelPassword.text!)
    }

}
