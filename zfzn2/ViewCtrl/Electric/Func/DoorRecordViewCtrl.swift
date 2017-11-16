//
//  DoorRecordViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/10/18.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class DoorRecordViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_tableRecord: UITableView!
    var m_sElectricCode:String = ""
    var m_arrayOpenTime:NSArray!
    var m_nRecordCount:Int = 0
    var m_arrayJSON:[JSON] = []
    @IBOutlet weak var m_labelEmpty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        m_tableRecord.bounces = false//这里需要弹簧效果，因为需要实现下拉刷新的功能
        m_tableRecord.tableFooterView = UIView()//隐藏多余行
        self.automaticallyAdjustsScrollViewInsets = false//保证顶部不留白
        m_tableRecord.register(DoorRecordCell.self, forCellReuseIdentifier: "doorRecordCell")
        m_tableRecord.register(UINib(nibName: "DoorRecordCell", bundle: nil), forCellReuseIdentifier: "doorRecordCell")
        // 添加头部的下拉刷新
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(headerClick))
        m_tableRecord.mj_header = header
        LoadDoorRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func LoadDoorRecord() {
        if (m_arrayJSON.count != 0) {
            m_arrayJSON.removeAll()
        }
        m_arrayJSON = MyWebService.sharedInstance.LoadDoorRecord(masterCode: gDC.mUserInfo.m_sMasterCode, electricCode: m_sElectricCode)
        //下面处理获取到的json字符串
        m_nRecordCount = m_arrayJSON.count
        if (m_nRecordCount == 0) {
            m_tableRecord.isHidden = true
            m_labelEmpty.isHidden = false
        }else {
            m_tableRecord.isHidden = false
            m_labelEmpty.isHidden = true
            m_tableRecord.reloadData()
        }
    }
    
    // 头部的下拉刷新触发事件
    func headerClick () {
        print("下拉刷新")
        DispatchQueue.main.async {
            self.LoadDoorRecord()
            self.m_tableRecord.mj_header.endRefreshing()
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_nRecordCount
    }
    
    //每行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = m_nRecordCount - indexPath.row - 1//实现由近到远的显示顺序
        let cell = tableView.dequeueReusableCell(withIdentifier: "doorRecordCell", for: indexPath) as! DoorRecordCell
        cell.m_labelOpenTime.text = m_arrayJSON[row]["openTime"].string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
