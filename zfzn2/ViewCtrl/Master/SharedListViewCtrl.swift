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
//        g_notiCenter.addObserver(self, selector:#selector(SharedListViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
//    func SyncData() {
//        DispatchQueue.main.async {
//            //可能会数组越界，还需要判断当前的主机是否已经不存在了（被其他app删除）
//            if (self.m_nUserListFoot >= gDC.mUserList.count || gDC.mUserList[self.m_nUserListFoot].m_sMasterCode != self.m_sMasterCode) {
//                self.navigationController?.popToRootViewController(animated: true)
//                return
//            }
//            //加载分享账户列表
//            let dictsSharedAccount = MyWebService.sharedInstance.LoadSharedAccount(gDC.mUserList[self.m_nUserListFoot].m_sMasterCode)
//            gDC.mAccountData.UpdateSharedAccount(dictsSharedAccount)
//            self.m_tableShareList.reloadData()
//        }
//    }
}







