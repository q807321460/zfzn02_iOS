//
//  LoginViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/10/17.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit
import CoreLocation

class LoginViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var m_eAccountCode: UITextField!
    @IBOutlet weak var m_ePassWord: UITextField!
    @IBOutlet weak var m_imgRememberPass: UIImageView!
    @IBOutlet weak var m_btnSelectAccount: UIButton!
    @IBOutlet weak var m_btnLogin: UIButton!
    @IBOutlet weak var m_tableAccountList:UITableView!
    @IBOutlet weak var m_layoutTableViewHeight: NSLayoutConstraint!
    var m_bSelecteAccount:Bool = false//是否处于下拉选择账户的状态
    var m_viewLoading:SCLAlertView! = nil
    var m_timer:Timer?//定时器
    var m_sArrayAccount = [String]()//用于从数据库中读取本机登录过的账户
    var m_currentLocation:CLLocation!//保存获取到的本地位置
    //用于定位服务管理类，它能够给我们提供位置信息和高度信息，也可以监控设备进入或离开某个区域，还可以获得设备的运行方向
    let mLocationManager:CLLocationManager = CLLocationManager()
    var mProvinceList = NSMutableArray()
    var mCityLists = [NSMutableArray]()
    var mCityList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_ePassWord.isSecureTextEntry = true//设置为密码输入框
        m_imgRememberPass.isHidden = true
        let btnHeight = m_btnLogin.layer.bounds.size.height
        self.m_btnLogin.layer.cornerRadius = btnHeight/2//实现按钮左右两侧完整的圆角
        self.m_btnLogin.layer.masksToBounds = true//允许圆角
        m_eAccountCode.clearButtonMode=UITextFieldViewMode.whileEditing  //编辑状态下显示右侧的叉号
        m_ePassWord.clearButtonMode=UITextFieldViewMode.whileEditing
        
        //获取曾登录过的账户列表，并初始化下拉账户列表
        m_sArrayAccount.removeAll()
        let myDire: String = NSHomeDirectory() + "/Documents/account_setting"
        let sArrayPlistFile = findFiles(myDire, filterTypes: ["plist"])
        for sAccount in sArrayPlistFile {
            let splitedArray = sAccount.components(separatedBy: ".")
            m_sArrayAccount.append(splitedArray[0])
        }
        m_tableAccountList.isHidden = true
        m_tableAccountList.dataSource = self
        m_tableAccountList.delegate = self
        m_tableAccountList.bounces = false
        if(m_tableAccountList.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            m_tableAccountList.separatorInset = UIEdgeInsets.zero
        }
        if(m_tableAccountList.responds(to: #selector(setter: UIView.layoutMargins))){
            m_tableAccountList.layoutMargins = UIEdgeInsets.zero
        }
        if m_sArrayAccount.count <= 4 {
            m_layoutTableViewHeight.constant = CGFloat(m_sArrayAccount.count) * 40
        }else {
            m_layoutTableViewHeight.constant = CGFloat(4) * 40
        }
        m_tableAccountList.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")//设置重用ID
        //读取当前位置？
        mLocationManager.delegate = self
        mLocationManager.requestWhenInUseAuthorization()
        mLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters//精度为100米
//        mLocationManager.desiredAccuracy = kCLLocationAccuracyBest//设备使用电池供电时最高的精度
        mLocationManager.distanceFilter = kCLLocationAccuracyKilometer//精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        
        ReadPlistData()
        ReadAccountPlistData()
    }
    
    deinit {
        //视图退出时一定要销毁这个观测器，如果没有取消监听消息，消息会发送给一个已经销毁的对象，导致程序崩溃
        g_notiCenter.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        gDC.mUserList.removeAll()
        //获取曾登录过的账户列表，并初始化下拉账户列表
        m_sArrayAccount.removeAll()
        let myDire: String = NSHomeDirectory() + "/Documents/account_setting"
        let sArrayPlistFile = findFiles(myDire, filterTypes: ["plist"])
        for sAccount in sArrayPlistFile {
            let splitedArray = sAccount.components(separatedBy: ".")
            m_sArrayAccount.append(splitedArray[0])
        }
        if m_sArrayAccount.count <= 4 {
            m_layoutTableViewHeight.constant = CGFloat(m_sArrayAccount.count) * 40
        }else {
            m_layoutTableViewHeight.constant = CGFloat(4) * 40
        }
        m_tableAccountList.reloadData()
    }
    
    @IBAction func OnRememberPass(_ sender: UIButton) {
        if m_imgRememberPass.isHidden == false {
            m_imgRememberPass.isHidden = true
        }else{
            m_imgRememberPass.isHidden = false
        }
    }

    @IBAction func TouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
        if m_bSelecteAccount==true {
            m_bSelecteAccount = false
            m_tableAccountList.isHidden = true
            m_btnSelectAccount.setImage(UIImage(named: "导航栏_下拉_白"), for: UIControlState())
            print(m_sArrayAccount)
        }
    }
    
    @IBAction func OnForgetPassword(_ sender: UIButton) {
//        ShowInfoDispatch("提示", content: "当前功能尚未开放，敬请期待~", duration: 1.5)
    }
    
    @IBAction func OnLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        //比较用户输入的用户名和密码VS正确的用户名和密码
        gDC.mAccountInfo.m_sAccountCode = m_eAccountCode.text!
        if gDC.mAccountInfo.m_sAccountCode == "" {
            ShowNoticeDispatch("提示", content: "请输入您的手机号", duration: 0.8)
        }else if m_eAccountCode.text?.count != 11 {
            ShowNoticeDispatch("提示", content: "手机号格式有问题", duration: 0.8)
        }else{
            m_btnLogin.isUserInteractionEnabled = false//保证登录按钮不被反复按下，因为涉及到网络通信，所以放在这个位置是比较合适的
            let sResult:String = MyWebService.sharedInstance.CheckUserPassword(self, accountCode: gDC.mAccountInfo.m_sAccountCode, password: self.m_ePassWord.text!)
            WebValidLogin(sResult)
            m_btnLogin.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func OnSelectAccount(_ sender: AnyObject) {
        if m_bSelecteAccount==false {
            m_bSelecteAccount = true
            m_tableAccountList.isHidden = false
            m_btnSelectAccount.setImage(UIImage(named: "导航栏_收起_白"), for: UIControlState())
            print(m_sArrayAccount)
        }else {
            m_bSelecteAccount = false
            m_tableAccountList.isHidden = true
            m_btnSelectAccount.setImage(UIImage(named: "导航栏_下拉_白"), for: UIControlState())
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return m_sArrayAccount.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 112/255, green: 85/255, blue: 119/255, alpha: 1)
        cell.textLabel?.text = m_sArrayAccount[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)    // 调整字体大小
        cell.textLabel?.textColor = UIColor.white
        //设置cell的一些属性······
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        m_eAccountCode.text = m_sArrayAccount[indexPath.row]
        m_bSelecteAccount = false
        m_tableAccountList.isHidden = true
        m_btnSelectAccount.setImage(UIImage(named: "导航栏_下拉_白"), for: UIControlState())
        gDC.mAccountInfo.m_sAccountCode = m_sArrayAccount[indexPath.row]//切换全局accountCode
        //根据plist中的设置，确定是否自动输入密码
        ReadAccountPlistData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func LoginSuccess() {
        //如果没有则创建之
        InitAccountPlistData()
        //根据plist文件路径读取到数据字典
        let filePath = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
        let arrayPlist = NSMutableDictionary.init(contentsOfFile: filePath)
        gDC.mAccountInfo.m_sLastMasterCode = arrayPlist?.object(forKey: "last_master") as! String
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            self.m_viewLoading = SCLAlertView(appearance: appearance)
            self.m_viewLoading.showInfo("提示", subTitle: " 正在加载用户数据......", duration: 0)
        })
        let dictsAccount = MyWebService.sharedInstance.LoadAccount(gDC.mAccountInfo.m_sAccountCode, accountTime: "")
        gDC.mAccountData.UpdateAccount(dictsAccount)
        let dictsUser = MyWebService.sharedInstance.LoadUser(gDC.mAccountInfo.m_sAccountCode, userTime: "")
        if (dictsUser.count <= 1) {//说明之前删除完所有的user，需要重新添加
            print("从登录界面到添加主机界面")
            self.m_viewLoading.hideView()//取消显示正在加载的字样
            self.performSegue(withIdentifier: "addMaster", sender: self)
            return
        }else {
            gDC.mUserData.UpdateUser(dictsUser)
        }
        MyWebService.sharedInstance.LoadDetailDataFromWs()
        MySocket.sharedInstance.SearchLocalMaster()
        LoadOtherData()
    }
    
    //读取各种列表数据，修改整体plist文件数据
    func LoadOtherData() {
        let filePath = DataFilePath("data.plist")//获得本地data.plist文件的路径
        let dict = NSMutableDictionary.init(contentsOfFile: filePath)//根据plist文件路径读取到数据字典
        if m_imgRememberPass.isHidden == false{
            dict?.setObject(true, forKey: "remember_loginStyle" as NSCopying)
        }else {
            dict?.setObject(false, forKey: "remember_loginStyle" as NSCopying)
        }
        dict?.setObject(m_eAccountCode.text!, forKey: "last_account" as NSCopying)
        dict?.setObject(m_ePassWord.text!, forKey: "last_password" as NSCopying)
        dict?.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "last_master" as NSCopying)
        dict?.setObject(m_eAccountCode.text!, forKey: "last_account" as NSCopying)
        dict?.setObject(gDC.m_dbVersion, forKey: "db_version" as NSCopying)
        dict!.write(toFile: filePath, atomically: true)
        //修改单个account的plist文件
        let fullPath = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
        let dictAccount = NSMutableDictionary.init(contentsOfFile: fullPath)//根据plist文件路径读取到数据字典
        dictAccount?.setObject(gDC.mUserInfo.m_sMasterCode, forKey: "last_master" as NSCopying)
        if m_imgRememberPass.isHidden == false{
            dictAccount?.setObject(true, forKey: "is_remember_password" as NSCopying)
            dictAccount?.setObject(m_ePassWord.text!, forKey: "password" as NSCopying)
        }else {
            dictAccount?.setObject(false, forKey: "is_remember_password" as NSCopying)
            dictAccount?.setObject("", forKey: "password" as NSCopying)
        }
        dictAccount!.write(toFile: fullPath, atomically: true)
        
        self.m_viewLoading.hideView()//取消显示正在加载的字样
        self.performSegue(withIdentifier: "login", sender: self)//如果有主机的话直接进入
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //创建账户plist文件数据
    func InitAccountPlistData(){
        let fullPath = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
        let manager = FileManager.default
        if  manager.fileExists(atPath: fullPath) == false{
            print("plist文件不存在，创建之")
            let dict = NSMutableDictionary()
            dict.setObject("********", forKey: "last_master" as NSCopying)
            dict.setObject(false, forKey: "is_remember_password" as NSCopying)
            dict.setObject("******", forKey: "password" as NSCopying)
//            gDC.m_bFirstGetWeather = true//既然需要创建，说明是新输入的账号，因此是第一次获取天气信息
//            dict.setObject(gDC.m_bFirstGetWeather, forKey: "is_first_get_weather" as NSCopying)
//            let sCurrentTime = GetCurrentTime()//获取当前的系统时间
//            gDC.m_timeGetWeather = ChangeStringToDate(sCurrentTime)
//            dict.setObject(gDC.m_timeGetWeather, forKey: "get_weather_time" as NSCopying)
//            GetCurrentCity()//获取当前的位置，首次创建这个plist时需要定位搜索之
//            dict.setObject(gDC.m_sProvinceName, forKey: "province" as NSCopying)
//            dict.setObject(gDC.m_sCityName, forKey: "city" as NSCopying)
//            dict.setObject(gDC.m_sWeatherFrom, forKey: "weather_from" as NSCopying)
//            dict.setObject(gDC.m_sWeatherTo, forKey: "weather_to" as NSCopying)
//            dict.setObject(gDC.m_sWeatherTemperature, forKey: "weather_temperature" as NSCopying)
//            dict.setObject(gDC.m_sWeatherInfo, forKey: "weather_info" as NSCopying)
            dict.write(toFile: fullPath, atomically: true)
        }else {
            //不作任何处理
        }
    }

    func ReadPlistData() {
        let filePathAll = DataFilePath("data.plist")//获得本地data.plist文件的路径
        let dict = NSMutableDictionary.init(contentsOfFile: filePathAll)//根据plist文件路径读取到数据字典
        gDC.mAccountInfo.m_sAccountCode = dict?.object(forKey: "last_account") as! String//最近一次登录的账户名
        m_eAccountCode.text = gDC.mAccountInfo.m_sAccountCode
        if ((dict?.object(forKey: "db_version")) != nil) { //1.2.013版本前是没有这个字段的
            gDC.m_dbVersionOld = dict?.object(forKey: "db_version") as! Int//当前沙盒中的数据库版本
        }else {
            gDC.m_dbVersionOld = 1
        }
        gMySqlClass.UpdateDBConstruction()//调整数据库版本
    }
    
    func ReadAccountPlistData() {
        if gDC.mAccountInfo.m_sAccountCode != "" {
            let filePathAccount = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
            let dictAccountPlist:NSMutableDictionary? = NSMutableDictionary.init(contentsOfFile: filePathAccount)//根据plist文件路径读取到数据字典
//            gDC.m_sLastMasterCode = dictAccountPlist?.object(forKey: "last_master") as! String//最近一次登录时使用的主节点编号，新手机则为空
            gDC.mUserInfo.m_sMasterCode = dictAccountPlist?.object(forKey: "last_master") as! String//最近一次登录时使用的主节点编号，新手机则为空
            let bRememberPassword = dictAccountPlist?.object(forKey: "is_remember_password") as! Bool
            //获取当前账号密码
            if bRememberPassword == false {
                m_ePassWord.text = ""
                m_imgRememberPass.isHidden = true
            }else {
                m_ePassWord.text = dictAccountPlist?.object(forKey: "password") as? String
                m_imgRememberPass.isHidden = false
            }
//            //获取是否第一次从web加载天气
//            if dictAccountPlist?.object(forKey: "is_first_get_weather") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_bFirstGetWeather = dictAccountPlist?.object(forKey: "is_first_get_weather") as! Bool
//            }
//            //获取上一次刷新天气的时间
//            if dictAccountPlist?.object(forKey: "get_weather_time") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_timeGetWeather = dictAccountPlist?.object(forKey: "get_weather_time") as! Date
//            }else {
//                let sCurrentTime = GetCurrentTime()
//                gDC.m_timeGetWeather = ChangeStringToDate(sCurrentTime)
//            }
//            //获取当前省份
//            if dictAccountPlist?.object(forKey: "province") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_sProvinceName = dictAccountPlist?.object(forKey: "province") as! String
//            }
//            //获取当前城市
//            if dictAccountPlist?.object(forKey: "city") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_sCityName = dictAccountPlist?.object(forKey: "city") as! String
//            }else {
//                GetCurrentCity()//版本更新时需要进入这里
//            }
//            //获取当前天气From
//            if dictAccountPlist?.object(forKey: "weather_from") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_sWeatherFrom = dictAccountPlist?.object(forKey: "weather_from") as! String
//            }
//            //获取当前天气To
//            if dictAccountPlist?.object(forKey: "weather_to") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_sWeatherTo = dictAccountPlist?.object(forKey: "weather_to") as! String
//            }
//            //获取当前天气温度
//            if dictAccountPlist?.object(forKey: "weather_temperature") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_sWeatherTemperature = dictAccountPlist?.object(forKey: "weather_temperature") as! String
//            }
//            //获取当前其他天气信息
//            if dictAccountPlist?.object(forKey: "weather_info") != nil {//1.2.022之前是没有这个字段的
//                gDC.m_sWeatherInfo = dictAccountPlist?.object(forKey: "weather_info") as! String
//            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func GetCurrentCity(){
        InitAddressPlist()
        //获取沙盒中的plist数据并读取
        let sFilePath:String = DataFilePath("address.plist")
        let arrayAll = NSMutableArray.init(contentsOfFile: sFilePath)!
        for i in 0..<arrayAll.count {
            let dict = arrayAll[i] as! NSDictionary
            mProvinceList.add(dict["provinceName"]! as! String)
            let arrayCity = dict["cityList"]! as! NSMutableArray
            mCityLists.append(arrayCity)
        }
        mLocationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            mLocationManager.stopUpdatingLocation()//停止查找，防止耗电
            m_currentLocation = locations.last
            print(m_currentLocation.coordinate.longitude)
            print(m_currentLocation.coordinate.latitude)
            let geocoder: CLGeocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(m_currentLocation, completionHandler: { (placemark: [CLPlacemark]?, error: Error?) in
                if (error == nil) {//转换成功，解析获取到的各个信息
                    let array = placemark! as NSArray
                    let mark = array.firstObject as! CLPlacemark
                    var sCity: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                    //去掉“市”和“省”字眼
                    sCity = sCity.replacingOccurrences(of: "市", with: "")
                    //判断在plist中是否存在同样的城市名，如果不存在则还是使用默认值
                    var bFind:Bool! = false
                    for var i in 0..<self.mProvinceList.count {
                        for j in 0..<self.mCityLists[i].count {
                            if self.mCityLists[i][j] as! String == sCity {//说明这个地名是支持获取天气的
                                gDC.m_sProvinceName = self.mProvinceList[i] as! String
                                gDC.m_sCityName = sCity
                                bFind = true
                                i = self.mProvinceList.count
                                gDC.m_bFirstGetWeather = true
                                g_notiCenter.post(name: Notification.Name(rawValue: "RefreshWeather"), object: self)//成功获取到当前定位的城市后，向主界面发送响应，让主界面重新获取天气信息并刷新显示
                                //重置plist中的部分值
                                let fullPath = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
                                let dict = NSMutableDictionary.init(contentsOfFile: fullPath)
                                dict?.setObject(gDC.m_sProvinceName, forKey: "province" as NSCopying)
                                dict?.setObject(gDC.m_sCityName, forKey: "city" as NSCopying)
                                dict?.write(toFile: fullPath, atomically: true)
                                break
                            }
                        }
                    }
                    if bFind == false {
                        ShowNoticeDispatch("提示", content: "定位失败，请在设置中手动编辑当前城市", duration: 1.2)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //点击登录后从webservice接收到的消息
    func WebValidLogin(_ responseValue:String) {
        switch responseValue{
        case "WebError"://网络连接错误
            break
        case "0":
            ShowNoticeDispatch("提示", content: "密码错误", duration: 0.5)
        case "1"://登陆成功
            LoginSuccess()
        case "2":
            ShowNoticeDispatch("提示", content: "不存在该用户", duration: 0.5)
        default:
            break
        }
    }
    
}

