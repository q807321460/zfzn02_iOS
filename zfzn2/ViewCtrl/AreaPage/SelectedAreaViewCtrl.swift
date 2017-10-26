//
//  SelectedAreaViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/3.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import Foundation
import UIKit

class SelectedAreaViewCtrl: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var m_sName:String = ""
    var m_nSequ:Int = -1
    var m_width:CGFloat!
    var m_height:CGFloat!
    var m_heightImg:CGFloat!
    var m_imgArea = UIImageView()//这里需要给一个对象，不能为空，否则会出错
    var m_vEditBar = UIView()
    var m_nElectricCount:Int = -1//该房间的电器数
    var m_nAreaListFoot:Int = -1//记录gDC.mAreaList中对应的脚标
    var m_bRefreshView:Bool = false
    var m_bHaveClicked:Bool = false//暂时没用上
    var m_collectionElectric:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_width = self.view.frame.size.width
        m_height = self.view.frame.height
        view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        m_heightImg = m_width * 360 / 720//默认大小应该为395:720
        m_imgArea.frame = CGRect(x: 0,y: 0,width: m_width,height: m_heightImg)
        m_imgArea.image = gDC.mAreaList[m_nAreaListFoot].m_imageArea
        self.view.addSubview(m_imgArea)
        ShowEditBar()//只需要执行一次
        ShowElectric()
        
        m_collectionElectric.register(DeleteElectric.self, forCellWithReuseIdentifier: "DeleteElectric")
        let nib = UINib(nibName: "DeleteElectric", bundle: nil)
        m_collectionElectric.register(nib, forCellWithReuseIdentifier: "DeleteElectric")
    }
    
    deinit {
        print("上一个主机对应的\(m_nAreaListFoot)号房间正在被销毁")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        //编辑完成并返回时刷新界面，但是要注意删除当前房间时，父视图会被清除，这时候是不允许刷新的
        if m_bRefreshView == true {
            if gDC.mAreaList[m_nAreaListFoot].m_imageArea != nil {
                m_imgArea.image = gDC.mAreaList[m_nAreaListFoot].m_imageArea
                self.view.addSubview(m_imgArea)
            }
            ShowEditBar()
            ShowElectric()
//            m_collectionElectric.reloadData()
            m_bRefreshView = false
        }
    }
    
    //手动添加中间的编辑条，宽度暂定为40
    func ShowEditBar() {
        let subTop = m_imgArea.frame.maxY
        let barHeight:CGFloat! = 32.0
        m_vEditBar.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)//也可以使236
        m_vEditBar.frame = CGRect(x: 0,y: subTop,width: m_width,height: barHeight)
        //添加左侧文字“设备”
        let labelDevice = UILabel()
        labelDevice.text = "设备"
        labelDevice.font = UIFont(name: "Times New Roman",size: 14)
        labelDevice.frame = CGRect(x: 15,y: (barHeight-14)/2+1,width: 50,height: 14)
        m_vEditBar.addSubview(labelDevice)
        //添加右侧编辑按钮
        let btnEdit = UIButton()
        btnEdit.setTitle("编辑", for: UIControlState())
        btnEdit.setTitleColor(gDC.m_colorPurple, for: UIControlState())
        let height:CGFloat = 13.0
        let width:CGFloat = 2*height+10
        let left = m_width-width-10//设置右侧剩余15个单位
        btnEdit.titleLabel?.font = UIFont(name: "Times New Roman",size: height)
        btnEdit.frame = CGRect(x: left,y: 1,width: width,height: barHeight)
        btnEdit.addTarget(self, action: #selector(self.OnEdit), for: UIControlEvents.touchDown)//添加单击响应
        if gDC.mUserInfo.m_nIsAdmin == 1 {//没有管理员权限的时候，不需要显示这个按钮
            m_vEditBar.addSubview(btnEdit)
        }
        //添加右侧编辑图标
        let imgEdit = UIImageView()
        imgEdit.image = UIImage(named: "区域_编辑.png")
        imgEdit.frame = CGRect(x: left-15,y: (barHeight-14)/2,width: 14,height: 14)
        if gDC.mUserInfo.m_nIsAdmin == 1 {//没有管理员权限的时候，不需要显示这个按钮
            m_vEditBar.addSubview(imgEdit)
        }
        //将这个视图条添加到主视图中
        self.view.addSubview(m_vEditBar)
    }
    
    func ShowElectric() {
        m_nElectricCount = gDC.mAreaList[m_nAreaListFoot].mElectricList.count
        let top = m_vEditBar.frame.maxY
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .vertical
        //其中状态栏高度为20，主导航栏高度为44，子导航栏高度为40，底部tabbar为49，同时底部保留1点高度
        m_collectionElectric = UICollectionView(frame: CGRect(x: 1,y: top,width: m_width-2,height: m_height-top-20-40-44-49-1), collectionViewLayout: layout)
        m_collectionElectric.backgroundColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1)//主页label使用的颜色
        m_collectionElectric.bounces = false
        //注意，这里的delete的名字是先起的，又因为可以重用，就没有再度改名了
        m_collectionElectric.register(DeleteElectric.self, forCellWithReuseIdentifier: "deleteElectric")
        m_collectionElectric.register(UINib(nibName: "DeleteElectric", bundle: nil), forCellWithReuseIdentifier: "deleteElectric")
        m_collectionElectric.register(AddElectric.self, forCellWithReuseIdentifier: "addElectric")
        m_collectionElectric.register(UINib(nibName: "AddElectric", bundle: nil), forCellWithReuseIdentifier: "addElectric")
        m_collectionElectric.delegate = self
        m_collectionElectric.dataSource = self
        self.view.addSubview(m_collectionElectric)
    }
    
    //点击编辑按钮
    func OnEdit() {
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "editAreaViewCtrl") as! EditAreaViewCtrl
        nextView.m_nAreaListFoot = m_nAreaListFoot
        //这里的情况十分特殊，一定不能用self来push新的编辑视图，否则在删除的时候，就会触发数组越界的bug
        self.parent?.navigationController?.pushViewController(nextView, animated: true)
    }
    
    //点击具体电器按钮
    func OnElectric(_ electricFoot:Int) {
        //实例化一个将要跳转的viewController
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nElectricType = gDC.mAreaList[m_nAreaListFoot].mElectricList[electricFoot].m_nElectricType
        if nElectricType==8 {//摄像头是一大类
            let sPhoneNumber = gDC.mAreaList[m_nAreaListFoot].mElectricList[electricFoot].m_sExtras//该摄像头的拥有者的手机号
            GetLechageTokenGlobal(sPhoneNumber, isShowLoading: true)//获取指定手机号的token
            let sFlag:String = (gDC.m_sCameraToken as NSString).substring(with: NSMakeRange(0, 2))
            if sFlag == "Ut" {//判断token的正确性
                UIDevice.getLechangeCameraList(gDC.mAreaList[m_nAreaListFoot].mElectricList[electricFoot].m_sElectricCode)
                if gDC.mCameraInfo.m_sChannel == "origin" {
                    ShowInfoDispatch("提示", content: "权限不足，无法监控", duration: 1.0)
                }else {
                    let nextView = sb.instantiateViewController(withIdentifier: "liveVideoViewController") as! LiveVideoViewController
                    nextView.setInfo(gDC.m_sCameraToken, dev: gDC.mCameraInfo.m_sID, chn: Int(gDC.mCameraInfo.m_sChannel)!, img: nil, abl: gDC.mCameraInfo.m_sAbility, areaFoot: m_nAreaListFoot, electricFoot: electricFoot)
                    self.navigationController?.pushViewController(nextView, animated: true)
                }
            }else {
                DispatchQueue.main.async(execute: {
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("确定", action: {() ->Void in
                        print("跳转到摄像头绑定界面")
                        let nextView = sb.instantiateViewController(withIdentifier: "userBindModeViewController") as! UserBindModeViewController
                        self.navigationController?.pushViewController(nextView , animated: true)
                    })
                    alertView.showInfo("提示", subTitle: "使用摄像头功能需要先绑定乐橙账号", duration: 0)//时间间隔为0时不会自动退出
                })
            }
        }else {//除了摄像头之外，又是一大类
            if nElectricType == 0 || nElectricType==1 || nElectricType==2 || nElectricType==3 || nElectricType==4 {//插座，普通开关
                let nextView = sb.instantiateViewController(withIdentifier: "elecSwitchViewCtrl") as! ElecSwitchViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==5 {
                let nextView = sb.instantiateViewController(withIdentifier: "elecDoorViewCtrl") as! ElecDoorViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==6 {
                let nextView = sb.instantiateViewController(withIdentifier: "elecCurtainViewCtrl") as! ElecCurtainViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==7 || nElectricType==11 {
                let nextView = sb.instantiateViewController(withIdentifier: "elecWindowViewCtrl") as! ElecWindowViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==9 {//空调
                let nextView = sb.instantiateViewController(withIdentifier: "elecAirViewCtrl") as! ElecAirViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==10 {//情景开关
                let nextView = sb.instantiateViewController(withIdentifier: "elecSceneSwitchViewCtrl") as! ElecSceneSwitchViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==12 {//电视
                let nextView = sb.instantiateViewController(withIdentifier: "elecTvViewCtrl") as! ElecTvViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if (nElectricType>=13&&nElectricType<=17) || nElectricType==19 {//传感器
                let nextView = sb.instantiateViewController(withIdentifier: "elecSensorViewCtrl") as! ElecSensorViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==18 {//警号
                let nextView = sb.instantiateViewController(withIdentifier: "elecHornViewCtrl") as! ElecHornViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==20 {//晾衣架
                let nextView = sb.instantiateViewController(withIdentifier: "elecClothesViewCtrl") as! ElecClothesViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==21 {//学习型空调

            }else if nElectricType==22 {//中央空调

            }else if nElectricType==23 {//新门锁
                let nextView = sb.instantiateViewController(withIdentifier: "elecDoor2ViewCtrl") as! ElecDoor2ViewCtrl
                nextView.m_nAreaListFoot = m_nAreaListFoot
                nextView.m_nElectricListFoot = electricFoot
                self.navigationController?.pushViewController(nextView , animated: true)
            }else if nElectricType==24 {//学习型电视

            }
        }
    }

    //点击添加电器按钮
    func OnAddElectric() {
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "addElectricTypeViewCtrl") as! AddElectricTypeViewCtrl
        nextView.m_nAreaListFoot = self.m_nAreaListFoot
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if gDC.mUserInfo.m_nIsAdmin == 1 {
            return gDC.mAreaList[m_nAreaListFoot].mElectricList.count + 1//之所以加1，是因为最后有一个添加按钮
        }else {
            return gDC.mAreaList[m_nAreaListFoot].mElectricList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let viewWidth = collectionView.frame.width
        let cellWidth = (viewWidth-2)/3
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //返回Cell内容，deleteElectric去掉右上角的钩之后，就是普通状态了
        for i in 0..<gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricSequ == indexPath.row {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deleteElectric", for: indexPath) as! DeleteElectric
                cell.backgroundColor = UIColor.white
                cell.m_imageSelected.isHidden = true//隐藏选中图标
                cell.m_labelElectric.text = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sElectricName
                let nType = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricType
                switch nType {
                case 1:
                    let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sElectricState
                    if state=="Z1" {
                        cell.m_imageElectric.image = UIImage(named: "电器_一键开关_开")
                    }else {
                        cell.m_imageElectric.image = UIImage(named: "电器_一键开关_关")
                    }
                case 2:
                    //Z0：两边关，Z1：仅左开，Z2：仅右开，Z3：都开
                    let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sElectricState
                    if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo == "01" {//左边开关
                        if state=="00" || state=="Z0" ||  state=="Z2" {
                            cell.m_imageElectric.image = UIImage(named: "电器_两键开关_左关")
                        }else {
                            cell.m_imageElectric.image = UIImage(named: "电器_两键开关_左开")
                        }
                    }else {
                        if state=="00" || state=="Z0" ||  state=="Z1" {
                            cell.m_imageElectric.image = UIImage(named: "电器_两键开关_右关")
                        }else {
                            cell.m_imageElectric.image = UIImage(named: "电器_两键开关_右开")
                        }
                    }
                case 3:
                    //Z0：都关，Z1：仅←开，Z2：仅↑开，Z3：仅←↑开，Z4：仅→开，Z5：←→开，Z6：↑→开，Z7：都开
                    let state:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sElectricState
                    if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo == "01" {
                        if state=="00" || state=="Z0" ||  state=="Z2" || state=="Z4" || state=="Z6" {
                            cell.m_imageElectric.image = UIImage(named: "电器_三键开关_左关")
                        }else {
                            cell.m_imageElectric.image = UIImage(named: "电器_三键开关_左开")
                        }
                    }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo == "02" {
                        if state=="00" || state=="Z0" || state=="Z1" ||  state=="Z4" || state=="Z5" {
                            cell.m_imageElectric.image = UIImage(named: "电器_三键开关_中关")
                        }else {
                            cell.m_imageElectric.image = UIImage(named: "电器_三键开关_中开")
                        }
                    }else {
                        if state=="00" || state=="Z0" ||  state=="Z1" || state=="Z2" || state=="Z3" {
                            cell.m_imageElectric.image = UIImage(named: "电器_三键开关_右关")
                        }else {
                            cell.m_imageElectric.image = UIImage(named: "电器_三键开关_右开")
                        }
                    }
                //TODO：注意这里的四键开关还没有做出来
                case 10:
                    //Z0：都关，Z1：仅←开，Z2：仅↑开，Z3：仅←↑开，Z4：仅→开，Z5：←→开，Z6：↑→开，Z7：都开
                    if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo == "01" {
                        cell.m_imageElectric.image = UIImage(named: "电器_四键开关_左上关")
                    }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo == "02" {
                        cell.m_imageElectric.image = UIImage(named: "电器_四键开关_右上关")
                    }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo == "03" {
                        cell.m_imageElectric.image = UIImage(named: "电器_四键开关_左下关")
                    }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo == "04" {
                        cell.m_imageElectric.image = UIImage(named: "电器_四键开关_右下关")
                    }
                default:
                    cell.m_imageElectric.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)
                    break
                }
                return cell
            }
        }
        if indexPath.row == gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addElectric", for: indexPath) as! AddElectric
            cell.backgroundColor = UIColor.white
            return cell
        }
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "deleteElectric", for: indexPath) as! DeleteElectric
        return cell2//事实上永远不会执行这里
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //某个Cell被选择的事件处理
        for i in 0..<gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricSequ == indexPath.row {
                OnElectric(i)
                return
            }
        }
        if indexPath.row == gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            OnAddElectric()
        }
    }
    
}






