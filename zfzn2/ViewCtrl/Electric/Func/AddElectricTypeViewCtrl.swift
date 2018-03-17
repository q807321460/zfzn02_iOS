//
//  AddElectricTypeViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/20.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//  选择需要添加的电器的种类

import UIKit

class AddElectricTypeViewCtrl: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var m_collectionElectric: UICollectionView!
    var m_nAreaListFoot:Int!
    var m_nAreaIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .vertical
        m_collectionElectric.setCollectionViewLayout(layout, animated: true)
        m_collectionElectric.register(MiniElectric.self, forCellWithReuseIdentifier: "miniElectric")
        m_collectionElectric.register(UINib(nibName: "MiniElectric", bundle: nil), forCellWithReuseIdentifier: "miniElectric")
        g_notiCenter.addObserver(self, selector:#selector(AddElectricViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
//        print("确认是否销毁完全？")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return gDC.m_arrayElectricTypeCode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let widthView = collectionView.frame.width
        let widthCell = (widthView-10)/3
        return CGSize(width: widthCell, height: widthCell*85/80)
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniElectric", for: indexPath) as! MiniElectric
        cell.m_imageElectricType.image = UIImage(named: gDC.m_arrayElectricImage[indexPath.row] as! String)
        cell.m_labelElectricType.text = gDC.m_arrayElectricLabel[indexPath.row] as? String
        return cell
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.row != 8 && gDC.m_bRemote == true {
            ShowNoticeDispatch("提示", content: "远程状态下不允许添加该类型电器", duration: 1.0)
            return
        }
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "addElectricViewCtrl") as! AddElectricViewCtrl
        nextView.m_nAreaListFoot = self.m_nAreaListFoot
        nextView.m_nAreaIndex = self.m_nAreaIndex
        switch indexPath.row {
        case 0:
            print("添加插座")
            nextView.m_nElectricType = 0
            self.navigationController?.pushViewController(nextView, animated: true)
        case 1:
            print("添加一键开关")
            nextView.m_nElectricType = 1
            self.navigationController?.pushViewController(nextView, animated: true)
        case 2:
            print("添加两键开关")
            nextView.m_nElectricType = 2
            self.navigationController?.pushViewController(nextView, animated: true)
        case 3:
            print("添加三键开关")
            nextView.m_nElectricType = 3
            self.navigationController?.pushViewController(nextView, animated: true)
        case 4:
            print("添加四键开关")
            nextView.m_nElectricType = 4
            self.navigationController?.pushViewController(nextView, animated: true)
        case 5:
            print("添加门锁")
            nextView.m_nElectricType = 5
            self.navigationController?.pushViewController(nextView, animated: true)
        case 6:
            print("添加窗帘")
            nextView.m_nElectricType = 6
            self.navigationController?.pushViewController(nextView, animated: true)
        case 7:
            print("添加窗户")
            nextView.m_nElectricType = 7
            self.navigationController?.pushViewController(nextView, animated: true)
        case 8:
            print("添加摄像头")
            //首先判断是否和乐橙绑定了手机号，这里使用的是自己的token
            GetLechageTokenGlobal(gDC.mAccountInfo.m_sAccountCode, isShowLoading: true)
            let sFlag:String = (gDC.m_sCameraToken as NSString).substring(with: NSMakeRange(0, 2))
            if sFlag == "Ut" {
                print("该用户已经绑定了乐橙的账号，可以直接进入添加界面")
                let nextView = mainStory.instantiateViewController(withIdentifier: "addDeviceViewController") as! AddDeviceViewController
                nextView.setInfo(nil, token: gDC.m_sCameraToken, areaFoot: self.m_nAreaListFoot)
                self.navigationController?.pushViewController(nextView, animated: true)
            }else {
                print("error message: \(gDC.m_sCameraToken)")
                let nextView = mainStory.instantiateViewController(withIdentifier: "userBindModeViewController") as! UserBindModeViewController
                self.navigationController?.pushViewController(nextView, animated: true)
            }
        case 9:
            print("添加空调")
            ShowInfoDispatch("提示", content: "暂不支持该电器", duration: 0.5)
        case 10:
            print("添加情景开关")
            nextView.m_nElectricType = 10
            self.navigationController?.pushViewController(nextView, animated: true)
        case 11:
            print("添加机械手")
            nextView.m_nElectricType = 11
            self.navigationController?.pushViewController(nextView, animated: true)
        case 12:
            print("添加电视")
            ShowInfoDispatch("提示", content: "暂不支持该电器", duration: 0.5)
        case 13:
            print("添加温度计")
            nextView.m_nElectricType = 13
            self.navigationController?.pushViewController(nextView, animated: true)
        case 14:
            print("添加水浸")
            nextView.m_nElectricType = 14
            self.navigationController?.pushViewController(nextView, animated: true)
        case 15:
            print("添加门磁")
            nextView.m_nElectricType = 15
            self.navigationController?.pushViewController(nextView, animated: true)
        case 16:
            print("添加燃气")
            nextView.m_nElectricType = 16
            self.navigationController?.pushViewController(nextView, animated: true)
        case 17:
            print("添加壁挂红外")
            nextView.m_nElectricType = 17
            self.navigationController?.pushViewController(nextView, animated: true)
        case 18:
            print("添加警号")
            nextView.m_nElectricType = 18
            self.navigationController?.pushViewController(nextView, animated: true)
        case 19:
            print("添加烟雾")
            nextView.m_nElectricType = 19
            self.navigationController?.pushViewController(nextView, animated: true)
        case 20:
            print("添加晾衣架")
            nextView.m_nElectricType = 20
            self.navigationController?.pushViewController(nextView, animated: true)
        case 21:
            ShowInfoDispatch("提示", content: "暂不支持该电器", duration: 0.5)
//            print("添加学习型空调")
//            nextView.m_nElectricType = 21
//            self.navigationController?.pushViewController(nextView, animated: true)
        case 22:
            ShowInfoDispatch("提示", content: "暂不支持该电器", duration: 0.5)
//            print("添加中央空调")
//            nextView.m_nElectricType = 22
//            self.navigationController?.pushViewController(nextView, animated: true)
        case 23:
            print("添加新门锁")
            nextView.m_nElectricType = 23
            self.navigationController?.pushViewController(nextView, animated: true)
       case 25:
            print("添加中央空调")
            nextView.m_nElectricType = 25
            self.navigationController?.pushViewController(nextView, animated: true)
        default:
            break
        }
    }
    
    // 允许cell点击变色
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //cell点击变色
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = gDC.m_colorTouching
    }
    
    //允许cell重置背景色
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //cell重置背景色
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
    
    // 离开时cell重置背景色
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
    
    func SyncData() {
        DispatchQueue.main.async {
            //可能会数组越界，还需要判断当前的房间是否已经不存在了（被其他app删除）
            if (self.m_nAreaListFoot >= gDC.mAreaList.count || gDC.mAreaList[self.m_nAreaListFoot].m_nAreaIndex != self.m_nAreaIndex) {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
        }
    }
    
}



