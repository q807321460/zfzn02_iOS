//
//  ElecDoubleSwitchViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/5/24.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecDoubleSwitchViewCtrl: ElecSuperViewCtrl {
    
    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_lableBingdingName: UILabel!
    @IBOutlet weak var m_buttonclear: UIButton!
    var m_newAreaListFoot1:Int!
    var m_newElectricListFoot1:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricName
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "01" {
            m_imageElectricType.image = UIImage(named: "电器_双控开关_左")
        }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "02" {
            m_imageElectricType.image = UIImage(named: "电器_双控开关_中")
        }else if gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo == "03" {
            m_imageElectricType.image = UIImage(named: "电器_双控开关_右")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        RefreshState()
    }
 
    @IBAction func Onback(_ sender: UIBarButtonItem) {
          self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddBinding(_ sender: UIButton) {//添加绑定开关
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "bindingSwitch") as! BindingSwitch
        nextView.m_nAreaListFoot = m_nAreaListFoot
        nextView.m_nElectricListFoot = m_nElectricListFoot
        nextView.m_sElectricOrder = m_sElectricOrder
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    @IBAction func ClearBinding(_ sender: UIButton) {
        m_sElectricOrder = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sOrderInfo + gDC.mAreaList[m_newAreaListFoot1].mElectricList[m_newElectricListFoot1].m_sElectricCode +
            "XH" + gDC.mAreaList[m_newAreaListFoot1].mElectricList[m_newElectricListFoot1].m_sOrderInfo
        MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sElectricCode, order:gDC.m_sCentralAir+gDC.m_sStateClear, orderInfo:m_sElectricOrder)
        let masterCode:String = gDC.mUserInfo.m_sMasterCode
        let electricIndex:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex
        let webResult:String = MyWebService.sharedInstance.DeleteDuplexSwift(masterCode:masterCode,electricIndex:electricIndex)
        WebdeleteDuplexSwift(responseValue:webResult)
    }
    func WebdeleteDuplexSwift(responseValue:String){
        switch responseValue {
        case "WebError":
            break
        case "1":
            ShowInfoDispatch("提示", content: "解除绑定成功", duration: 0.8)
            gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras = ""
            RefreshState()
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func RefreshState() {
        let m_name:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras
        if m_name != ""{
            var roomindex:Int!
            var elecindex:Int!
            var roomname:String!
            var elecname:String!
            for i in 0..<m_name.count{
                let codes:String = (m_name as NSString).substring(with: NSMakeRange(i, 1))
                if codes == "-"{
                    roomindex = Int((m_name as NSString).substring(with: NSMakeRange(0, i)))
                    elecindex = Int((m_name as NSString).substring(with: NSMakeRange(i+1, m_name.count-i-1)))
                    break
                }
            }
            for i in 0..<gDC.mAreaList.count {
                if gDC.mAreaList[i].m_nAreaIndex == roomindex {
                    roomname = gDC.mAreaList[i].m_sAreaName
                    m_newAreaListFoot1 = i
                    break
                }
            }
            for i in 0..<gDC.mAreaList[m_newAreaListFoot1].mElectricList.count {
                if gDC.mAreaList[m_newAreaListFoot1].mElectricList[i].m_nElectricIndex == elecindex {
                    elecname = gDC.mAreaList[m_newAreaListFoot1].mElectricList[i].m_sElectricName
                    m_newElectricListFoot1 = i
                    break
                }
            }
            m_lableBingdingName.text = "双控开关已绑定：" + roomname + "_" + elecname
            m_buttonclear.isHidden = false
        }
        else{
            m_buttonclear.isHidden = true
            m_lableBingdingName.text = "未绑定任何开关，请添加"
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
