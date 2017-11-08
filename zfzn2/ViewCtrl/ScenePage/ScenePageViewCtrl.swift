//
//  ScenePageViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/3.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ScenePageViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_imageScene: UIImageView!
    @IBOutlet weak var m_labelSceneName: UILabel!
    @IBOutlet weak var m_tableSceneElectric: UITableView!
    @IBOutlet weak var m_btnExecute: UIButton!
    var m_nSceneListFoot:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)//将之前的隐藏的导航栏显示出来
//        self.navigationItem.title = gDC.mSceneList[m_nSceneListFoot].m_sSceneName
        m_imageScene.image = gDC.mSceneList[m_nSceneListFoot].m_imageScene
        m_labelSceneName.text = gDC.mSceneList[m_nSceneListFoot].m_sSceneName
        m_tableSceneElectric.register(MySceneElectricCell.self, forCellReuseIdentifier: "mySceneElectricCell")
        m_tableSceneElectric.register(UINib(nibName: "MySceneElectricCell", bundle: nil), forCellReuseIdentifier: "mySceneElectricCell")
        m_tableSceneElectric.tableFooterView = UIView()
        m_tableSceneElectric.bounces = false
        m_btnExecute.layer.cornerRadius = 5.0
        m_btnExecute.layer.masksToBounds = true
        g_notiCenter.addObserver(self, selector:#selector(AddSceneElectricViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        m_tableSceneElectric.reloadData()
        if gDC.m_bQuickScene == true {//快捷跳转时，需要将当前的情景pop出来，进入根界面并重新跳转
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnEdit(_ sender: AnyObject) {
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "editSceneViewCtrl") as! EditSceneViewCtrl
        nextView.m_nSceneListFoot = self.m_nSceneListFoot
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func OnExcute(_ sender: AnyObject) {
//        MySocket.sharedInstance.CheckLocalConnection()
        if gDC.m_bRemote == false {//本地socket控制
            //现在需要一条指令来控制
            MySocket.sharedInstance.OperateElectric("<********TH**\(gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex)*******00>")
        }else {
            //接口是有，但是无法控制
            MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode: "********", order: "TH", orderInfo: "**\(gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex)*******")
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gDC.mSceneList[m_nSceneListFoot].mSceneElectricList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mySceneElectricCell", for: indexPath) as! MySceneElectricCell
        //根据电器类型设置左侧图片
        let nType:Int = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_nElectricType
        cell.m_imageSceneElectric.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)
        if nType == 0 || nType==1 || nType==2 || nType==3 || nType==4 {
            let sElectricOrder:String! = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_sElectricOrder
            if sElectricOrder == "XG" || sElectricOrder == "SG"{
                cell.m_labelDescription.text = "关"
            }else {//否则只有可能是XH和SH
                cell.m_labelDescription.text = "开"
            }
        }else {
            cell.m_labelDescription.text = ""
        }
        //根据电器其他属性设置对应label
        cell.m_labelElectricName.text = gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_sElectricName
        for i in 0..<gDC.mAreaList.count {
            if gDC.mSceneList[m_nSceneListFoot].mSceneElectricList[indexPath.row].m_nRoomIndex == gDC.mAreaList[i].m_nAreaIndex {
                cell.m_labelAreaName.text = gDC.mAreaList[i].m_sAreaName
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //这里不需要做出任何响应
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func SyncData() {
        m_tableSceneElectric.reloadData()
    }
}




