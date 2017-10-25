//
//  EditCameraViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/2/14.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  报警记录，发布

import UIKit

class EditCameraViewCtrl: UIViewController {

    @IBOutlet weak var m_eCameraName: UITextField!
    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_eCameraName.text = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetInfo(_ areaFoot:Int, electricFoot:Int){
        m_nAreaListFoot = areaFoot
        m_nElectricListFoot = electricFoot
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSave(_ sender: AnyObject) {
        self.view.endEditing(true)
        if m_eCameraName.text == "" {
            ShowNoticeDispatch("提示", content: "请输入有效的新摄像头名", duration: 1.0)
            return
        }
        let webReturn = MyWebService.sharedInstance.UpdateElectric(gDC.mAreaList[m_nAreaListFoot].m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, electricIndex:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex, electricName:m_eCameraName.text!, sceneIndex:-1)
        WebUpdateElectric(webReturn)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateElectric(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            //向内存和本地数据库中更新
            gDC.mElectricData.UpdateElectricInfo(gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex, electricName:m_eCameraName.text!, sceneIndex:-1)
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }

}
