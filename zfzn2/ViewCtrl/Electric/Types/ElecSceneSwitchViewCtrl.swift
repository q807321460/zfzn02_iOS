//
//  ElecSceneSwitchViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/3/28.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecSceneSwitchViewCtrl: ElecSuperViewCtrl {//, UITableViewDelegate, UITableViewDataSource

    @IBOutlet weak var m_imageElectric: UIImageView!
    
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_btnExcute: UIButton!
    @IBOutlet weak var m_labelScene: UILabel!
    @IBOutlet weak var m_imageScene: UIImageView!
    @IBOutlet weak var m_labelSceneName: UILabel!
    
    var m_nSceneSelectedIndex:Int! = -1//当前情景开关绑定的情景index
    var m_timer:Timer!
    var m_nSceneElectricListFoot:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_nSceneSelectedIndex = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nSceneIndex
        if m_nSceneSelectedIndex != -1 {
            for i in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[i].m_nSceneIndex == m_nSceneSelectedIndex {//m_nSceneSelectedIndex如果是-1的话，则默认值调整为0
                    m_imageScene.image = gDC.mSceneList[i].m_imageScene
                    m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
                    break
                }
            }
        }
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_btnExcute.layer.cornerRadius = 5//实现按钮左右两侧完整的圆角
        m_btnExcute.layer.masksToBounds = true//允许圆角

        RefreshState()//主要用于更新图片和按钮的状态
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_nSceneSelectedIndex = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nSceneIndex
        if m_nSceneSelectedIndex != -1 {
            for i in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[i].m_nSceneIndex == m_nSceneSelectedIndex {//m_nSceneSelectedIndex如果是-1的话，则默认值调整为0
                    m_imageScene.image = gDC.mSceneList[i].m_imageScene
                    m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
                    break
                }
            }
        }
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnEdit(_ sender: Any) {
        EditElec()
    }
    
    @IBAction func OnExcute(_ sender: AnyObject) {
        if m_nSceneSelectedIndex == -1 {
            ShowNoticeDispatch("提示", content: "您需要先编辑绑定的情景", duration: 1.0)
            return
        }
        if gDC.m_bRemote == false {//本地socket控制
            //现在需要一条指令来控制
            MySocket.sharedInstance.OperateElectric("<********TH**\(m_nSceneSelectedIndex)*******00>")
        }else {
            //接口是有，但是无法控制
            MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode: "********", order: "TH", orderInfo: "**\(m_nSceneSelectedIndex)*******")
        }
    }

    func RefreshState() {
        if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "01" {
            m_imageElectric.image = UIImage(named: "电器_四键开关_左上关")
        }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "02" {
            m_imageElectric.image = UIImage(named: "电器_四键开关_右上关")
        }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "03" {
            m_imageElectric.image = UIImage(named: "电器_四键开关_左下关")
        }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "04" {
            m_imageElectric.image = UIImage(named: "电器_四键开关_右下关")
        }
    }

}
