//
//  AlarmRecordViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/10/31.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class AlarmRecordViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var m_tableRecord: UITableView!
    let m_sNibName:String = "AlarmRecordCell"
    let m_sReuseIdentifier:String = "alarmRecordCell"
    var m_nRecordCount:Int = 0
    var m_arrayJSON:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)//将之前的隐藏的导航栏显示出来
        m_tableRecord.tableFooterView = UIView()//隐藏多余行
        self.automaticallyAdjustsScrollViewInsets = false//保证顶部不留白
        m_tableRecord.register(AlarmRecordCell.self, forCellReuseIdentifier: m_sReuseIdentifier)
        m_tableRecord.register(UINib(nibName: m_sNibName, bundle: nil), forCellReuseIdentifier: m_sReuseIdentifier)
        // 添加头部的下拉刷新
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(headerClick))
        m_tableRecord.mj_header = header
        LoadAlarmRecord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func LoadAlarmRecord() {
        if (m_arrayJSON.count != 0) {
            m_arrayJSON.removeAll()
        }
        m_arrayJSON = MyWebService.sharedInstance.LoadAlarmRecord(masterCode: gDC.mUserInfo.m_sMasterCode)
        //下面处理获取到的json字符串
        m_nRecordCount = m_arrayJSON.count
        m_tableRecord.reloadData()
    }
    
    // 头部的下拉刷新触发事件
    func headerClick () {
        print("下拉刷新")
        LoadAlarmRecord()
        // 结束刷新
        m_tableRecord.mj_header.endRefreshing()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_nRecordCount
    }
    
    //每行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = m_nRecordCount - indexPath.row - 1//实现由近到远的显示顺序
        let cell = tableView.dequeueReusableCell(withIdentifier: m_sReuseIdentifier, for: indexPath) as! AlarmRecordCell
        let nType:Int = m_arrayJSON[row]["electricType"].int!
        cell.m_imageElectric.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)//.init(named: gDC.m_arrayElectricImage[nType])
        cell.m_labelElectricName.text = m_arrayJSON[row]["electricName"].string!
        cell.m_labelRoomName.text = "房间：" + m_arrayJSON[row]["roomName"].string!
        cell.m_labelAlarmTime.text = "报警时间：" + m_arrayJSON[row]["alarmTime"].string!
        let sInfo = (m_arrayJSON[row]["stateInfo"].string! as NSString).substring(with: NSMakeRange(0, 2))
        cell.m_labelStateInfo.text = "报警状态：" + (gDC.m_arraySensorState[sInfo] as? String)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
