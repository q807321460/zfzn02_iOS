//
//  SettingViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/3/23.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SettingViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_tableSetting: UITableView!
    @IBOutlet weak var m_btnQuit: UIButton!
    var m_viewSearching:SCLAlertView! = nil
    var m_appear = SCLAlertView.SCLAppearance(showCloseButton: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_tableSetting.bounces = false
        m_tableSetting.tableFooterView = UIView()
        m_btnQuit.layer.masksToBounds = true
        m_btnQuit.layer.cornerRadius = 5.0
        //为了方便起见，这里使用了账户列表中使用的单元格格式
        m_tableSetting.register(MyAccountInfoCell.self, forCellReuseIdentifier: "myAccountInfoCell")
        let nib = UINib(nibName: "MyAccountInfoCell", bundle: nil)
        m_tableSetting.register(nib, forCellReuseIdentifier: "myAccountInfoCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func OnBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {
            print("从设置界面返回到侧边栏界面")
        })
    }
    
    @IBAction func OnQuitLogin(_ sender: AnyObject) {
        //需要在这里重置一些参数
//        MyWebService.sharedInstance.StopPolling()
        WebSocket.sharedInstance.CloseWebSocket()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyAccountInfoCell = tableView.dequeueReusableCell(withIdentifier: "myAccountInfoCell", for: indexPath) as! MyAccountInfoCell
        switch indexPath.row {
//        case 0:
//            cell.m_sTitle.text = "切换城市"
//            cell.m_sContent.text = ""
//        case 1:
//            cell.m_sTitle.text = "检测更新"
//            cell.m_sContent.text = ""
        default:
            cell.m_sTitle.text = ""
            cell.m_sContent.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
//        case 0:
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let nextView = sb.instantiateViewController(withIdentifier: "switchCityViewCtrl") as! SwitchCityViewCtrl
//            self.navigationController?.pushViewController(nextView, animated: true)
//        case 1:
//            DispatchQueue.main.async(execute: {
//                self.m_viewSearching = SCLAlertView(appearance: self.m_appear)
//                self.m_viewSearching.showInfo("提示", subTitle: " 正在加载中......", duration: 0)
//            })
//            let sPath:String = "http://itunes.apple.com/cn/lookup?id=1193584108"
//            let url = URL(string: sPath)
//            let request = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
//            request.httpMethod = "POST"
//            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue()) { (response, data, error) in
//                let receiveStatusDic = NSMutableDictionary()
//                if data != nil {
//                    do {
//                        let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                         if let resultCount = dic["resultCount"] as? NSNumber {
//                            if resultCount.intValue > 0 {
//                                receiveStatusDic.setValue("1", forKey: "status")
//                                if let arr = dic["results"] as? NSArray {
//                                    if let dict = arr.firstObject as? NSDictionary {
//                                        if let version = dict["version"] as? String {
//                                            receiveStatusDic.setValue(version, forKey: "version")
//                                            UserDefaults.standard.set(version, forKey: "Version")
//                                            UserDefaults.standard.synchronize()
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }catch let error {
//                        print("checkUpdate -------- \(error)")
//                        receiveStatusDic.setValue("0", forKey: "status")
//                    }
//                }else {
//                    receiveStatusDic.setValue("0", forKey: "status")
//                }
//                self.performSelector(onMainThread: #selector(SettingViewCtrl.checkUpdateWithData(_:)), with: receiveStatusDic, waitUntilDone: false)
//            }
        default:
            print("无效的选项")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /////////////////////////////////////////////////////////////////////////////
//    @objc fileprivate func checkUpdateWithData(_ data: NSDictionary) {
//        let status = data["status"] as? String
//        let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//        if status == "1" {
//            let storeVersion = data["version"] as! String
//            self.compareVersion(localVersion, storeVersion: storeVersion)
//            self.m_viewSearching.hideView()
//            return
//        }
//        if let storeVersion = UserDefaults.standard.object(forKey: "Version") as? String {
//            self.compareVersion(localVersion, storeVersion: storeVersion)
//            self.m_viewSearching.hideView()
//        }
//    }
//    
//    fileprivate func compareVersion(_ localVersion: String, storeVersion: String) {
//        if localVersion.compare(storeVersion) == ComparisonResult.orderedAscending {
//            print("需要更新")
//            DispatchQueue.main.async(execute: {
//                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
//                let alertView = SCLAlertView(appearance: appearance)
//                alertView.addButton("前往AppStore", action: {() ->Void in
//                    let urlString = "itms-apps://itunes.apple.com/app/id1193584108"
//                    let url = URL(string: urlString)
//                    UIApplication.shared.openURL(url!)
//                })
//                let sInfo:String = "当前的版本号为\(localVersion)，最新的版本号为\(storeVersion)，是否选择更新？"
//                alertView.showInfo("提示", subTitle: sInfo, duration: 0)//时间间隔为0时不会自动退出
//            })
//        }else {
//            ShowInfoDispatch("提示", content: "已经是最新的版本了", duration: 1.0)
//        }
//    }
    
}










