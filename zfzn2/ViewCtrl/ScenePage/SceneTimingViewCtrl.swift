//
//  SceneTimingViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/1/10.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class SceneTimingViewCtrl: UIViewController, THDatePickerViewDelegate, THTimePickerViewDelegate {
    
    @IBOutlet weak var m_labelTimingType: UILabel!
    @IBOutlet weak var m_labelTimingInfo: UILabel!
    @IBOutlet weak var m_labelTimingSelected: UILabel!
    @IBOutlet weak var m_btnDetailTiming: UIButton!
    @IBOutlet weak var m_btnDaliyTiming: UIButton!
    @IBOutlet weak var m_imageDay1: UIImageView!
    @IBOutlet weak var m_imageDay2: UIImageView!
    @IBOutlet weak var m_imageDay3: UIImageView!
    @IBOutlet weak var m_imageDay4: UIImageView!
    @IBOutlet weak var m_imageDay5: UIImageView!
    @IBOutlet weak var m_imageDay6: UIImageView!
    @IBOutlet weak var m_imageDay7: UIImageView!
    @IBOutlet weak var m_viewDay1: UIView!
    @IBOutlet weak var m_viewDay2: UIView!
    @IBOutlet weak var m_viewDay3: UIView!
    @IBOutlet weak var m_viewDay4: UIView!
    @IBOutlet weak var m_viewDay5: UIView!
    @IBOutlet weak var m_viewDay6: UIView!
    @IBOutlet weak var m_viewDay7: UIView!
    @IBOutlet weak var m_btnSave: UIButton!
    @IBOutlet weak var m_btnDelete: UIButton!
    @IBOutlet weak var m_layoutW1: NSLayoutConstraint!
    @IBOutlet weak var m_layoutW2: NSLayoutConstraint!
    @IBOutlet weak var m_layoutW3: NSLayoutConstraint!
    
    let DETAIL_TIMING:Int = 0
    let DALIY_TIMING:Int = 1
    let NO_TIMING:Int = 2
    
    var m_nSceneListFoot:Int = -1
    var m_nSceneIndex:Int = -1
    var m_datePicker:THDatePickerView? = nil
    var m_timePicker:THTimePickerView? = nil
    var m_bUpdate:Bool = false
    var m_weeklyDayList = [Int]()
    let m_arrayWeeklyDayInfo = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (self.view.frame.width - 18*2 - 70*4) / 3
        m_layoutW1.constant = width
        m_layoutW2.constant = width
        m_layoutW3.constant = width
        m_labelTimingSelected.isHidden = true
        if (gDC.mSceneList[m_nSceneListFoot].m_sDetailTiming == "" && gDC.mSceneList[m_nSceneListFoot].m_sDaliyTiming == "") {
            RefreshControls(type: NO_TIMING)
        } else if (gDC.mSceneList[m_nSceneListFoot].m_sWeeklyDays != "") {
            RefreshControls(type: DALIY_TIMING)
        } else {
            RefreshControls(type: DETAIL_TIMING)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnBack(_ sender: Any) {
        if (m_bUpdate == true) {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("确定", action: {
                () -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            alertView.showInfo("提示", subTitle: "当前改动还没有保存下来，请问是否直接退出？", duration: 0)
        } else {
           self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func OnSave(_ sender: Any) {
        // 调用远程接口 // 如果成功的话，才执行后面这些指令
        if (m_labelTimingSelected.text?.count == 8) {
            // 生成weeklyDays
            let sWeeklyDays = CreateWeeklyDays()
            if (sWeeklyDays == "[]") {
                ShowNoticeDispatch("错误", content: "请选中一个或多个星期值", duration: 0.8)
                return
            }
            let re = MyWebService.sharedInstance.UpdateSceneDaliyTiming(masterCode: gDC.mUserInfo.m_sMasterCode, sceneIndex: gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex, weeklyDays: sWeeklyDays, daliyTiming: m_labelTimingSelected.text!)
            WebUpdateSceneTiming(re, sceneFoot: m_nSceneListFoot, Timing: m_labelTimingSelected.text!, weeklyDays: sWeeklyDays)
        } else if (m_labelTimingSelected.text?.count == 19) {
            let re = MyWebService.sharedInstance.UpdateSceneDetailTiming(masterCode: gDC.mUserInfo.m_sMasterCode, sceneIndex: gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex, detailTiming: m_labelTimingSelected.text!)
            WebUpdateSceneTiming(re, sceneFoot: m_nSceneListFoot, Timing: m_labelTimingSelected.text!, weeklyDays: "")
        }
    }
    
    @IBAction func OnDelete(_ sender: Any) {
        let re = MyWebService.sharedInstance.DeleteSceneTiming(masterCode: gDC.mUserInfo.m_sMasterCode, sceneIndex: gDC.mSceneList[m_nSceneListFoot].m_nSceneIndex)
        WebUpdateSceneTiming(re, sceneFoot: m_nSceneListFoot, Timing: "", weeklyDays: "")
    }
    
    @IBAction func OnDay1(_ sender: Any) {
        m_imageDay1.isHidden = !m_imageDay1.isHidden
    }
    @IBAction func OnDay2(_ sender: Any) {
        m_imageDay2.isHidden = !m_imageDay2.isHidden
    }
    @IBAction func OnDay3(_ sender: Any) {
        m_imageDay3.isHidden = !m_imageDay3.isHidden
    }
    @IBAction func OnDay4(_ sender: Any) {
        m_imageDay4.isHidden = !m_imageDay4.isHidden
    }
    @IBAction func OnDay5(_ sender: Any) {
        m_imageDay5.isHidden = !m_imageDay5.isHidden
    }
    @IBAction func OnDay6(_ sender: Any) {
        m_imageDay6.isHidden = !m_imageDay6.isHidden
    }
    @IBAction func OnDay7(_ sender: Any) {
        m_imageDay7.isHidden = !m_imageDay7.isHidden
    }
    
    @IBAction func OnDetailTiming(_ sender: Any) {
        if (m_bUpdate) {
            return
        }
        m_btnDetailTiming.isHidden = true
        m_btnDaliyTiming.isHidden = true
        m_btnSave.isHidden = false
        m_btnDelete.isHidden = true
        m_labelTimingSelected.isHidden = false
        m_bUpdate = true
        if (m_datePicker == nil) {
            m_datePicker = THDatePickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300))
            m_datePicker?.delegate = self
            m_datePicker?.title = "请选择时间"
            self.view.addSubview(m_datePicker!)
            m_datePicker?.show()
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.m_datePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300)
            })
        }
    }
    
    @IBAction func OnWeekdaysTiming(_ sender: Any) {
        if (m_bUpdate) {
            return
        }
        ShowWeeklyDays()
        m_btnDetailTiming.isHidden = true
        m_btnDaliyTiming.isHidden = true
        m_btnSave.isHidden = false
        m_btnDelete.isHidden = true
        m_labelTimingSelected.isHidden = false
        m_bUpdate = true
        if (m_timePicker == nil) {
            m_timePicker = THTimePickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300))
            m_timePicker?.delegate = self
            m_timePicker?.title = "请选择时间"
            self.view.addSubview(m_timePicker!)
            m_timePicker?.show()
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.m_timePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300)
            })
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    // 显示所有的星期控件
    func ShowWeeklyDays() {
        m_viewDay1.isHidden = false
        m_viewDay2.isHidden = false
        m_viewDay3.isHidden = false
        m_viewDay4.isHidden = false
        m_viewDay5.isHidden = false
        m_viewDay6.isHidden = false
        m_viewDay7.isHidden = false
    }
    
    // 隐藏所有的星期控件
    func HideWeeklyDays() {
        m_viewDay1.isHidden = true
        m_viewDay2.isHidden = true
        m_viewDay3.isHidden = true
        m_viewDay4.isHidden = true
        m_viewDay5.isHidden = true
        m_viewDay6.isHidden = true
        m_viewDay7.isHidden = true
    }
    
    // 根据当前的星期，刷新check图标的显示
    func RefreshControls(type:Int) {
        if (type == DETAIL_TIMING) {
            m_labelTimingType.text = "单次定时"
            m_labelTimingInfo.text = gDC.mSceneList[m_nSceneListFoot].m_sDetailTiming
            m_btnDelete.isHidden = false
        } else if (type == DALIY_TIMING) {
            m_labelTimingType.text = "循环定时"
            var json:JSON!
            let sWeeklyDay = gDC.mSceneList[m_nSceneListFoot].m_sWeeklyDays
            if let jsonData = sWeeklyDay.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do { json = try JSON(data: jsonData) }
                catch { print("json error"); return; }
                m_weeklyDayList = json.arrayObject as! [Int]
            }
            var sInfo = gDC.mSceneList[m_nSceneListFoot].m_sDaliyTiming + "  "
            for i in 1..<8 {
                ShowCheckImage(day: i, selected: false)
            }
            for i in 0..<m_weeklyDayList.count {
                ShowCheckImage(day: m_weeklyDayList[i], selected: true)
                sInfo = sInfo + m_arrayWeeklyDayInfo[m_weeklyDayList[i] - 1] + " "
            }
            m_labelTimingInfo.text = sInfo
            m_btnDelete.isHidden = false
        } else {
            m_labelTimingType.text = "无定时"
            m_labelTimingInfo.text = ""
            m_btnDelete.isHidden = true
        }
        HideWeeklyDays()
        m_btnDetailTiming.isHidden = false
        m_btnDaliyTiming.isHidden = false
        m_btnSave.isHidden = true
        m_labelTimingSelected.isHidden = true
        m_bUpdate = false
    }
    
    func ShowCheckImage(day:Int, selected:Bool) {
        switch day {
        case 1:
            m_imageDay1.isHidden = !selected
        case 2:
            m_imageDay2.isHidden = !selected
        case 3:
            m_imageDay3.isHidden = !selected
        case 4:
            m_imageDay4.isHidden = !selected
        case 5:
            m_imageDay5.isHidden = !selected
        case 6:
            m_imageDay6.isHidden = !selected
        case 7:
            m_imageDay7.isHidden = !selected
        default:
            break
        }
    }
    
    func CreateWeeklyDays() -> String {
        var arrayDays = [Int]()
        if (m_imageDay1.isHidden == false) {
            arrayDays.append(1)
        }
        if (m_imageDay2.isHidden == false) {
            arrayDays.append(2)
        }
        if (m_imageDay3.isHidden == false) {
            arrayDays.append(3)
        }
        if (m_imageDay4.isHidden == false) {
            arrayDays.append(4)
        }
        if (m_imageDay5.isHidden == false) {
            arrayDays.append(5)
        }
        if (m_imageDay6.isHidden == false) {
            arrayDays.append(6)
        }
        if (m_imageDay7.isHidden == false) {
            arrayDays.append(7)
        }
        var sWeeklyDay:String = "["
        for i in 0..<arrayDays.count - 1 {
            sWeeklyDay = sWeeklyDay + String(arrayDays[i]) + ","
        }
        sWeeklyDay = sWeeklyDay + String(arrayDays[arrayDays.count - 1]) + "]"
        return sWeeklyDay
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //pragma mark - THDatePickerViewDelegate
    /**
     保存按钮代理方法
     @param timer 选择的数据
     */
    func datePickerViewSaveBtnClick(_ timer: String!) {
        m_labelTimingSelected.text = timer
        UIView.animate(withDuration: 0.3, animations: {
            self.m_datePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    /**
     取消按钮代理方法
     */
    func datePickerViewCancelBtnClick() {
        UIView.animate(withDuration: 0.3, animations: {
            self.m_datePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    /**
     保存按钮代理方法
     @param timer 选择的数据
     */
    func timePickerViewSaveBtnClick(_ timer: String!) {
        m_labelTimingSelected.text = timer
        UIView.animate(withDuration: 0.3, animations: {
            self.m_timePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    /**
     取消按钮代理方法
     */
    func timePickerViewCancelBtnClick() {
        UIView.animate(withDuration: 0.3, animations: {
            self.m_timePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateSceneTiming(_ re:String, sceneFoot:Int, Timing:String, weeklyDays:String) {
        switch re{
        case "WebError":
            break
        case "0":
            ShowNoticeDispatch("错误", content: "主机与服务器的连接有误，情景定时更新失败", duration: 0.8)
        case "1":
            gDC.mSceneData.UpdateSceneTiming(sceneFoot: sceneFoot, Timing: Timing, weeklyDays: weeklyDays)
            if (Timing == "" && weeklyDays == "") {
                RefreshControls(type: NO_TIMING)
            } else if (weeklyDays != "") {
                RefreshControls(type: DALIY_TIMING)
            } else {
                RefreshControls(type: DETAIL_TIMING)
            }
            ShowInfoDispatch("提示", content: "情景定时更新成功", duration: 0.5)
        default:
            ShowNoticeDispatch("错误", content: "情景定时更新失败", duration: 0.5)
            break
        }
    }
    
}
