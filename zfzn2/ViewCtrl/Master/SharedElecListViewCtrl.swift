//
//  SharedElecListViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/4/7.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SharedElecListViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource, SharedElectricCellDelegate {

    @IBOutlet weak var m_tableSharedElectric: UITableView!
    var m_nSharedAccountListFoot:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = gDC.mSharedAccountList[m_nSharedAccountListFoot].m_sAccountName
        m_tableSharedElectric.bounces = false
        m_tableSharedElectric.tableFooterView = UIView()
        m_tableSharedElectric.register(SharedElectricCell.self, forCellReuseIdentifier: "sharedElectricCell")
        m_tableSharedElectric.register(UINib(nibName: "SharedElectricCell", bundle: nil), forCellReuseIdentifier: "sharedElectricCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnSave(_ sender: AnyObject) {
        var sBuffer:String! = ""
        for i in 0..<gDC.mSharedElectricList.count {
            sBuffer = sBuffer + "\(gDC.mSharedElectricList[i].m_sAccountCode)|\(gDC.mSharedElectricList[i].m_sMasterCode)|\(gDC.mSharedElectricList[i].m_nElectricIndex)|\(gDC.mSharedElectricList[i].m_nIsShared);"
        }
        print(sBuffer)
        let utf8str = sBuffer.data(using: String.Encoding.utf8)
        if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) {
            let webReturn:String = MyWebService.sharedInstance.AdminSharedElectric(base64Encoded)
            WebAdminSharedElectric(webReturn)
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gDC.mSharedElectricList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharedElectricCell", for: indexPath) as! SharedElectricCell
        let type:Int = gDC.mSharedElectricList[indexPath.row].m_nElectricType
        cell.m_imageElectric.image = UIImage(named: gDC.m_arrayElectricImage[type] as! String)
        cell.m_labelElectricName.text = gDC.mSharedElectricList[indexPath.row].m_sElectricName
        let nAreaIndex = gDC.mSharedElectricList[indexPath.row].m_nRoomIndex
        //这里出现了问题，不能将这里的areaIndex关联到当前areaList
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_nAreaIndex == nAreaIndex {
                cell.m_labelAreaName.text = gDC.mAreaList[i].m_sAreaName
            }
        }
        if gDC.mSharedElectricList[indexPath.row].m_nIsShared == 0 {
            cell.m_switch.isOn = false
        }else {
            cell.m_switch.isOn = true
        }
        cell.m_nElectricListFoot = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebAdminSharedElectric(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "0":
            ShowNoticeDispatch("提示", content: "不能执行该操作", duration: 0.8)
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
//            gDC.mElectricData.UpdateSharedElectricInfo()
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////
    func didSwitchChange(_ bSwitchOn: Bool, foot:Int) {
        if bSwitchOn {
            gDC.mSharedElectricList[foot].m_nIsShared = 1
        }else {
            gDC.mSharedElectricList[foot].m_nIsShared = 0
        }
    }
    
}





