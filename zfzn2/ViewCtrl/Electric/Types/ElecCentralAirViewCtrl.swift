//
//  ElecCentralAirViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/3/13.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecCentralAirViewCtrl: ElecSuperViewCtrl, UITableViewDelegate, UITableViewDataSource, CheckedCentralAirCellDelegate {

    @IBOutlet weak var m_labletemperature: UILabel!
    @IBOutlet weak var m_slider: UISlider!
    @IBOutlet weak var m_checkall: UIImageView!
    @IBOutlet weak var m_tableCentralAir: UITableView!
    var mCentralAirList = [ElecCentralAirData]()
    var m_nCentralAirListFoot:Int!
    var m_codescount:Int!
    var m_codesdictionary:[String:String] = [ : ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_checkall.isHidden = true  //开始全选框未选中
        m_tableCentralAir.register(CentralAirCell.self, forCellReuseIdentifier: "centralAirCell")
        m_tableCentralAir.register(UINib(nibName: "CentralAirCell", bundle: nil), forCellReuseIdentifier: "centralAirCell")//创建一个可重用的单元格
        m_tableCentralAir.bounces = false
        m_tableCentralAir.tableFooterView = UIView()//隐藏多余行
        // Do any additional setup after loading the view.
        m_slider.addTarget(self,action:#selector(ElecCentralAirViewCtrl.SliderDidchange), for:UIControlEvents.valueChanged)  //滑动滑块触发动作
        g_notiCenter.addObserver(self, selector:#selector(ElecCentralAirViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        Refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Onback(_ sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
         g_notiCenter.removeObserver(self) //移除观察器
    }
    
    func SliderDidchange(){
        let temperature = Int(m_slider.value)
        m_labletemperature.text = "温度：\(temperature)℃"
        let tem = String(format: "%0X", (temperature-16))//温度转换为十六进制
        let functioncode:String = "01321" + tem
        let functionsum:Int = 67+temperature-16
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: functioncode,functionsum: functionsum)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func ReduceT(_ sender: Any) {//降低温度1℃
        m_slider.setValue(m_slider.value-1, animated: true)
        SliderDidchange()
    }
    @IBAction func RiseT(_ sender: Any) {//升高温度1℃
        m_slider.setValue(m_slider.value+1, animated: true)
        SliderDidchange()
    }
    
    
    @IBAction func QuerycentralairStatus(_ sender: Any) { //查询
        if m_codescount != nil {
            m_sElectricOrder = QueryCentralAirStatus()
            if m_sElectricOrder != "0"{
            CentralAir()
            }
        }
    }
    
    @IBAction func OpenCentralAir(_ sender: Any) {//开空调
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013101",functionsum: 51)
             if m_sElectricOrder != "0"{
            CentralAir()
        }
        }
    }

    
    @IBAction func CloseCentralAir(_ sender: Any) {//关空调
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013102",functionsum: 52)
             if m_sElectricOrder != "0"{
            CentralAir()
        }
        }
    }

    
    @IBAction func MakeCold(_ sender: Any) {//制冷
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013301",functionsum: 53)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func MakeHot(_ sender: Any) {//制热
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013308",functionsum: 60)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func SendWind(_ sender: Any) {//送风
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013304",functionsum: 56)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func RemoveWet(_ sender: Any) {//除湿
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013302",functionsum: 54)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func SetHighSpeed(_ sender: Any) {//高速
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013401",functionsum: 54)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func SetMiddleSpeed(_ sender: Any) {//中速
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013402",functionsum: 55)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func SetLowSpeed(_ sender: Any) {//低速
        if m_codescount != nil {
            m_sElectricOrder = Controlcentralair(functioncode: "013404",functionsum: 57)
            if m_sElectricOrder != "0"{
                CentralAir()
            }
        }
    }
    
    @IBAction func CentralAirDelete(_ sender: Any) {//删除空调
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("确定", action: {()->Void in
                self.deletecentralair()//调用删除函数
            })
            alertView.showInfo("警告", subTitle: "是否确认删除选中的空调？", duration: 0)//时间间隔为0时不会自动退出
        })
    }
    
    //////确认删除后调用该函数 进行删除
    func deletecentralair(){
        var mark:Bool = false
        for i in 0..<mCentralAirList.count{
            if mCentralAirList[i].m_Selected{
                mark = true
                let airCode:String = mCentralAirList[i].m_CentralAircodes
                let airName:String = mCentralAirList[i].m_CentralAirNumber
                let masterCode:String = gDC.mUserInfo.m_sMasterCode
                let electricIndex:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex
                let webResult:String = MyWebService.sharedInstance.DeleteCentralAir(masterCode:masterCode,electricIndex:electricIndex,airCode:airCode,airName:airName)
                WebDeleteCentralAir(responseValue: webResult,aircode: airCode)
            }
        }
        if mark{
            Refresh()
            ShowInfoDispatch("提示", content: "删除空调成功", duration: 0.8)
        }
    }
    
    func WebDeleteCentralAir(responseValue:String,aircode:String){      //删除后从服务器端得到反馈
        switch responseValue {
        case "WebError":
            break
        case "1":
            var json:JSON!
            var json1:JSON!
            let sJson:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras
            if (sJson == "" || sJson == "[]") {
                m_codesdictionary = [:]
            }else {
                if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    do { json = try JSON(data: jsonData) }
                    catch { print("json error"); return; }
                    m_codesdictionary = json.dictionaryObject as! [String: String]
                }
            }
            m_codesdictionary.removeValue(forKey: aircode)
            json1 = JSON(object: m_codesdictionary)
            let sJson1:String = json1.rawString() ?? "{}"
            gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras = sJson1
        default:
            break
        }
    }
    
    
    @IBAction func CentralAirAdd(_ sender: Any) {//添加空调
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "addCentralAir") as! AddCentralAir
        nextView.m_nAreaListFoot = m_nAreaListFoot
        nextView.m_nElectricListFoot = m_nElectricListFoot
        nextView.mCentralAirList = mCentralAirList
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    ////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mCentralAirList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "centralAirCell", for: indexPath) as! CentralAirCell
        cell.m_labelNumber.text = mCentralAirList[indexPath.row].m_CentralAirNumber//显示房间名
        cell.m_imagecheck.isHidden = !mCentralAirList[indexPath.row].m_Selected//显示是否被选中
        cell.m_labelSwitch.text = mCentralAirList[indexPath.row].m_CentralAirSwitch//显示开关状态
        cell.m_labelPattern.text = mCentralAirList[indexPath.row].m_CentralAirPattern//显示模式
        cell.m_labelWindspeed.text = mCentralAirList[indexPath.row].m_CentralAirWindspeed//显示风速
        cell.m_labelSettemperature.text = mCentralAirList[indexPath.row].m_CentralAirSettemperature//显示设定温度
        cell.m_labelRoomtemperature.text = mCentralAirList[indexPath.row].m_CentralAirRoomtemperature//显示室内温度
        cell.m_labelErrorcode.text = mCentralAirList[indexPath.row].m_CentralAirErrorcode//显示错误码
        cell.m_nCentralAirElectricListFoot = indexPath.row
        cell.selectionStyle = UITableViewCellSelectionStyle.none//单元格点击不变色
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //全选
    @IBAction func Checkall(_ sender: Any) {
        if m_checkall.isHidden == false {//取消全选
            m_checkall.isHidden = true
            for i in 0..<mCentralAirList.count{
                mCentralAirList[i].m_Selected = false
            }
        }else{//选中全选
            m_checkall.isHidden = false
            for i in 0..<mCentralAirList.count{
                mCentralAirList[i].m_Selected = true
            }
        }
        self.m_tableCentralAir.reloadData()
    }
    
    //////////////////////////////////点击cell内部按钮操作
    func didCheckCentralAir(_ isHidden:Bool, CentralAirElectricListFoot:Int) {
        self.m_nCentralAirListFoot = CentralAirElectricListFoot
        if isHidden == false {
            mCentralAirList[m_nCentralAirListFoot].m_Selected = true
        }else{
            mCentralAirList[m_nCentralAirListFoot].m_Selected = false
        }
    }
    
    func didRenameCentralAir(CentralAirElectricListFoot:Int){
        self.m_nCentralAirListFoot = CentralAirElectricListFoot
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "renameCentralAir") as! RenameCentralAir
        nextView.m_nAreaListFoot = m_nAreaListFoot
        nextView.m_nElectricListFoot = m_nElectricListFoot
        nextView.m_nCentralAirListFoot = m_nCentralAirListFoot
        nextView.mCentralAirList = mCentralAirList
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    /////////////////////////////////////////////////////////
    
    
    //////////查询中央空调状态 发送的字符////////////
    func QueryCentralAirStatus() ->String{
        var checkcount:Int = 0
        var checkcodes:[String] = []
        for i in 0..<mCentralAirList.count{//选中空调的地址和数量
            if mCentralAirList[i].m_Selected{
                checkcodes.append(mCentralAirList[i].m_CentralAircodes)
                checkcount = checkcount + 1
            }
        }
        if checkcount > 0{
        var str:String
        var codes3:Int = 0
        var codes6:Int = 0
        for i in 0..<checkcount {             //计算空调地址和的十进制数
            let codes1:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(0, 1))
            let codes2:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(2, 1))
            let codes11:Int = GetInt(codes: codes1)
            let codes22:Int = GetInt(codes: codes2)
            codes3 += 16*(codes11+codes22)
        }
        for i in 0..<checkcount {
            let codes4:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(1, 1))
            let codes5:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(3, 1))
            let codes44:Int = GetInt(codes: codes4)
            let codes55:Int = GetInt(codes: codes5)
            codes6 += codes44+codes55
        }
        if checkcount == 0{
            ShowNoticeDispatch("提示", content: "未查询到任何中央空调", duration: 0.8)
        }
        if checkcount == 1{     //查询一台空调
            let sum:Int = codes3+codes6+83
            let check:String = Check(sum: sum)
            str = "01500101" + checkcodes[0] + check
        }else{                     //查询多台空调
            let codescount = Check(sum: checkcount)
            var i = 0
            var m_codessum:String = ""
            while i < checkcount {
                m_codessum += checkcodes[i]
                i += 1
            }
            let sum:Int = codes3+codes6+checkcount+96
            let check:String = Check(sum: sum)
            str = "01500F" + codescount + m_codessum + check
        }
            return str
        }else{
            return "0"
        }
    }
    
    /////////控制空调发送的字符串//////////
    func Controlcentralair(functioncode:String,functionsum:Int) -> String{
        var checkcount:Int = 0
        var checkcodes:[String] = []
        for i in 0..<mCentralAirList.count{//选中空调的地址和数量
            if mCentralAirList[i].m_Selected{
                checkcodes.append(mCentralAirList[i].m_CentralAircodes)
                checkcount = checkcount + 1
            }
        }
        if checkcount > 0{
        var str:String
        var codes3:Int = 0
        var codes6:Int = 0
        for i in 0..<checkcount {             //计算空调地址和的十进制数
            let codes1:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(0, 1))
            let codes2:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(2, 1))
            let codes11:Int = GetInt(codes: codes1)
            let codes22:Int = GetInt(codes: codes2)
            codes3 += 16*(codes11+codes22)
        }
        for i in 0..<checkcount {
            let codes4:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(1, 1))
            let codes5:String = (checkcodes[i] as NSString).substring(with: NSMakeRange(3, 1))
            let codes44:Int = GetInt(codes: codes4)
            let codes55:Int = GetInt(codes: codes5)
            codes6 += codes44+codes55
        }
        let codescount = Check(sum: checkcount)
        var i = 0
        var m_codessum:String = ""
        while i < checkcount {
            m_codessum += checkcodes[i]
            i += 1
        }
        let sum:Int = codes3+codes6+checkcount+functionsum
        let check:String = Check(sum: sum)
        str = functioncode + codescount + m_codessum + check
        return str
        }else{
            return "0"
        }
    }
 
    
    func RefreshElectricStates(){
        RefreshState()
    }
    func RefreshState(){
        let sStateInfo:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sStateInfo
        print(sStateInfo)
        let sFunction:String = (sStateInfo as NSString).substring(with: NSMakeRange(0, 4))
        if sFunction == "0150" && sStateInfo.count == 32 {//有时收到的状态码长度不够
            let sCodes:String = (sStateInfo as NSString).substring(with: NSMakeRange(8, 4))
            let sOnOff:String = (sStateInfo as NSString).substring(with: NSMakeRange(12, 2))
            let sSetT:String = (sStateInfo as NSString).substring(with: NSMakeRange(15, 1))
            let sPattern:String = (sStateInfo as NSString).substring(with: NSMakeRange(16, 2))
            let sWindspeed:String = (sStateInfo as NSString).substring(with: NSMakeRange(18, 2))
            let sRoomT:String = (sStateInfo as NSString).substring(with: NSMakeRange(20, 2))
            let sError:String = (sStateInfo as NSString).substring(with: NSMakeRange(22, 2))
            for i in 0..<mCentralAirList.count{
                if sCodes == mCentralAirList[i].m_CentralAircodes{
                    if sOnOff == "01"{
                        mCentralAirList[i].m_CentralAirSwitch = "状态:开"
                    }
                    if sOnOff == "00"{
                        mCentralAirList[i].m_CentralAirSwitch = "状态:关"
                    }
                    let setT:String = String(GetInt(codes: sSetT) + 16)
                    mCentralAirList[i].m_CentralAirSettemperature = "设定温度:" + setT + "℃"
                    if sPattern == "01"{
                        mCentralAirList[i].m_CentralAirPattern = "模式:制冷"
                    }
                    if sPattern == "08"{
                        mCentralAirList[i].m_CentralAirPattern = "模式:制热"
                    }
                    if sPattern == "04"{
                        mCentralAirList[i].m_CentralAirPattern = "模式:送风"
                    }
                    if sPattern == "02"{
                        mCentralAirList[i].m_CentralAirPattern = "模式:除湿"
                    }
                    if sWindspeed == "01"{
                        mCentralAirList[i].m_CentralAirWindspeed = "风速:高"
                    }
                    if sWindspeed == "02"{
                        mCentralAirList[i].m_CentralAirWindspeed = "风速:中"
                    }
                    if sWindspeed == "03"{
                        mCentralAirList[i].m_CentralAirWindspeed = "风速:低"
                    }
                    if sWindspeed == "04"{
                        mCentralAirList[i].m_CentralAirWindspeed = "风速:低"
                    }
                    if sWindspeed == "05"{
                        mCentralAirList[i].m_CentralAirWindspeed = "风速:低"
                    }
                    if sError == "00"{
                        mCentralAirList[i].m_CentralAirErrorcode = "无故障"
                    }
                    let sRoomT1:String = (sRoomT as NSString).substring(with: NSMakeRange(0, 1))
                    let sRoomT11:Int = GetInt(codes: sRoomT1)
                    let sRoomT2:String = (sRoomT as NSString).substring(with: NSMakeRange(1, 1))
                    let sRoomT22:Int = GetInt(codes: sRoomT2)
                    let roomT:String = String(sRoomT11*16 + sRoomT22 + 16)
                    mCentralAirList[i].m_CentralAirRoomtemperature = "室内温度:" + roomT + "℃"
                    break
                }
            }
        }else{
            //////接收到控制反馈，给延时，让主机做出变化，查询选中的空调list即可，///////
            sleep(2)
            QuerycentralairStatus(_: (Any).self)
        }
          self.m_tableCentralAir.reloadData()
    }
    
    ////界面刷新 重置mCentralList//////
    func Refresh(){
        var json:JSON!
        let sJson:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras
        if (sJson == "" || sJson == "[]") {
            m_codesdictionary = [:]
        }else {
            if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do { json = try JSON(data: jsonData) }
                catch { print("json error"); return; }
                m_codesdictionary = json.dictionaryObject as! [String: String]
                if mCentralAirList.count == 0{//初次进入刷新时
                    var count:Int = 0
                    for (key, value) in m_codesdictionary{
                        mCentralAirList.append(ElecCentralAirData())
                        mCentralAirList[count].m_CentralAirNumber = value
                        mCentralAirList[count].m_CentralAircodes = key
                        count = count + 1
                    }
                }else{     //添加空调或者删除空调之后刷新
                    var mCopyCentralAirList = [ElecCentralAirData]()
                    mCopyCentralAirList = mCentralAirList
                    mCentralAirList.removeAll()
                    var count:Int = 0
                    for (key, value) in m_codesdictionary{
                        var mark:Bool = true
                        for i in 0..<mCopyCentralAirList.count{
                            if mCopyCentralAirList[i].m_CentralAircodes == key{
                                mCentralAirList.append(mCopyCentralAirList[i])
                                count = count + 1
                                mark = false
                                break
                            }
                        }
                        if mark == true{
                            mCentralAirList.append(ElecCentralAirData())
                            mCentralAirList[count].m_CentralAirNumber = value
                            mCentralAirList[count].m_CentralAircodes = key
                            count = count + 1
                        }
                    }
                }
                m_codescount = mCentralAirList.count
            }
        }
        self.m_tableCentralAir.reloadData()
    }
    
    
    
    /////16进制单字符 转化 成Int值
    func GetInt(codes:String)->Int{
        let s1:String = codes
        var n1:Int = 0
        if s1 >= "0" && s1 <= "9" {
            n1 = Int(s1)!
        }else if s1 == "A" {
            n1 = 10
        }else if s1 == "B" {
            n1 = 11
        }else if s1 == "C" {
            n1 = 12
        }else if s1 == "D" {
            n1 = 13
        }else if s1 == "E" {
            n1 = 14
        }else if s1 == "F" {
            n1 = 15
        }else {
            return 0
        }
        return n1
    }
    
    // 计算校验位//十进制转换为十六进制
    func Check(sum:Int)->String{
        let check1 = String(format: "%0X", sum)
        if check1.count == 1{
            return "0" + check1
        }
        if check1.count == 2{
            return check1
        }else{
            let result:String = (check1 as NSString).substring(with: NSMakeRange(check1.count-2, 2))
            return result
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}


