//
//  AddSceneViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/3.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class AddSceneViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_eSceneName: UITextField!
    @IBOutlet weak var m_btnDown: UIButton!
    @IBOutlet weak var m_btnImage: UIButton!
    @IBOutlet weak var m_tableView: UITableView!
    
    var m_nMaxIndex:Int! = 0
    var m_nImageIndex:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_btnDown.layer.cornerRadius = 5.0
        m_btnDown.layer.masksToBounds = true
        m_tableView.register(AddSceneCell.self, forCellReuseIdentifier: "addSceneCell")
        m_tableView.register(UINib(nibName: "AddSceneCell", bundle: nil), forCellReuseIdentifier: "addSceneCell")
        m_tableView.tableFooterView = UIView()
        m_tableView.bounces = false
        m_tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        m_tableView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnSelectImage(_ sender: Any) {
        if m_tableView.isHidden == true {
            m_tableView.isHidden = false
        }else {
            m_tableView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if gDC.m_bQuickScene == true {//快捷跳转时，需要将当前的情景pop出来，进入根界面并重新跳转
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func OnDown(_ sender: AnyObject) {
        if m_tableView.isHidden == false {
            m_tableView.isHidden = true
            return
        }
        if m_eSceneName.text == "" {
            ShowNoticeDispatch("提示", content: "请输入情景名", duration: 0.8)
            return
        }
        for i in 0..<gDC.mSceneList.count {
            if gDC.mSceneList[i].m_sSceneName == m_eSceneName.text {
                ShowNoticeDispatch("提示", content: "与已有的情景有重名，请重新输入", duration: 1.0)
                return
            }
        }
        //计算情景index值
        for i in 0..<gDC.mSceneList.count {
            if gDC.mSceneList[i].m_nSceneIndex > m_nMaxIndex {
                m_nMaxIndex = gDC.mSceneList[i].m_nSceneIndex
            }
        }
        m_nMaxIndex = m_nMaxIndex + 1
        //向服务器添加新的情景
        let webReturn = MyWebService.sharedInstance.AddScene(gDC.mAccountInfo.m_sAccountCode, masterCode:gDC.mUserInfo.m_sMasterCode, sceneName:m_eSceneName.text!, sceneIndex:m_nMaxIndex, sceneSequ:gDC.mSceneList.count, sceneImg:m_nImageIndex)
        WebAddScene(webReturn)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func WebAddScene(_ responseValue:String){
        switch responseValue{
        case "WebError":
            //错误的提示已经在WS类中处理过了
            break
        case "-2":
            ShowNoticeDispatch("错误", content: "未知的失败", duration: 0.5)
        case "1":
            ShowInfoDispatch("提示", content: "添加成功", duration: 0.5)
            gDC.mSceneData.AddScene(m_eSceneName.text!, sceneIndex:m_nMaxIndex, sceneSequ:gDC.mSceneList.count, sceneImageIndex:m_nImageIndex)
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AddSceneCell = tableView.dequeueReusableCell(withIdentifier: "addSceneCell", for: indexPath) as! AddSceneCell
        switch indexPath.row {
        case 0:
            cell.m_imageView.image = UIImage(named: "情景_回家")
        case 1:
            cell.m_imageView.image = UIImage(named: "情景_离家")
        case 2:
            cell.m_imageView.image = UIImage(named: "情景_起床")
        case 3:
            cell.m_imageView.image = UIImage(named: "情景_睡觉")
        case 4:
            cell.m_imageView.image = UIImage(named: "情景_自定义")
        default:
            cell.m_imageView.image = UIImage(named: "情景_自定义")//暂定
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        m_tableView.isHidden = true
        switch indexPath.row {
        case 0:
            m_nImageIndex = 0
            m_btnImage.setBackgroundImage(UIImage(named: "情景_回家"), for: .normal)
        case 1:
            m_nImageIndex = 1
            m_btnImage.setBackgroundImage(UIImage(named: "情景_离家"), for: .normal)
        case 2:
            m_nImageIndex = 2
            m_btnImage.setBackgroundImage(UIImage(named: "情景_起床"), for: .normal)
        case 3:
            m_nImageIndex = 3
            m_btnImage.setBackgroundImage(UIImage(named: "情景_睡觉"), for: .normal)
        case 4:
            m_nImageIndex = 4
            m_btnImage.setBackgroundImage(UIImage(named: "情景_自定义"), for: .normal)
        default:
            m_nImageIndex = 4
            m_btnImage.setBackgroundImage(UIImage(named: "情景_自定义"), for: .normal)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


