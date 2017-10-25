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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        m_tableShareList.bounces = false
        m_tableShareList.tableFooterView = UIView()
        m_tableShareList.register(MySharedAccountCell.self, forCellReuseIdentifier: "mySharedAccountCell")
        m_tableShareList.register(UINib(nibName: "MySharedAccountCell", bundle: nil), forCellReuseIdentifier: "mySharedAccountCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
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
        self.navigationController?.pushViewController(nextView , animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}







