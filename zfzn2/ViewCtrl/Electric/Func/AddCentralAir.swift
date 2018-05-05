//
//  AddCentralAir.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/3/16.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class AddCentralAir: UIViewController {
    @IBOutlet weak var m_eRoomname: UITextField!
    @IBOutlet weak var m_eOutaddress: UITextField!
    @IBOutlet weak var m_eInsddress: UITextField!
    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
    var mCentralAirList = [ElecCentralAirData]()
    var m_codesdictionary:[String:String] = [ : ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Onback(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AddCentralAir(_ sender: Any) {
        if m_eInsddress.text!.count != 2 || m_eOutaddress.text!.count != 2{
            ShowNoticeDispatch("提示", content: "地址输入错误", duration: 0.8)
        }else{
            if !TestInput(text: m_eOutaddress){
              ShowNoticeDispatch("提示", content: "地址输入错误", duration: 0.8)
            }else{
                if !TestInput(text: m_eInsddress){
                 ShowNoticeDispatch("提示", content: "地址输入错误", duration: 0.8)
                }else{
                  let airCode:String = m_eOutaddress.text! + m_eInsddress.text!
                  var value:Bool = false
                  for i in 0..<mCentralAirList.count{
                        if airCode == mCentralAirList[i].m_CentralAircodes{
                        value = true
                        }
                      }
                 if value {
                  ShowNoticeDispatch("提示", content: "该地址已存在", duration: 0.8)
                 }else{
                  let airName:String = m_eRoomname.text!
                  let masterCode:String = gDC.mUserInfo.m_sMasterCode
                  let electricIndex:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex
                  let webResult:String = MyWebService.sharedInstance.AddCentralAir(masterCode:masterCode,electricIndex:electricIndex,airCode:airCode,airName:airName)
                    WebAddCentralAir(responseValue: webResult,airname: airName,aircode: airCode)
                     }
                  }
              }
          }
    }
    
    func WebAddCentralAir(responseValue:String,airname:String,aircode:String){      //从服务器端得到反馈
        switch responseValue {
        case "WebError":
            break
        case "1":
            ShowInfoDispatch("提示", content: "添加空调成功", duration: 0.8)
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
            m_codesdictionary.updateValue(airname, forKey: aircode)
            json1 = JSON(object: m_codesdictionary)
            let sJson1:String = json1.rawString() ?? "{}"
            gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras = sJson1
        default:
            break
        }
    }
    
    func TestInput(text:UITextField) -> Bool{      //判断地址输入是否为2位十六进制数
        let text:UITextField = text
        let s0:String = (text.text! as NSString).substring(with: NSMakeRange(0, 1))
        let s1:String = (text.text! as NSString).substring(with: NSMakeRange(1, 1))
        let Array:[String] = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
        var i:Int = 0
        var j:Int = 0
        var value:Bool = false
        while i<16 {
            if s0 == Array[i]{
                while j<16 {
                    if s1 == Array[j]{
                        value = true
                    }
                    j = j+1
                }
            }
            i = i+1
        }
        return value
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


