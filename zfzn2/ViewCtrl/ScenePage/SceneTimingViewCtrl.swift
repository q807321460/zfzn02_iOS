//
//  SceneTimingViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/1/10.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class SceneTimingViewCtrl: UIViewController, THDatePickerViewDelegate {

    var m_nSceneListFoot:Int = -1
    var m_nSceneIndex:Int = -1
    var m_dateView:THDatePickerView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_dateView = THDatePickerView.init(frame: CGRect.init(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300))
        m_dateView?.delegate = self
        m_dateView?.title = "请选择时间"
        self.view.addSubview(m_dateView!)
        m_dateView?.show()
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
    
    //pragma mark - THDatePickerViewDelegate
    /**
     保存按钮代理方法
     @param timer 选择的数据
     */
    func datePickerViewSaveBtnClick(_ timer: String!) {
        print("选择的时间是：" + timer)
        UIView.animate(withDuration: 0.3, animations: {
            self.m_dateView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
    /**
     取消按钮代理方法
     */
    func datePickerViewCancelBtnClick() {
        print("取消点击")
        UIView.animate(withDuration: 0.3, animations: {
            self.m_dateView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        })
    }
    
}
