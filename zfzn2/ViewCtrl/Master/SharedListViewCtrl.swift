//
//  SharedListViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/4/4.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SharedListViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_tableShareList: UITableView!
    @IBOutlet weak var m_labelEmpty: UILabel!
    var m_nUserListFoot:Int!
    var m_sMasterCode:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        m_tableShareList.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = false//保证顶部不留白
        m_tableShareList.register(MySharedAccountCell.self, forCellReuseIdentifier: "mySharedAccountCell")
        m_tableShareList.register(UINib(nibName: "MySharedAccountCell", bundle: nil), forCellReuseIdentifier: "mySharedAccountCell")
        // 添加头部的下拉刷新
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(headerClick))
        m_tableShareList.mj_header = header
        RefreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        DispatchQueue.main.async {
            self.RefreshUI()
        }
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    // 头部的下拉刷新触发事件
    func headerClick () {
        print("下拉刷新")
        DispatchQueue.main.async {
            //加载分享账户列表
            let dictsSharedAccount = MyWebService.sharedInstance.LoadSharedAccount(gDC.mUserList[self.m_nUserListFoot].m_sMasterCode)
            gDC.mAccountData.UpdateSharedAccount(dictsSharedAccount)
            self.m_tableShareList.mj_header.endRefreshing()
        }
    }
    
    func RefreshUI() {
        if (gDC.mSharedAccountList.count == 0) {
            m_tableShareList.isHidden = true
            m_labelEmpty.isHidden = false
        }else {
            m_tableShareList.isHidden = false
            m_labelEmpty.isHidden = true
            self.m_tableShareList.reloadData()
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gDC.mSharedAccountList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mySharedAccountCell", for: indexPath) as! MySharedAccountCell
        cell.m_imageAccount.image = gDC.mSharedAccountList[indexPath.row].m_imageAccountHead
        cell.m_labelAccountCode.text = gDC.mSharedAccountList[indexPath.row].m_sAccountCode
        cell.m_labelAccountName.text = gDC.mSharedAccountList[indexPath.row].m_sAccountName
        let height = cell.m_imageAccount.layer.bounds.height
        cell.m_imageAccount.layer.cornerRadius = height/2//实现按钮左右两侧完整的圆角
        cell.m_imageAccount.layer.masksToBounds = true//允许圆角
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "sharedAccountViewCtrl") as! SharedAccountViewCtrl
        nextView.m_nSharedAccountListFoot = indexPath.row
        //加载分享电器列表
        let dictsSharedElectric = MyWebService.sharedInstance.LoadSharedElectric(masterCode: gDC.mUserList[self.m_nUserListFoot].m_sMasterCode, accountCode: gDC.mSharedAccountList[indexPath.row].m_sAccountCode)
        gDC.mElectricData.UpdateSharedElectric(dictsSharedElectric)
        self.navigationController?.pushViewController(nextView , animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}







