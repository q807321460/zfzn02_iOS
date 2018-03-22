//
//  ElecCentralAirViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/3/13.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecCentralAirViewCtrl: ElecSuperViewCtrl, UITableViewDelegate, UITableViewDataSource, CheckedCentralAirCellDelegate {
  
    @IBAction func CentralAirAdd(_ sender: Any) {
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "addCentralAir") as! AddCentralAir
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    
    @IBOutlet weak var m_btnTemperature4: UIButton!
    @IBOutlet weak var m_btnTemperature3: UIButton!
    @IBOutlet weak var m_btnTemperature2: UIButton!
    @IBOutlet weak var m_btnTemperature1: UIButton!
    @IBOutlet weak var m_btnCold: UIButton!
    @IBOutlet weak var m_btnLow: UIButton!
    @IBOutlet weak var m_btnMiddle: UIButton!
    @IBOutlet weak var m_btnHigh: UIButton!
    @IBOutlet weak var m_btnWet: UIButton!
    @IBOutlet weak var m_btnWind: UIButton!
    @IBOutlet weak var m_btnHot: UIButton!
    @IBOutlet weak var m_btnOff: UIButton!
    @IBOutlet weak var m_btnOn: UIButton!
    @IBOutlet weak var m_tableCentralAir: UITableView!
    var mCentralAirList=[ElecCentralAirData]()
    var m_nCentralAirListFoot:Int!
    var m_codescount:Int!
    var m_codes:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_tableCentralAir.register(CentralAirCell.self, forCellReuseIdentifier: "centralAirCell")
        m_tableCentralAir.register(UINib(nibName: "CentralAirCell", bundle: nil), forCellReuseIdentifier: "centralAirCell")//创建一个可重用的单元格
        m_tableCentralAir.bounces = false
        print(gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras)
        
        // Do any additional setup after loading the view.
        var json:JSON!
        let sJson:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras
        if (sJson == "" || sJson == "[]") {
            print("nil")
        }else {
            if let jsonData = sJson.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do { json = try JSON(data: jsonData) }
                catch { print("json error"); return; }
                m_codes = json.arrayObject as! [String]
                m_codescount = m_codes.count
            }
        }
        m_sElectricOrder = GetString()
        Open()
         g_notiCenter.addObserver(self, selector:#selector(ElecCentralAirViewCtrl.RefreshElectricStates),name: NSNotification.Name(rawValue: "RefreshElectricStates"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//         return gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "centralAirCell", for: indexPath) as! CentralAirCell
//         cell.m_imageState.image = self.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirState
//        cell.m_imagecheck.image = gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAircheck
//        cell.m_labelNumber.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirNumber
//        cell.m_labelPattern.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirPattern
//        cell.m_labelSwitch.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirSwitch
//        cell.m_labelRoomtemperature.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirRoomtemperature
//        cell.m_labelSettemperature.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirSettemperature
//        cell.m_labelWindspeed.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirWindspeed
//        cell.m_labelErrorcode.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirErrorcode
          cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //////////////////////////////////点击cell内部按钮操作
   func didCheckCentralAir(_ isHidden:Bool/*, CentralAirElectricListFoot:Int*/) {
    //self.m_nCentralAirListFoot = CentralAirElectricListFoot
    if isHidden == false {
            print("空调被选中")
        }else{
            print("空调未被选中")
        }
    }
    func GetString() ->String{
        var str:String!
         var codes3:Int = 0
        var codes6:Int = 0
        for i in 0...m_codescount-1 {
            print(m_codes[i])
            let codes1:String = (m_codes[i] as NSString).substring(with: NSMakeRange(i, 1))
            let codes2:String = (m_codes[i] as NSString).substring(with: NSMakeRange(i+2, 1))
            codes3 += 16*(Int(codes1)!+Int(codes2)!)
            print(codes3)
        }
        for i in 0...m_codescount-1 {
            let codes4:String = (m_codes[i] as NSString).substring(with: NSMakeRange(i+1, 1))
            let codes5:String = (m_codes[i] as NSString).substring(with: NSMakeRange(i+3, 1))
            codes6 += Int(codes4)!+Int(codes5)!
            print(codes6)
        }
        
        if m_codescount == 0{
            ShowNoticeDispatch("提示", content: "您未添加任何中央空调", duration: 0.8)
        }
        if m_codescount == 1{
            print(codes3+codes6)
           var sum:Int = codes3+codes6+83
            var check:String = Check(sum: sum)
//            if (sum)>255{
//                sum = sum - 255
//            }

            let sArray:[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
           // str = "01500101" + m_codes[0] + sArray[check1] + sArray[check2]
            print(str)

        }else{
        }
        
        return str
    }
    func Check(sum:Int)->String{
        let check1 = String(format: "%0X", sum)
        let check2 = (check1 as NSString).substring(with: NSMakeRange(0, 8))

        return ""
        
        }
        
    
    func RefreshElectricStates(){
        RefreshState()
    }
    func RefreshState(){
        
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


