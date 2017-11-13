//
//  AreaViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/3.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class AreaViewCtrl: UIViewController {
    
    @IBOutlet weak var m_barbtnAdd: UIBarButtonItem!
    var m_vcAreas = [SelectedAreaViewCtrl]()
    var skscNavVC:SKScNavViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitAreaViews()
        g_notiCenter.addObserver(self, selector:#selector(AreaViewCtrl.RefreshAreas),name: NSNotification.Name(rawValue: "RefreshAreas"), object: nil)
        g_notiCenter.addObserver(self, selector:#selector(AreaViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
        g_notiCenter.addObserver(self, selector:#selector(AreaViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
        
    }

    deinit {
        g_notiCenter.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        if gDC.m_bRefreshAreaList == true {
            InitAreaViews()
        }
    }
    
    @IBAction func OnAdd(_ sender: UIBarButtonItem) {
        print("切换到添加房间视图")
        if gDC.mUserInfo.m_nIsAdmin == 0 {
            ShowNoticeDispatch("提示", content: "权限不足", duration: 0.5)
            return
        }
        //self.performSegueWithIdentifier("addArea", sender: self)
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "addAreaViewCtrl") as! AddAreaViewCtrl
        self.navigationController?.pushViewController(nextView, animated: true)
    }

    //按照房间的sequ从小到大的顺序排序
    func OnSort(_ vc1:SelectedAreaViewCtrl, vc2:SelectedAreaViewCtrl) -> Bool{
        return vc2.m_nSequ > vc1.m_nSequ
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func InitAreaViews() {
        for vc in m_vcAreas {
            vc.willMove(toParentViewController: nil)
            vc.removeFromParentViewController()
            vc.view.removeFromSuperview()
        }
        m_vcAreas.removeAll()
        m_vcAreas = [SelectedAreaViewCtrl]()
        for i in 0..<gDC.mAreaList.count {
            let vc = SelectedAreaViewCtrl()
            vc.title = gDC.mAreaList[i].m_sAreaName
            vc.m_sName = gDC.mAreaList[i].m_sAreaName
            vc.m_nSequ = gDC.mAreaList[i].m_nAreaSequ
            vc.m_nAreaListFoot = i
            if gDC.m_bRefreshAreaList == true {
                vc.m_bRefreshView = true
            }
            m_vcAreas.append(vc)
        }
        gDC.m_bRefreshAreaList = false
        //按照sequ的顺序排列
        m_vcAreas.sort(by: OnSort)
        if skscNavVC==nil {
            //则不用判断subViewControllers的数量
        }else if skscNavVC.subViewControllers.count>0 {
            skscNavVC.willMove(toParentViewController: nil)
            skscNavVC.removeFromParentViewController()
        }
        skscNavVC = SKScNavViewController(subViewControllers: m_vcAreas as NSArray)
        skscNavVC.lineColor = UIColor(red: 139/255, green: 39/255, blue: 114/255, alpha: 1)
        skscNavVC.scNavBarColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        skscNavVC.scNavBarArrowImage = UIImage(named: "导航栏_下拉.png")
        skscNavVC.addParentController(self)
        if (gDC.m_nSelectAreaSequ >= gDC.mAreaList.count) {
            gDC.m_nSelectAreaSequ = gDC.mAreaList.count - 1
        }
        skscNavVC.mainView.setContentOffset(CGPoint(x: CGFloat(gDC.m_nSelectAreaSequ) * kScreenWidth, y: 0), animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func RefreshAreas() {
        InitAreaViews()
        RefreshElectricStates()
    }
    
    func RefreshElectricStates() {
        for vc in m_vcAreas {
            vc.m_collectionElectric.reloadData()
        }
    }
    
    func SyncData() {
        InitAreaViews()
    }
    
}
