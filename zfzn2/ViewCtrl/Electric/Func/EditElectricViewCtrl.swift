//
//  EditElectricViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/7/11.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class EditElectricViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_imageElectric: UIImageView!
    @IBOutlet weak var m_eElectricName: UITextField!
    @IBOutlet weak var m_labelBind: UILabel!
    @IBOutlet weak var m_tableSceneSelected: UITableView!
    @IBOutlet weak var m_tableSceneList: UITableView!
//    @IBOutlet weak var m_layoutHeight: NSLayoutConstraint!
    @IBOutlet weak var m_labelDoorState: UILabel!
    @IBOutlet weak var m_switchDoorState: UISwitch!
    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
    var m_nSceneSelectedIndex:Int! = -1//当前情景开关绑定的情景index
    var m_jsonDoor:JSON = JSON.null//用于判断绑定的是哪种触发模式
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //konnn
        g_notiCenter.addObserver(self, selector:#selector(EditElectricViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
        m_eElectricName.text = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_tableSceneSelected.bounces = false
        m_tableSceneList.bounces = false
        m_tableSceneSelected.register(MySceneCell.self, forCellReuseIdentifier: "mySceneCell")
        m_tableSceneList.register(MySceneCell.self, forCellReuseIdentifier: "mySceneCell")
        let nib = UINib(nibName: "MySceneCell", bundle: nil)
        m_tableSceneSelected.register(nib, forCellReuseIdentifier: "mySceneCell")
        m_tableSceneList.register(nib, forCellReuseIdentifier: "mySceneCell")
        let type:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType
        switch type {
        case 15:
            m_imageElectric.image = UIImage(named: "电器类型_传感器_门磁")
            m_labelDoorState.isHidden = false
            m_switchDoorState.isHidden = false
        default:
            m_imageElectric.image = UIImage(named: gDC.m_arrayElectricImage[type] as! String)
            break
        }
        if (type == 10 || (type <= 17 && type >= 13) || type == 19)  {
            m_labelBind.isHidden = false
            m_tableSceneSelected.isHidden = false
            m_tableSceneList.isHidden = true
            if m_nSceneSelectedIndex == -1 {
                m_nSceneSelectedIndex = 0
            }
        }else {
            m_labelBind.isHidden = true
            m_tableSceneSelected.isHidden = true
            m_tableSceneList.isHidden = true
        }
        if type == 15 {//需要有绑定情景切换的功能
            m_switchDoorState.addTarget(self, action: #selector(SwitchDidChange), for: UIControlEvents.valueChanged)
            let sJson:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras
            if sJson == "" {
                m_nSceneSelectedIndex = -1
            }else {
                if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do { m_jsonDoor = try JSON(data: jsonData) }
                    catch { print("json error"); return; }
                    if m_jsonDoor["SH"].string == nil {
                        m_nSceneSelectedIndex = -1
                    }else {
                        m_nSceneSelectedIndex = Int(m_jsonDoor["SH"].string!)
                    }
                }
            }
        }else {
            m_nSceneSelectedIndex = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nSceneIndex
        }
        g_notiCenter.addObserver(self, selector:#selector(EditElectricViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnSave(_ sender: Any) {
        self.view.endEditing(true)
        if m_eElectricName.text == "" {
            ShowNoticeDispatch("提示", content: "请输入有效的新电器名", duration: 0.8)
            return
        }
        //向web发行修改指令，konnn
        if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType == 15 {
            var sElectricOrder:String! = ""
            if m_switchDoorState.isOn == true {
                sElectricOrder = "SH"
            }else {
                sElectricOrder = "SG"
            }
            let webReturn = MyWebService.sharedInstance.UpdateElectric1(gDC.mAreaList[m_nAreaListFoot].m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, electricIndex:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex, electricName:m_eElectricName.text!, sceneIndex:m_nSceneSelectedIndex, electricOrder: sElectricOrder)
            WebUpdateElectric1(webReturn, electricOrder: sElectricOrder)

        }else {
            let webReturn = MyWebService.sharedInstance.UpdateElectric(gDC.mAreaList[m_nAreaListFoot].m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, electricIndex:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex, electricName:m_eElectricName.text!, sceneIndex:m_nSceneSelectedIndex)
            WebUpdateElectric(webReturn)
        }
    }
    
    
    func SwitchDidChange() {
        if m_switchDoorState.isOn == true {
            m_labelDoorState.text = "当前状态：开触发"
            if m_jsonDoor == JSON.null {
                m_nSceneSelectedIndex = -1
            }else {
                if m_jsonDoor["SH"].string == nil {
                    m_nSceneSelectedIndex = -1
                }else {
                    m_nSceneSelectedIndex = Int(m_jsonDoor["SH"].string!)
                }
            }
        }else {
            m_labelDoorState.text = "当前状态：关触发"
            if m_jsonDoor == JSON.null {
                m_nSceneSelectedIndex = -1
            }else {
                if m_jsonDoor["SG"].string == nil {
                    m_nSceneSelectedIndex = -1
                }else {
                    m_nSceneSelectedIndex = Int(m_jsonDoor["SG"].string!)
                }
            }
        }
        m_tableSceneSelected.reloadData()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateElectric(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            //向内存和本地数据库中更新
            gDC.mElectricData.UpdateElectricInfo(gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex, electricName:m_eElectricName.text!, sceneIndex:m_nSceneSelectedIndex)//注意这里的-1将来是需要修改的m_nSceneSelectedIndex
            gDC.m_bRefreshAreaList = true
            self.navigationController?.popViewController(animated: true)
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
    func WebUpdateElectric1(_ responseValue:String, electricOrder:String) {
        switch responseValue {
        case "WebError":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        case "1":
            ShowInfoDispatch("提示", content: "操作成功", duration: 0.5)
            //向内存和本地数据库中更新，名字需要修改之
            gDC.mElectricData.UpdateElectricInfo1(gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex, electricName:m_eElectricName.text!, sceneIndex:m_nSceneSelectedIndex, electricOrder: electricOrder)//注意这里的-1将来是需要修改的m_nSceneSelectedIndex
            gDC.m_bRefreshAreaList = true
            self.navigationController?.popViewController(animated: true)
        case "-2":
            ShowNoticeDispatch("提示", content: "操作失败", duration: 0.5)
        default:
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == m_tableSceneSelected {
            return 1
        }else {
            return gDC.mSceneList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MySceneCell = tableView.dequeueReusableCell(withIdentifier: "mySceneCell", for: indexPath) as! MySceneCell
        if tableView == m_tableSceneSelected {
            for i in 0..<gDC.mSceneList.count {
                cell.m_imageScene.image = nil
                cell.m_labelSceneName.text = "未绑定"
                if gDC.mSceneList[i].m_nSceneIndex == m_nSceneSelectedIndex {//m_nSceneSelectedIndex如果是-1的话，则默认值调整为0
                    cell.m_imageScene.image = gDC.mSceneList[i].m_imageScene
                    cell.m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
                    break
                }
            }
        }else {
            for i in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[i].m_nSceneSequ == indexPath.row {
                    cell.m_imageScene.image = gDC.mSceneList[i].m_imageScene
                    cell.m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
                    break
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == m_tableSceneSelected {
            if m_tableSceneList.isHidden == true {
                m_tableSceneList.isHidden = false
            }else {
                m_tableSceneList.isHidden = true
            }
        }else {
            for i in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[i].m_nSceneSequ == indexPath.row {
                    m_nSceneSelectedIndex = gDC.mSceneList[i].m_nSceneIndex
                    break
                }
            }
            m_tableSceneList.isHidden = true
            m_tableSceneSelected.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func SyncData() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}



