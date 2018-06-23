//
//  AddElectricViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/20.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class AddElectricViewCtrl: UIViewController {
    @IBOutlet weak var m_imageElectricType: UIImageView!
    @IBOutlet weak var m_labelElectricType: UILabel!
    @IBOutlet weak var m_imageArea: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_labelElectricName: UILabel!
    @IBOutlet weak var m_eElectricName: UITextField!
    //备用的ui控件
    @IBOutlet weak var m_labelElectricName2:UILabel!
    @IBOutlet weak var m_labelElectricName3:UILabel!
    @IBOutlet weak var m_labelElectricName4:UILabel!
    @IBOutlet weak var m_eElectricName2:UITextField!
    @IBOutlet weak var m_eElectricName3:UITextField!
    @IBOutlet weak var m_eElectricName4:UITextField!
    @IBOutlet weak var m_constraintSave: NSLayoutConstraint!
    
    @IBOutlet weak var m_btnSave: UIButton!
    
    var m_nAreaListFoot:Int!
    var m_nElectricType:Int!
    var m_nAreaIndex:Int!
    var m_appearSearching = SCLAlertView.SCLAppearance(showCloseButton: false)
    var m_viewSearching:SCLAlertView! = nil
    var m_nIndexMax:Int! = 0
    var m_sElectricCode:String!// = "01001BDA"
    var keyBoardNeedLayout: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        m_labelElectricName2.isHidden = true
        m_labelElectricName3.isHidden = true
        m_labelElectricName4.isHidden = true
        m_eElectricName2.isHidden = true
        m_eElectricName3.isHidden = true
        m_eElectricName4.isHidden = true
        m_constraintSave.constant = 30.0
        switch m_nElectricType {
        case 2:
            m_imageElectricType.image = UIImage(named: "电器类型_两键开关")
            m_labelElectricType.text = "两键开关"
            m_labelElectricName.text = "左键："
            m_labelElectricName2.text = "右键："
            m_labelElectricName2.isHidden = false
            m_eElectricName2.isHidden = false
            m_constraintSave.constant = 30.0 + 36.0
        case 3:
            m_imageElectricType.image = UIImage(named: "电器类型_三键开关")
            m_labelElectricType.text = "三键开关"
            m_labelElectricName.text = "左键："
            m_labelElectricName2.text = "中键："
            m_labelElectricName3.text = "右键："
            m_labelElectricName2.isHidden = false
            m_labelElectricName3.isHidden = false
            m_eElectricName2.isHidden = false
            m_eElectricName3.isHidden = false
            m_constraintSave.constant = 30.0 + 36.0 + 36.0
        case 4, 10:
            m_imageElectricType.image = UIImage(named: "电器类型_四键开关")
            if (m_nElectricType==4) {
                m_labelElectricType.text = "四键开关"
            }else {
                m_labelElectricType.text = "情景开关"
            }
            m_labelElectricName.text = "左上键："
            m_labelElectricName2.text = "右上键："
            m_labelElectricName3.text = "左下键："
            m_labelElectricName4.text = "右下键："
            m_labelElectricName2.isHidden = false
            m_labelElectricName3.isHidden = false
            m_labelElectricName4.isHidden = false
            m_eElectricName2.isHidden = false
            m_eElectricName3.isHidden = false
            m_eElectricName4.isHidden = false
            m_constraintSave.constant = 30.0 + 36.0 + 36.0 + 36.0
        case 27:
            m_imageElectricType.image = UIImage(named: "电器类型_双控开关")
            m_labelElectricType.text = "双控开关"
            m_labelElectricName.text = "左键："
            m_labelElectricName2.text = "中键："
            m_labelElectricName3.text = "右键："
            m_labelElectricName2.isHidden = false
            m_labelElectricName3.isHidden = false
            m_eElectricName2.isHidden = false
            m_eElectricName3.isHidden = false
            m_constraintSave.constant = 30.0 + 36.0 + 36.0
        default:
            m_imageElectricType.image = UIImage(named: gDC.m_arrayElectricImage[m_nElectricType] as! String)
            m_labelElectricType.text = gDC.m_arrayElectricLabel[m_nElectricType] as? String
            m_constraintSave.constant = 30.0
            break
        }
        m_btnSave.layer.cornerRadius = 5.0
        m_btnSave.layer.masksToBounds = true
        m_imageArea.image = gDC.mAreaList[m_nAreaListFoot].m_imageArea
        m_labelAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        //当键盘弹起的时候会向系统发出一个通知
        NotificationCenter.default.addObserver(self, selector: #selector(AddElectricViewCtrl.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        //当键盘收起的时候会向系统发出一个通知
        NotificationCenter.default.addObserver(self, selector: #selector(AddElectricViewCtrl.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        g_notiCenter.addObserver(self, selector:#selector(AddElectricTypeViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSave(_ sender: UIButton) {
        self.view.endEditing(true)
        switch m_nElectricType {
        case 2:
            if m_eElectricName.text == "" || m_eElectricName2.text == "" {//判断电器名是否填写
                ShowNoticeDispatch("提示", content: "还有未输入的电器名", duration: 0.8)
                return
            }
        case 3:
            if m_eElectricName.text == "" || m_eElectricName2.text == "" || m_eElectricName3.text == "" {
                ShowNoticeDispatch("提示", content: "还有未输入的电器名", duration: 0.8)
                return
            }
        case 4, 10:
            if m_eElectricName.text == "" || m_eElectricName2.text == "" || m_eElectricName3.text == "" || m_eElectricName4.text == "" {
                ShowNoticeDispatch("提示", content: "还有未输入的电器名", duration: 0.8)
                return
            }
        default:
            if m_eElectricName.text == "" {
                ShowNoticeDispatch("提示", content: "请输入电器名", duration: 0.5)
                return
            }
        }
//        AddElectricDetail()
        DispatchQueue.main.async(execute: {
            self.m_viewSearching = SCLAlertView(appearance: self.m_appearSearching)
            self.m_viewSearching.showInfo("提示", subTitle: " 正在添加电器中......", duration: 0)
        })
        var sAddLeft:String = ""
        let sSign:String = gDC.m_arrayElectricTypeCode[m_nElectricType] as! String
        let nSignSize:Int = sSign.count
        if nSignSize == 4 {
            sAddLeft = "0000"
        }else {//nSignSize == 2
            sAddLeft = "000000"//gDC.m_sAddLeft
        }
        let electricCode = MySocket.sharedInstance.GetElectricCodeFromMaster("<\(gDC.m_arrayElectricTypeCode[m_nElectricType])\(sAddLeft)\(gDC.m_sAddSign)0**********00>")//搜索处于对码状态的电器
        self.m_viewSearching.hideView()
        //需要在这里判断electricCode是否是合法的（比如我添加传感器时对上了开关的码键，结果收到的电器code就会错误）
        if electricCode.count >= nSignSize {
            let sSign2:String = (electricCode as NSString).substring(with: NSMakeRange(0, nSignSize))
            if sSign2 != sSign {
                ShowNoticeDispatch("提示", content: "没有找到对应的电器，请确认是否对码成功", duration: 1.0)
                return
            }
        }else {
            ShowNoticeDispatch("提示", content: "没有找到对应的电器，请确认是否对码成功", duration: 1.0)
            return
        }
        //当sSign2 == sSign时，开始向服务器添加，首先判断当前主机下是否已经存在相同编号的电器，如果存在则给出提示
        let re:String = MyWebService.sharedInstance.IsExistElectric(masterCode: gDC.mUserInfo.m_sMasterCode, electricCode: electricCode)
        if (re=="1") {
            print("发现有相同编号的电器")
            DispatchQueue.main.async(execute: {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("继续", action: {
                    () -> Void in
                    //删除重复的电器
                    for i in 0..<gDC.mAreaList.count {
                        for _ in 0..<gDC.mAreaList[i].mElectricList.count {//双重循环防止数组越界
                            for j in 0..<gDC.mAreaList[i].mElectricList.count {
                                if (gDC.mAreaList[i].mElectricList[j].m_sElectricCode == electricCode) {
                                    let result:String = MyWebService.sharedInstance.DeleteElectric1(
                                        masterCode: gDC.mUserInfo.m_sMasterCode,
                                        electricCode: electricCode,
                                        electricIndex: gDC.mAreaList[i].mElectricList[j].m_nElectricIndex,
                                        electricSequ: gDC.mAreaList[i].mElectricList[j].m_nElectricSequ,
                                        roomIndex: gDC.mAreaList[i].m_nAreaIndex)
                                    if (result=="1"){
                                        gDC.mElectricData.DeleteElectric(
                                            masterCode: gDC.mUserInfo.m_sMasterCode,
                                            electricIndex: gDC.mAreaList[i].mElectricList[j].m_nElectricIndex,
                                            electricSequ: gDC.mAreaList[i].mElectricList[j].m_nElectricSequ,
                                            areaFoot: i)
                                        break//删除当前电器后一定要break，否则会导致数组越界
                                    }else {
                                       ShowNoticeDispatch("错误", content: "操作失败", duration: 1.0)
                                        return
                                    }
                                }
                            }
                        }
                    }
                    self.AddElectricDetail(electricCode)
                })
                alertView.addButton("取消", action: {
                    () -> Void in
                    return
                })
                alertView.showInfo("菜单", subTitle: "您已经添加过该电器，重复添加将自动删除之前已添加过的电器，请问是否继续添加？", duration: 0)//时间间隔为0时不会自动退出
            })
        }else {
            print("电器编号不重复，可以直接添加")
            AddElectricDetail(electricCode)
        }
    }
    
    func AddElectricDetail(_ electricCode:String) {
        var sElectricName:String!
        switch m_nElectricType {
        case 2:
            sElectricName = "\(m_eElectricName.text!),\(m_eElectricName2.text!)"
        case 3, 27:
            sElectricName = "\(m_eElectricName.text!),\(m_eElectricName2.text!),\(m_eElectricName3.text!)"
        case 4, 10:
            sElectricName = "\(m_eElectricName.text!),\(m_eElectricName2.text!),\(m_eElectricName3.text!),\(m_eElectricName4.text!)"
        default:
            sElectricName = m_eElectricName.text
        }
        let re:String = gDC.mElectricData.AddElectricToWeb(gDC.mUserInfo.m_sMasterCode, areaFoot: m_nAreaListFoot, electricCode: electricCode, electricName:sElectricName, electricType:m_nElectricType, extra:"")
        WebAddElectric(re)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebAddElectric(_ responseValue:String) {
        switch responseValue {
        case "WebError":
            break
        case "1":
            ShowInfoDispatch("提示", content: "添加成功", duration: 0.5)
            gDC.m_bRefreshAreaList = true
            self.navigationController?.popToRootViewController(animated: true)
        case "2":
            ShowNoticeDispatch("提示", content: "您已添加过该电器", duration: 0.8)
        default:
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func keyboardWillShow(_ notification: Notification) {
        print("show")
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            let deltaY = intersection.height
            if keyBoardNeedLayout {
                UIView.animate(withDuration: duration, delay: 0.0,
                                           options: UIViewAnimationOptions(rawValue: curve),
                                           animations: { _ in
                                            self.view.frame = CGRect(x: 0,y: -deltaY/2,width: self.view.bounds.width,height: self.view.bounds.height)
                                            self.keyBoardNeedLayout = false
                                            self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        print("hide")
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            let deltaY = intersection.height
            UIView.animate(withDuration: duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve),
                                       animations: { _ in
                                        self.view.frame = CGRect(x: 0,y: deltaY/2,width: self.view.bounds.width,height: self.view.bounds.height)
                                        self.keyBoardNeedLayout = true
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @IBAction func OnTouchDown(_ sender: UIControl) {
        self.view.endEditing(true)
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



