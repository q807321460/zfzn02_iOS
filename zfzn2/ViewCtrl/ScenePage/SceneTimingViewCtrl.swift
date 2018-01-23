//
//  SceneTimingViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/1/10.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class SceneTimingViewCtrl: UIViewController, THDatePickerViewDelegate, THTimePickerViewDelegate {

    @IBOutlet weak var m_imageDay1: UIImageView!
    @IBOutlet weak var m_imageDay2: UIImageView!
    @IBOutlet weak var m_imageDay3: UIImageView!
    @IBOutlet weak var m_imageDay4: UIImageView!
    @IBOutlet weak var m_imageDay5: UIImageView!
    @IBOutlet weak var m_imageDay6: UIImageView!
    @IBOutlet weak var m_imageDay7: UIImageView!
    var m_nSceneListFoot:Int = -1
    var m_nSceneIndex:Int = -1
    var m_datePicker:THDatePickerView? = nil
    var m_timePicker:THTimePickerView? = nil
//    m_switchCtrl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    override func viewDidLoad() {
        super.viewDidLoad()
        m_datePicker = THDatePickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300))
        m_datePicker?.delegate = self
        m_datePicker?.title = "请选择时间"
        self.view.addSubview(m_datePicker!)
        m_datePicker?.show()
        
        m_timePicker = THTimePickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300))
        m_timePicker?.delegate = self
        m_timePicker?.title = "请选择时间"
        self.view.addSubview(m_timePicker!)
        m_timePicker?.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnSave(_ sender: Any) {
        // 调整定时功能后，重新设置定时，这里需要根据当前是否已经存在定时来确定发送的指令格式
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
        UIView.animate(withDuration: 0.3, animations: {
            self.m_datePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300)
        })
    }
    
    @IBAction func OnWeekdaysTiming(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.m_timePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300)
        })
    }
    
    
    //pragma mark - THDatePickerViewDelegate
    /**
     保存按钮代理方法
     @param timer 选择的数据
     */
    func datePickerViewSaveBtnClick(_ timer: String!) {
        print("选择的时间是：" + timer)
        UIView.animate(withDuration: 0.3, animations: {
            self.m_datePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    /**
     取消按钮代理方法
     */
    func datePickerViewCancelBtnClick() {
        print("取消点击")
        UIView.animate(withDuration: 0.3, animations: {
            self.m_datePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    /**
     保存按钮代理方法
     @param timer 选择的数据
     */
    func timePickerViewSaveBtnClick(_ timer: String!) {
        print("选择的时间是：" + timer)
        UIView.animate(withDuration: 0.3, animations: {
            self.m_timePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    /**
     取消按钮代理方法
     */
    func timePickerViewCancelBtnClick() {
        print("取消点击")
        UIView.animate(withDuration: 0.3, animations: {
            self.m_timePicker?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
}
