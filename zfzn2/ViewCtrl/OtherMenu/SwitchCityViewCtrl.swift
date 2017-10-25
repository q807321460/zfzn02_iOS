//
//  SwitchCityViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/4/12.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.

import UIKit

class SwitchCityViewCtrl: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var m_pickerCity: UIPickerView!
    var mProvinceList = NSMutableArray()
    var mCityLists = [NSMutableArray]()
    var mCityList = NSMutableArray()
    var m_sProvinceName:String!
    var m_sCityName:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        m_pickerCity.tintColor = gDC.m_colorPurple
        //获取沙盒中的plist数据并读取
        let sFilePath:String = DataFilePath("address.plist")
        let arrayAll = NSMutableArray.init(contentsOfFile: sFilePath)!
        for i in 0..<arrayAll.count {
            let dict = arrayAll[i] as! NSDictionary
            mProvinceList.add(dict["provinceName"]! as! String)
            let arrayCity = dict["cityList"]! as! NSMutableArray
            mCityLists.append(arrayCity)
        }
        m_sProvinceName = gDC.m_sProvinceName
        for i in 0..<mProvinceList.count {
            if mProvinceList[i] as! String == gDC.m_sProvinceName {
                m_pickerCity.selectRow(i, inComponent: 0, animated: true)
                mCityList = mCityLists[i]
                m_pickerCity.reloadComponent(1)
                break
            }
        }
        m_sCityName = gDC.m_sCityName
        for i in 0..<mCityList.count {
            if mCityList[i] as! String == gDC.m_sCityName {
                m_pickerCity.selectRow(i, inComponent: 1, animated: true)
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func OnSave(_ sender: AnyObject) {
        let filePathAccount = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
        let dictAccountPlist = NSMutableDictionary.init(contentsOfFile: filePathAccount)//根据plist文件路径读取到数据字典
        dictAccountPlist?.setObject(m_sProvinceName, forKey: "province" as NSCopying)
        dictAccountPlist?.setObject(m_sCityName, forKey: "city" as NSCopying)
        gDC.m_sProvinceName = m_sProvinceName
        gDC.m_sCityName = m_sCityName
        dictAccountPlist!.write(toFile: filePathAccount, atomically: true)
        gDC.m_bFirstGetWeather = true//需要重新第一次获取天气
        self.navigationController?.popViewController(animated: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return mProvinceList.count
        }else {
            return mCityList.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return mProvinceList[row] as? String
        }else {
            return mCityList[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            mCityList = mCityLists[row]
            m_sProvinceName = mProvinceList[row] as! String
            m_pickerCity.selectRow(0, inComponent: 1, animated: true)//重置为该省份的第一个城市
            m_sCityName = mCityList[0] as! String//默认为第一个城市
            pickerView.reloadComponent(1)
        }else {
            m_sCityName = mCityList[row] as! String
        }
    }
    
}




