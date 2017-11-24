//
//  SharedAccountViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/4/5.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SharedAccountViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource, SharedAccountInfoCellDelegate {

    @IBOutlet weak var m_imageAccount: UIImageView!
    @IBOutlet weak var m_tableAccountInfo: UITableView!
    @IBOutlet weak var m_btnDeleteSharedUser: UIButton!
    var m_nUserListFoot:Int!
    var m_sMasterCode:String! = ""
    var m_nSharedAccountListFoot:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_imageAccount.image = gDC.mSharedAccountList[m_nSharedAccountListFoot].m_imageAccountHead
        let height = m_imageAccount.layer.bounds.height
        m_imageAccount.layer.cornerRadius = height/2
        m_imageAccount.layer.masksToBounds = true
        m_btnDeleteSharedUser.layer.masksToBounds = true
        m_btnDeleteSharedUser.layer.cornerRadius = 5.0
        m_tableAccountInfo.tableFooterView = UIView()
        m_tableAccountInfo.bounces = false
        m_tableAccountInfo.register(SharedAccountInfoCell.self, forCellReuseIdentifier: "sharedAccountInfoCell")
        m_tableAccountInfo.register(UINib(nibName: "SharedAccountInfoCell", bundle: nil), forCellReuseIdentifier: "sharedAccountInfoCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnDeleteSharedUser(_ sender: Any) {
        let re = MyWebService.sharedInstance.DeleteSharedUser(masterCode: gDC.mUserInfo.m_sMasterCode, accountCode: gDC.mSharedAccountList[m_nSharedAccountListFoot].m_sAccountCode)
        WebDeleteSharedUser(re)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func WebDeleteSharedUser(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "-2":
            print("取消分享失败")
            ShowNoticeDispatch("错误", content: "未知的失败", duration: 0.5)
        case "1":
            print("取消分享成功")
            ShowInfoDispatch("提示", content: "取消分享成功", duration: 0.5)
            gDC.mSharedAccountList.remove(at: m_nSharedAccountListFoot)
            gDC.mSharedElectricList.removeAll()
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
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharedAccountInfoCell", for: indexPath) as! SharedAccountInfoCell
        switch indexPath.row {
        case 0:
            cell.m_labelTitle.text = "姓名"
            cell.m_sContent.text = gDC.mSharedAccountList[m_nSharedAccountListFoot].m_sAccountName
        case 1:
            cell.m_labelTitle.text = "手机"
            cell.m_sContent.text = gDC.mSharedAccountList[m_nSharedAccountListFoot].m_sAccountCode
        case 2:
            cell.m_labelTitle.text = "地址"
            cell.m_sContent.text = gDC.mSharedAccountList[m_nSharedAccountListFoot].m_sAccountAddress
        case 3:
            cell.m_labelTitle.text = "邮箱"
            cell.m_sContent.text = gDC.mSharedAccountList[m_nSharedAccountListFoot].m_sAccountEmail
        case 4:
            cell.m_labelTitle.text = "电器"
            cell.m_sContent.text = ""
            cell.m_imageNavi.isHidden = false
        default:
            break
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 4:
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let nextView = sb.instantiateViewController(withIdentifier: "sharedElecListViewCtrl") as! SharedElecListViewCtrl
            nextView.m_nSharedAccountListFoot = self.m_nSharedAccountListFoot
            self.navigationController?.pushViewController(nextView , animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func didSwitchChange(_ bSwitchOn: Bool) {
//        ShowInfoDispatch("提示", content: "该功能尚未完善，敬请期待~", duration: 1.0)
    }
}




