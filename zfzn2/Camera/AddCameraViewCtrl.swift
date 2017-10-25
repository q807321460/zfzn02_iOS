//
//  AddCameraViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/2/6.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class AddCameraViewCtrl: UIViewController {

    @IBOutlet weak var m_eSerial: UITextField!
    @IBOutlet weak var m_eWifiPassword: UITextField!
    @IBOutlet weak var m_labelSSID: UILabel!
    @IBOutlet weak var m_labelHint: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
