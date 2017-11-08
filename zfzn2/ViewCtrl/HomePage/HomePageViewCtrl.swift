//
//  HomePageViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/10/19.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class HomePageViewCtrl: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var m_btnAccountLogo: UIButton!
    @IBOutlet weak var m_imageAccountLogo: UIImageView!
    @IBOutlet weak var m_labelOnLine: UILabel!
    @IBOutlet weak var m_vScene: UIView!
    @IBOutlet weak var m_collectionScene: UICollectionView!
    @IBOutlet weak var m_collectionArea: UICollectionView!
    @IBOutlet weak var m_barbtnAdd: UIButton!
    @IBOutlet weak var m_labelWeatherCity: UILabel!
    @IBOutlet weak var m_labelWeatherTemperature: UILabel!//当前温度
    @IBOutlet weak var m_labelWeatherInfo: UILabel!//当前天气细节
    @IBOutlet weak var m_imageWeatherFrom: UIImageView!//天气1
    @IBOutlet weak var m_imageWeatherTo: UIImageView!//天气2
    var m_nMiniAreaCount:Int!
    var m_nSelectedSceneListFoot:Int!
    var m_arrayMasterCode = [String]()
    var m_arrayMasterIP = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        //点击logo图片弹出左侧菜单
        m_btnAccountLogo.addTarget(self.tabBarController!.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //只允许在主界面中拖出左侧菜单
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        //设置左侧菜单栏宽度占比为4分之3
        print(self.view.frame.size)
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width*3/4
        self.revealViewController().rearViewRevealOverdraw = 0
        //设置logo图片的圆角
        m_imageAccountLogo.image = gDC.mAccountInfo.m_imageAccountHead
        let btnHeight = m_imageAccountLogo.layer.bounds.size.height
        m_imageAccountLogo.layer.cornerRadius = btnHeight/2
        m_imageAccountLogo.layer.masksToBounds = true
        //显示是否在线
        RefreshRemoteState()
        
        g_notiCenter.addObserver(self, selector:#selector(HomePageViewCtrl.RefreshRemoteState),name: NSNotification.Name(rawValue: "RefreshRemoteState"), object: nil)
        g_notiCenter.addObserver(self, selector:#selector(HomePageViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
        
        //初始化情景和区域中常用的四个图片按钮
        InitScene()
        InitArea()
        
        //在oginViewCtrl中成功获取到当前定位的城市后，向这里发送响应，重新获取天气信息并刷新显示
//        g_notiCenter.addObserver(self, selector:#selector(HomePageViewCtrl.RefreshWeatherInfo),name: NSNotification.Name(rawValue: "RefreshWeather"), object: nil)
//        m_labelWeatherCity.text = gDC.m_sCityName
//        m_labelWeatherCity.text = ""
//        RefreshWeatherInfo()
        
        //在后台搜索主机，并重置当前主机的ip地址，便于下一次登陆后的成功搜索
        UpdateMasterIP()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        m_imageAccountLogo.image = gDC.mAccountInfo.m_imageAccountHead
        //显示是否在线
        if gDC.m_bRemote == false {
            m_labelOnLine.text = "-本地"
        }else {
            m_labelOnLine.text = "-远程"
        }
        m_labelWeatherCity.text = gDC.m_sCityName
        //刷新天气信息
//        RefreshWeatherInfo()
        m_collectionScene.reloadData()
        m_collectionArea.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnAlarmRecord(_ sender: Any) {
        print("点击报警列表菜单")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "alarmRecordViewCtrl") as! AlarmRecordViewCtrl
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func OnAdd(_ sender: UIButton) {
        print("按下")
        if gDC.mUserInfo.m_nIsAdmin == 0 {
            ShowNoticeDispatch("提示", content: "权限不足", duration: 0.5)
            return
        }
        let menuArray:NSArray = [KxMenuItem.init("添加区域", image: UIImage(named: "首页_添加区域"), target: self, action: #selector(HomePageViewCtrl.OnAddArea))]
        //, KxMenuItem.init("添加电器",image: UIImage(named: "首页_添加电器"), target: self, action: #selector(HomePageViewCtrl.OnAddElectric))
        /*设置菜单字体*/
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        let options = OptionalConfiguration(arrowSize: 9,  //指示箭头大小
            marginXSpacing: 7,  //MenuItem左右边距
            marginYSpacing: 7,  //MenuItem上下边距
            intervalSpacing: 14,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: false,  //是否添加菜单阴影
            hasSeperatorLine: true,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        /*菜单位置*/
        let a = CGRect(x: self.m_barbtnAdd.frame.minX+8, y: self.m_barbtnAdd.frame.maxY, width: 0, height: 0)
        KxMenu.show(in: self.view, from: a, menuItems: menuArray as! [Any], withOptions: options)
    }

    //初始化情景模式中的几个按钮
    func InitScene() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        //        layout.scrollDirection = .Vertical
        m_collectionScene.setCollectionViewLayout(layout, animated: true)
        m_collectionScene.register(MiniSceneAndArea.self, forCellWithReuseIdentifier: "miniSceneAndArea")
        m_collectionScene.register(UINib(nibName: "MiniSceneAndArea", bundle: nil), forCellWithReuseIdentifier: "miniSceneAndArea")
        m_collectionScene.bounces = false//不需要弹簧效果
    }
    
    //初始化情景模式中的几个按钮
    func InitArea() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
//        layout.scrollDirection = .Vertical
        m_collectionArea.setCollectionViewLayout(layout, animated: true)
        m_collectionArea.register(MiniSceneAndArea.self, forCellWithReuseIdentifier: "miniSceneAndArea")
        m_collectionArea.register(UINib(nibName: "MiniSceneAndArea", bundle: nil), forCellWithReuseIdentifier: "miniSceneAndArea")
        m_collectionArea.bounces = false//不需要弹簧效果
    }
    
    //刷新天气信息
    func RefreshWeatherInfo() {
        let sTime = GetCurrentTime()
        let date = ChangeStringToDate(sTime)
        let timeDelta = date.timeIntervalSince(gDC.m_timeGetWeather)
        if gDC.m_bFirstGetWeather == true {//直接从web读取
            ShowWeatherInfo("web")
        }else if Int(timeDelta) > gDC.m_nWeatherDeltaTime {//间隔超过两个小时的话
            ShowWeatherInfo("web")
        }else {
            ShowWeatherInfo("plist")
        }
//        m_labelWeatherCity.text = gDC.m_sCityName
    }
    
    //从公用web接口获取当前区域的天气信息
    func ShowWeatherInfo(_ sType:String) {
        if sType == "web" {//如果需要从web获取的话
            print("开始获取该城市的天气信息——\(gDC.m_sCityName)")
            let arrayWeather = PublicWebService.sharedInstance.GetWeatherbyCityName(gDC.m_sCityName)
            let sReturn:String = arrayWeather[0] as! String
//            for i in 0..<arrayWeather.count {
//                print(arrayWeather[i] as! String)
//            }
            if (sReturn == "WebError") || (arrayWeather.count<10) {//说明网络出现了问题
                m_imageWeatherFrom.isHidden = false
                m_imageWeatherTo.isHidden = false
                m_imageWeatherFrom.image = UIImage(named: "nothing")
                m_imageWeatherTo.image = UIImage(named: "nothing")
                m_labelWeatherTemperature.text = "获取温度失败"//当天温度
                m_labelWeatherInfo.text = "获取天气信息失败"//当天其他天气信息
                //这里不重置最新的获取时间，这样下次刷新的时候可以及时获取到天气信息
                return
            }
            let sWeatherTemperature:String = arrayWeather[5] as! String
            m_labelWeatherTemperature.text = sWeatherTemperature//当天温度
            //sInfoAll：今日天气实况：气温：18℃；风向/风力：南风 3级；湿度：58%；紫外线强度：中等。空气质量：良。
            let sInfoAll = arrayWeather[10] as? String//各种天气信息
            let nInfoLength = sInfoAll?.characters.count
            let nWindStart = sInfoAll!.positionOf("风向/风力：")
            let nHumidityStart = sInfoAll!.positionOf("；湿度：")
            let nAirQualityStart = sInfoAll!.positionOf("空气质量：")
            let sWind = (sInfoAll as NSString?)!.substring(with: NSMakeRange(nWindStart+6, nHumidityStart-nWindStart-6))
            let sAirQuality = (sInfoAll as NSString?)!.substring(with: NSMakeRange(nAirQualityStart+5, nInfoLength!-nAirQualityStart-6))
            let sWeatherInfo:String! = "\(sWind)，空气质量 \(sAirQuality)"
            m_labelWeatherInfo.text = sWeatherInfo
            //显示天气图片
            let sWeatherFrom = arrayWeather[8] as? String//从某天气状况
            let sWeatherTo = arrayWeather[9] as? String//转至某天气状况
            let sNameFrom = (sWeatherFrom as NSString?)!.substring(with: NSMakeRange(0, (sWeatherFrom?.characters.count)!-4))
            let sNameTo = (sWeatherTo as NSString?)!.substring(with: NSMakeRange(0, (sWeatherTo?.characters.count)!-4))
            if sNameFrom == sNameTo {
                m_imageWeatherFrom.isHidden = true
                m_imageWeatherTo.image = UIImage(named: sNameTo)
            }else {
                m_imageWeatherFrom.isHidden = false
                m_imageWeatherFrom.image = UIImage(named: sNameFrom)
                m_imageWeatherTo.image = UIImage(named: sNameTo)
            }
            //重置plist中的部分值
            let fullPath = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
            let dict = NSMutableDictionary.init(contentsOfFile: fullPath)
            gDC.m_bFirstGetWeather = false
            dict?.setObject(gDC.m_bFirstGetWeather, forKey: "is_first_get_weather" as NSCopying)
            let sTime = GetCurrentTime()
            gDC.m_timeGetWeather = ChangeStringToDate(sTime)
            dict?.setObject(gDC.m_timeGetWeather, forKey: "get_weather_time" as NSCopying)
            dict?.setObject(sNameFrom, forKey:
                "weather_from" as NSCopying)
            dict?.setObject(sNameTo, forKey: "weather_to" as NSCopying)
            dict?.setObject(sWeatherTemperature, forKey: "weather_temperature" as NSCopying)
            dict?.setObject(sWeatherInfo, forKey: "weather_info" as NSCopying)
            dict?.write(toFile: fullPath, atomically: true)
            print("已从web获取到天气信息")
        }else {//否则需要从Plist文件中获取
            let filePathAccount = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
            let dictAccountPlist = NSMutableDictionary.init(contentsOfFile: filePathAccount)//根据plist文件路径读取到数据字典
            gDC.m_sWeatherFrom = dictAccountPlist?.object(forKey: "weather_from") as! String
            gDC.m_sWeatherTo = dictAccountPlist?.object(forKey: "weather_to") as! String
            gDC.m_sWeatherTemperature = dictAccountPlist?.object(forKey: "weather_temperature") as! String
            gDC.m_sWeatherInfo = dictAccountPlist?.object(forKey: "weather_info") as! String
            if gDC.m_sWeatherFrom == gDC.m_sWeatherTo {
                m_imageWeatherFrom.isHidden = true
                m_imageWeatherTo.image = UIImage(named: gDC.m_sWeatherTo)
            }else {
                m_imageWeatherFrom.isHidden = false
                m_imageWeatherFrom.image = UIImage(named: gDC.m_sWeatherFrom)
                m_imageWeatherTo.image = UIImage(named: gDC.m_sWeatherTo)
            }
            m_labelWeatherTemperature.text = gDC.m_sWeatherTemperature//当天温度
            m_labelWeatherInfo.text = gDC.m_sWeatherInfo//当天其他天气信息
            print("已从plist获取到天气信息")
        }
    }
    
    //由于主机的IP是会发生变化的，需要在登录完成后刷新ip地址
    func UpdateMasterIP() {
        m_arrayMasterCode.removeAll()//清空该数组，用于保存下一轮masterCode
        m_arrayMasterIP.removeAll()//清空该数组，用于保存下一轮masterIP
        let queue = DispatchQueue(label: "tk.bourne.ipQueue", attributes: []);
        queue.async(execute: {
            (self.m_arrayMasterCode, self.m_arrayMasterIP) = MySocket.sharedInstance.SearchMasterNodeIP()//获得主机的编号和具体ip地址
            if self.m_arrayMasterCode.count == 0 {
                print("UpdateUserIP——并没有在本地搜索到任何主机，无法更新")
            }
            //在这里更新master列表的ip值
            for i in 0..<self.m_arrayMasterCode.count {
                let webReturn:String = MyWebService.sharedInstance.UpdateUserIP(self.m_arrayMasterCode[i], userIP: self.m_arrayMasterIP[i])
                self.WebUpdateUserIP(webReturn)//返回的是3？
                if (self.m_arrayMasterCode[i]==gDC.mUserInfo.m_sMasterCode) {
                    gDC.mUserInfo.m_sUserIP = self.m_arrayMasterIP[i]
                }
            }
        })
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebValidLogin(_ responseValue:String) {
        switch responseValue{
        case "WebError"://网络连接错误
            break
        case "1"://修改成功
            print("更新userIp成功")
            break
        default:
            print("更新userIp失败")
            break
        }
    }
    
    func WebUpdateUserIP(_ responseValue:String) {
        switch responseValue{
        case "WebError"://网络连接错误
            break
        case "1"://修改成功
            break
        default:
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == m_collectionScene {//如果是情景collection
            if gDC.mSceneList.count <= 4 {
                return gDC.mSceneList.count
            }else {
                return 4
            }
        }else {//如果是区域collection
            if gDC.mAreaList.count <= 4 {
                return gDC.mAreaList.count
            }else {
                return 4
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == m_collectionScene {//如果是情景collection
            let viewWidth = collectionView.frame.width
            let cellHeight = viewWidth*9/32
            let cellWidth = cellHeight*8/10
            return CGSize(width: cellWidth, height: cellHeight)
        }else {//如果是区域collection
            let viewWidth = collectionView.frame.width
            let cellHeight = viewWidth*9/32
            let cellWidth = cellHeight*8/10
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniSceneAndArea", for: indexPath) as! MiniSceneAndArea
        if collectionView == m_collectionScene {//如果是情景collection
            for i in 0..<gDC.mSceneList.count {
                if indexPath.row == gDC.mSceneList[i].m_nSceneSequ {//从左到右的序号和sequ相同
//            let i:Int = indexPath.row
//            if i < gDC.mSceneList.count-1 {
                cell.m_imageView.image = gDC.mSceneList[i].m_imageScene
                cell.m_layoutBottom.constant = cell.m_labelName.frame.height
                cell.m_labelName.font = UIFont(name: "times new roman",size: cell.m_labelName.frame.height)
                cell.m_labelName.text = gDC.mSceneList[i].m_sSceneName
//            }
                }
            }
        }else {//如果是区域collection
            for i in 0..<gDC.mAreaList.count {
                if indexPath.row == gDC.mAreaList[i].m_nAreaSequ {//从左到右的序号和sequ相同
                    //自动裁剪成居中的正方形图片
                    if gDC.mAreaList[i].m_imageArea != nil {
                        let sizeImage = gDC.mAreaList[i].m_imageArea?.size
                        let cubeImage:UIImage = CutImage(gDC.mAreaList[i].m_imageArea!, rect:CGRect(x: (sizeImage!.width-sizeImage!.height)/2.0, y: 0, width: sizeImage!.height, height: sizeImage!.height))
                        cell.m_imageView.image = cubeImage
                        cell.m_imageView.layer.cornerRadius = cell.m_imageView.frame.height/2
                        cell.m_imageView.layer.masksToBounds = true
                    }else {
                        cell.m_imageView.image = nil
                    }
                    cell.m_layoutBottom.constant = cell.m_labelName.frame.height
                    cell.m_labelName.font = UIFont(name: "times new roman",size: cell.m_labelName.frame.height)
                    cell.m_labelName.text = gDC.mAreaList[i].m_sAreaName
                }
            }
        }
        return cell
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == m_collectionScene {
//            self.performSegueWithIdentifier("mainPageToScenePage", sender: self)
//            gDC.m_bQuickScene = true
//            gDC.m_nSelectSceneSequ = indexPath.row
//            self.tabBarController?.selectedIndex = 2
            let mainStory = UIStoryboard(name: "Main",bundle: nil)
            let nextView = mainStory.instantiateViewController(withIdentifier: "scenePageViewCtrl") as! ScenePageViewCtrl
            nextView.m_nSceneListFoot = indexPath.row
//            self.tabBarController?.viewControllers![2].navigationController!.pushViewController(nextView, animated: true)
            self.navigationController?.pushViewController(nextView, animated: true)
            
        }else {
            //跳转到指定的房间界面
            gDC.m_bRefreshAreaList = true
            gDC.m_nSelectAreaSequ = indexPath.row
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func OnAddArea() {
        print("点击添加区域菜单")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextView = sb.instantiateViewController(withIdentifier: "addAreaViewCtrl") as! AddAreaViewCtrl
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    func OnAddElectric() {
        print("点击添加电器菜单")
    }
    ////////////////////////////////////////////////////////////////////////////////////
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destView:ScenePageViewCtrl = segue.destination as! ScenePageViewCtrl
        destView.m_nSceneListFoot = self.m_nSelectedSceneListFoot
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func RefreshRemoteState() {
        if gDC.m_bRemote==false {
            m_labelOnLine.text = "-本地"
        }else {
            m_labelOnLine.text = "-远程"
        }
    }
    
    func SyncData() {
        m_collectionScene.reloadData()
        m_collectionArea.reloadData()
    }

}
