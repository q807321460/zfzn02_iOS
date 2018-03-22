//
//  AccountData.swift
//  zfzn
//
//  Created by Hanwen Kong on 16/8/25.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import Foundation

//专门写函数的类
class AccountData: NSObject {
    func UpdateAccount(_ dicts:[NSDictionary]) {
        let dict:NSDictionary = dicts[0]//最多只有一组数据
        let accountInfo = AccountInfoData()//保证切换账号时数据的正确性
        //空的数据，web不会传下来，所以最好每个数据都进行判断
        if (dict.object(forKey: "accountCode") != nil) {
            accountInfo.m_sAccountCode = dict["accountCode"] as! String
        }
        if (dict.object(forKey: "accountName") != nil) {
            accountInfo.m_sAccountName = dict["accountName"] as! String
        }
        if (dict.object(forKey: "accountPhone") != nil) {
            accountInfo.m_sAccountPhone = dict["accountPhone"] as! String
        }
        if (dict.object(forKey: "accountAddress") != nil) {
            accountInfo.m_sAccountAddress = dict["accountAddress"] as! String
        }
        if (dict.object(forKey: "accountEmail") != nil) {
            accountInfo.m_sAccountEmail = dict["accountEmail"] as! String
        }
        if (dict.object(forKey: "password") != nil) {
            accountInfo.m_sAccountPassword = dict["password"] as! String
        }
        if (dict.object(forKey: "accountTime") != nil) {
            accountInfo.m_sTimeAccount = dict["accountTime"] as! String
        }
        if (dict.object(forKey: "signTime") != nil) {
            accountInfo.m_sTimeSign = dict["signTime"] as! String
        }
        if (dict.object(forKey: "userTime") != nil) {
            accountInfo.m_sTimeUser = dict["userTime"] as! String
        }
        if (dict.object(forKey: "photo") != nil) {
            let nPhoto = dict["photo"] as! String
            accountInfo.m_imageAccountHead = Base64StringToUIImage(nPhoto)
            SaveImage(accountInfo.m_imageAccountHead, newSize: CGSize(width: 128, height: 128), percent: 0.5, imagePath: "account_head/", imageName: "\(accountInfo.m_sAccountCode).png")
        }
        gDC.mAccountInfo = accountInfo
    }

    //更新分享账户列表
    func UpdateSharedAccount(_ dicts:[NSDictionary]) {
        gDC.mSharedAccountList.removeAll()
        for dict in dicts {
            let sharedAccount = AccountInfoData()//用于向内存数据中写入
            if (dict.object(forKey: "accountCode") != nil) {
                sharedAccount.m_sAccountCode = dict["accountCode"] as! String
            }
            if (dict.object(forKey: "accountName") != nil) {
                sharedAccount.m_sAccountName = dict["accountName"] as! String
            }
            if (dict.object(forKey: "accountPhone") != nil) {
                sharedAccount.m_sAccountPhone = dict["accountPhone"] as! String
            }
            if (dict.object(forKey: "accountAddress") != nil) {
                sharedAccount.m_sAccountAddress = dict["accountAddress"] as! String
            }
            if (dict.object(forKey: "accountEmail") != nil) {
                sharedAccount.m_sAccountEmail = dict["accountEmail"] as! String
            }
            if (dict.object(forKey: "password") != nil) {
                sharedAccount.m_sAccountPassword = dict["password"] as! String
            }
            if (dict.object(forKey: "accountTime") != nil) {
                sharedAccount.m_sTimeAccount = dict["accountTime"] as! String
            }
            if (dict.object(forKey: "signTime") != nil) {
                sharedAccount.m_sTimeSign = dict["signTime"] as! String
            }
            if (dict.object(forKey: "userTime") != nil) {
                sharedAccount.m_sTimeUser = dict["userTime"] as! String
            }
            if (dict.object(forKey: "photo") != nil) {
                let nPhoto = dict["photo"] as! String
                sharedAccount.m_imageAccountHead = Base64StringToUIImage(nPhoto)
                SaveImage(sharedAccount.m_imageAccountHead, newSize: CGSize(width: 128, height: 128), percent: 0.5, imagePath: "account_head/", imageName: "\(sharedAccount.m_sAccountCode).png")
            }
            gDC.mSharedAccountList.append(sharedAccount)
        }
    }
    
    func UpdateAccountPassword(_ passwordNew:String) {
        //修改plist文件中的密码
        let fullPath = GetFileFullPath("account_setting/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).plist")
        let dict = NSMutableDictionary.init(contentsOfFile: fullPath)
        dict?.setObject(false, forKey: "is_remember_password" as NSCopying)//下次登录需要重新输入密码
        dict?.setObject(passwordNew, forKey: "password" as NSCopying)
        dict?.write(toFile: fullPath, atomically: true)
    }
}

//专门存数据的类
class AccountInfoData:NSObject{
    var m_sAccountCode:String = ""
    var m_sAccountName:String = ""
    var m_sAccountPhone:String = ""//理论上和code是一样的
    var m_sAccountAddress:String = ""
    var m_sAccountEmail:String = ""
    var m_sAccountPassword:String = ""
    var m_imageAccountHead:UIImage!
    var m_sTimeSign:String = ""//记录为时间戳格式?
    var m_sTimeAccount:String = ""
    var m_sTimeUser:String = ""
    var m_sTimeSceneElectric:String = ""
    var m_sLastMasterCode:String = ""
    override init() {}
}
