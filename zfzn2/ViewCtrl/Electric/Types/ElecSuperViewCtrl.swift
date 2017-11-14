//
//  ElecSuperViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/3/14.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecSuperViewCtrl: UIViewController {

    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
    var m_sElectricOrder:String = "0000000000"
    
    var m_nSceneListFoot:Int!//添加情景电器时用到
    
    override func viewDidLoad() {
        super.viewDidLoad()
        g_notiCenter.addObserver(self, selector:#selector(ElecSuperViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func EditElec() {
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "editElectricViewCtrl") as! EditElectricViewCtrl
        nextView.m_nAreaListFoot = m_nAreaListFoot
        nextView.m_nElectricListFoot = m_nElectricListFoot
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    func Open() {
        if gDC.m_bTestRemote == true {//强制使用远程web控制
            MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, order:gDC.m_sOrderSign+gDC.m_sOrderOpen, orderInfo:m_sElectricOrder)
        }else {
            if gDC.m_bRemote == false {//本地socket控制
                MySocket.sharedInstance.OperateElectric("<\(gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode)\(gDC.m_sOrderSign)\(gDC.m_sOrderOpen)\(m_sElectricOrder)00>")
            }else {//远程web控制
                MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, order:gDC.m_sOrderSign+gDC.m_sOrderOpen, orderInfo:m_sElectricOrder)
            }
        }
    }
    
    func Close() {
        if gDC.m_bTestRemote == true {//强制使用远程web控制
            MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, order:gDC.m_sOrderSign+gDC.m_sOrderClose, orderInfo:m_sElectricOrder)
        }else {
            if gDC.m_bRemote == false {//本地socket控制
                MySocket.sharedInstance.OperateElectric("<\(gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode)\(gDC.m_sOrderSign)\(gDC.m_sOrderClose)\(m_sElectricOrder)00>")
            }else {//远程web控制
                MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, order:gDC.m_sOrderSign+gDC.m_sOrderClose, orderInfo:m_sElectricOrder)
            }
        }
    }
    
    func Stop() {
        if gDC.m_bTestRemote == true {//强制使用远程web控制
            MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, order:gDC.m_sOrderSign+gDC.m_sOrderStop, orderInfo:m_sElectricOrder)
        }else {
            if gDC.m_bRemote == false {//本地socket控制
                MySocket.sharedInstance.OperateElectric("<\(gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode)\(gDC.m_sOrderSign)\(gDC.m_sOrderStop)\(m_sElectricOrder)00>")
            }else {//远程web控制
                MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, order:gDC.m_sOrderSign + gDC.m_sOrderStop, orderInfo:m_sElectricOrder)
            }
        }
    }
    
    func SyncData() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
