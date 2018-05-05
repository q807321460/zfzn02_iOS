//
//  RenameCentralAir.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/5/3.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class RenameCentralAir: UIViewController {
    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
    var m_nCentralAirListFoot:Int!
    var mCentralAirList = [ElecCentralAirData]()

    @IBOutlet weak var m_Roomname: UITextField!
    @IBOutlet weak var m_Inaddress: UILabel!
    @IBOutlet weak var m_Outaddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var address:String = mCentralAirList[m_nCentralAirListFoot].m_CentralAircodes
        m_Outaddress.text = (address as NSString).substring(with: NSMakeRange(0, 2))
        m_Inaddress.text = (address as NSString).substring(with: NSMakeRange(2, 2))
        m_Roomname.text = mCentralAirList[m_nCentralAirListFoot].m_CentralAirNumber
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnRename(_ sender: Any) {
        if m_Roomname.text!.count == 0{
            ShowInfoDispatch("提示", content: "房间名不能为空", duration: 0.8)
        }else{
        let NewairName:String = m_Roomname.text!
        let airCode:String = mCentralAirList[m_nCentralAirListFoot].m_CentralAircodes
        let masterCode:String = gDC.mUserInfo.m_sMasterCode
        let electricIndex:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex
        let webResult:String = MyWebService.sharedInstance.UpdateCentralAirName(masterCode:masterCode,electricIndex:electricIndex,airCode:airCode,newAirName:NewairName)
        WebUpdateCentralAirName(responseValue: webResult)
        }
    }
    func WebUpdateCentralAirName(responseValue:String){
        switch responseValue {
        case "WebError":
            break
        case "1":
            mCentralAirList[m_nCentralAirListFoot].m_CentralAirNumber = m_Roomname.text!
            ShowInfoDispatch("提示", content: "修改房间名成功", duration: 0.8)
        default:
            break
        }
    }
    
    @IBAction func Onbak(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
