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
        print("向内存中写入account数据")
        //返回空的话，说明本地的数据是最新的，则不用同步，直接读取本地数据库中的数据
        if dicts.count == 0 {
            let dictQuery:NSMutableDictionary = ["account_code":gDC.mAccountInfo.m_sAccountCode]
            let sqlResult = gMySqlClass.QuerySql(dictQuery, table: "accounts")
            if (sqlResult[0]["account_phone"] != nil) {
                gDC.mAccountInfo.m_sAccountPhone = sqlResult[0]["account_phone"] as! String
            }
            if (sqlResult[0]["account_name"] != nil) {
                gDC.mAccountInfo.m_sAccountName = sqlResult[0]["account_name"] as! String
            }
            if (sqlResult[0]["account_address"] != nil) {
                gDC.mAccountInfo.m_sAccountAddress = sqlResult[0]["account_address"] as! String
            }
            if (sqlResult[0]["account_email"] != nil) {
                gDC.mAccountInfo.m_sAccountEmail = sqlResult[0]["account_email"] as! String
            }
            if (sqlResult[0]["password"] != nil) {
                gDC.mAccountInfo.m_sAccountPassword = sqlResult[0]["password"] as! String
            }
            //从本地文件加载图像
            let imageFullPath:String = GetFileFullPath("account_head/", fileName: "\(gDC.mAccountInfo.m_sAccountCode).png")
            let fileManager:FileManager = FileManager.default
            if fileManager.fileExists(atPath: imageFullPath) {//判断文件是否存在
                gDC.mAccountInfo.m_imageAccountHead = UIImage(contentsOfFile: imageFullPath)!
            }else {//正常应该进不来.
                SaveImage(UIImage(named: "首页_用户logo.png")!, newSize: CGSize(width: 128, height: 128), percent: 0.5, imagePath: "account_head/", imageName: "\(gDC.mAccountInfo.m_sAccountCode).png")
                gDC.mAccountInfo.m_imageAccountHead = UIImage(named: "首页_用户logo.png")
            }
            return
        }
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
        //将这些数据写入到数据库中
        let dictRequired = NSMutableDictionary()
        dictRequired.setObject(gDC.mAccountInfo.m_sAccountCode, forKey: "account_code" as NSCopying)
        let dictSet = NSMutableDictionary()
        dictSet.setObject(gDC.mAccountInfo.m_sAccountName, forKey: "account_name" as NSCopying)
        dictSet.setObject(gDC.mAccountInfo.m_sAccountPhone, forKey: "account_phone" as NSCopying)
        dictSet.setObject(gDC.mAccountInfo.m_sAccountAddress, forKey: "account_address" as NSCopying)
        dictSet.setObject(gDC.mAccountInfo.m_sAccountEmail, forKey: "account_email" as NSCopying)
        dictSet.setObject(gDC.mAccountInfo.m_sTimeAccount , forKey: "account_time" as NSCopying)
        dictSet.setObject(gDC.mAccountInfo.m_sAccountPassword , forKey: "password" as NSCopying)
        dictSet.setObject(gDC.mAccountInfo.m_sTimeSign, forKey: "sign_time" as NSCopying)
        dictSet.setObject(gDC.mAccountInfo.m_sTimeUser, forKey: "user_time" as NSCopying)
        gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "accounts")
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
        //修改本地数据库
        let dictSet:NSMutableDictionary = ["password":passwordNew]
        let dictRequired:NSMutableDictionary = ["account_code":gDC.mAccountInfo.m_sAccountCode]
        gMySqlClass.UpdateSql(dictSet, requiredData: dictRequired, table: "accounts")
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
