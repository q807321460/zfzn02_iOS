//
//  MySqlCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/5.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//
//整和了所有的数据库执行指令，方便将来查询维护
//这个类需要写成单例吗？并没有属于这个类的变量。。。。。。

import Foundation

class MySqlCtrl: NSObject {

    //通过nsdictionary向指定的sql中添加一行数据
    func InsertIntoSql(_ insertData:NSMutableDictionary, table:String) {
        var arrayKey:NSArray!
        arrayKey = insertData.allKeys as NSArray
        var str1:String = ""
        var str2:String = ""
        for i in 0..<insertData.count {
            if i == 0 {
                str1 = str1 + "\(arrayKey[i])"
                let something = insertData.object(forKey: arrayKey[i])
                switch something {
                case _ as String:
                    str2 = str2 + "'\(something as! String)' "
                case _ as Int:
                    str2 = str2 + "\(something as! Int) "
                default:
                    break
                }
            }else{
                str1 = str1 + ",\(arrayKey[i])"
                let something = insertData.object(forKey: arrayKey[i])
                switch something {
                case _ as String:
                    str2 = str2 + ",'\(something as! String)' "
                case _ as Int:
                    str2 = str2 + ",\(something as! Int) "
                default:
                    break
                }
            }
        }
        let sql = "insert into \(table)(\(str1)) values(\(str2))"
        g_SQLiteDB.execute(sql: sql)
    }
    
    //通过nsdictionary向指定的sql中修改某行
    func UpdateSql(_ setData:NSMutableDictionary, requiredData:NSMutableDictionary, table:String) {
        var arrayKeySet:NSArray!
        var arrayKeyRequire:NSArray!
        arrayKeySet = setData.allKeys as NSArray
        arrayKeyRequire = requiredData.allKeys as NSArray
        var str1:String = ""
        var str2:String = ""
        for i in 0..<setData.count {
            if i == 0 {
                let something = setData.object(forKey: arrayKeySet[i])
                switch something {
                case _ as String:
                    str1 = str1 + "\(arrayKeySet[i]) = '\(something as! String)' "
                case _ as Int:
                    str1 = str1 + "\(arrayKeySet[i]) = \(something as! Int) "
                default:
                    break
                }
            }else{
                let something = setData.object(forKey: arrayKeySet[i])
                switch something {
                case _ as String:
                    str1 = str1 + ", \(arrayKeySet[i]) = '\(something as! String)' "
                case _ as Int:
                    str1 = str1 + ", \(arrayKeySet[i]) = \(something as! Int) "
                default:
                    break
                }
            }
        }
        for i in 0..<requiredData.count {
            if i == 0 {
                let something = requiredData.object(forKey: arrayKeyRequire[i])
                switch something {
                case _ as String:
                    str2 = str2 + "\(arrayKeyRequire[i]) = '\(something as! String)' "
                case _ as Int:
                    str2 = str2 + "\(arrayKeyRequire[i]) = \(something as! Int) "
                default:
                    break
                }
            }else{
                let something = requiredData.object(forKey: arrayKeyRequire[i])
                switch something {
                case _ as String:
                    str2 = str2 + "and \(arrayKeyRequire[i]) = '\(something as! String)' "
                case _ as Int:
                    str2 = str2 + "and \(arrayKeyRequire[i]) = \(something as! Int) "
                default:
                    break
                }
            }
        }
        var sql:String! = ""
        if str2 == "" {//说明没有条件
            sql = "update \(table) set \(str1)"
        }else {//存在条件的时候
            sql = "update \(table) set \(str1) where \(str2)"
        }
        g_SQLiteDB.execute(sql: sql)
    }
    
    func QuerySql(_ queryData:NSDictionary, table:String) -> [[String:AnyObject]] {
        var arrayKey:NSArray!
        arrayKey = queryData.allKeys as NSArray
        var str1:String = ""
        for i in 0..<queryData.count {
            if i == 0 {
                let something = queryData.object(forKey: arrayKey[i])
                switch something {
                case _ as String:
                    str1 = str1 + "\(arrayKey[i]) = '\(something as! String)' "
                case _ as Int:
                    str1 = str1 + "\(arrayKey[i]) = \(something as! Int) "
                default:
                    break
                }
            }else{
                let something = queryData.object(forKey: arrayKey[i])
                switch something {
                case _ as String:
                    str1 = str1 + "and \(arrayKey[i]) = '\(something as! String)' "
                case _ as Int:
                    str1 = str1 + "and \(arrayKey[i]) = \(something as! Int) "
                default:
                    break
                }
            }
        }
        let sql = "select * from \(table) where \(str1)"
        let result = g_SQLiteDB.query(sql: sql)
        return result as [[String : AnyObject]]
    }
    
    func DeleteSql(_ requiredData:NSMutableDictionary, table:String) {
        var arrayKey:NSArray!
        arrayKey = requiredData.allKeys as NSArray
        var str1:String = ""
        for i in 0..<requiredData.count {
            if i == 0 {
                let something = requiredData.object(forKey: arrayKey[i])
                switch something {
                case _ as String:
                    str1 = str1 + "\(arrayKey[i]) = '\(something as! String)' "
                case _ as Int:
                    str1 = str1 + "\(arrayKey[i]) = \(something as! Int) "
                default:
                    break
                }
            }else{
                let something = requiredData.object(forKey: arrayKey[i])
                switch something {
                case _ as String:
                    str1 = str1 + "and \(arrayKey[i]) = '\(something as! String)' "
                case _ as Int:
                    str1 = str1 + "and \(arrayKey[i]) = \(something as! Int) "
                default:
                    break
                }
            }
        }
        let sql = "delete from \(table) where \(str1)"
        g_SQLiteDB.query(sql: sql)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    //在这里编写有关版本更新时数据库变动的代码
    func UpdateDBConstruction() {
        var nCurrentDBVersion:Int = gDC.m_dbVersionOld
        while nCurrentDBVersion != gDC.m_dbVersion {
            switch nCurrentDBVersion {
            case 1:
                //从版本1更新到版本2
                let sql = "DROP TABLE electricshared"
                g_SQLiteDB.query(sql: sql)
                let sql2 = "CREATE TABLE electricshared (master_code varchar(50) NOT NULL, account_code varchar(11) NOT NULL, electric_code varchar(8), electric_index INTEGER NOT NULL, electric_type INTEGER NOT NULL, room_index INTEGER NOT NULL, order_info varchar(2) NOT NULL, electric_name varchar(50) NOT NULL, is_shared INTEGER NOT NULL, PRIMARY KEY(master_code, account_code, electric_index));"
                g_SQLiteDB.query(sql: sql2)
                nCurrentDBVersion = 2
            case 2:
                //从版本2更新到版本3
                let sql = "ALTER TABLE electrics ADD account_code varchar(11)"
                g_SQLiteDB.query(sql: sql)
                //将电器时间重置为空，保证下一次全部从web读取
                let setDict:NSMutableDictionary = ["electric_time": "__:__:__"]
                let requiredDict:NSMutableDictionary = [:]
                requiredDict.removeAllObjects()
                gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "users")
                //同时清空electric表中的所有数据
                let sql2 = "delete from electrics"
                g_SQLiteDB.query(sql: sql2)
                nCurrentDBVersion = 3
            case 3:
                //从版本3更新到版本4
                let sql = "DROP TABLE childnodes"
                g_SQLiteDB.query(sql: sql)
                let sql2 = "DROP TABLE electricorders"
                g_SQLiteDB.query(sql: sql2)
                let sql3 = "DROP TABLE masternodes"
                g_SQLiteDB.query(sql: sql3)
                let sql4 = "DROP TABLE roomshared"
                g_SQLiteDB.query(sql: sql4)
                nCurrentDBVersion = 4
            case 4:
                //从版本4更新到版本5
                //将情景时间重置为空，保证下一次全部从web读取
                let setDict:NSMutableDictionary = ["scene_time": "__:__:__"]
                let requiredDict:NSMutableDictionary = [:]
                requiredDict.removeAllObjects()
                gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "users")
                //同时清空scenes表中的所有数据
                let sql2 = "delete from scenes"
                g_SQLiteDB.query(sql: sql2)
                nCurrentDBVersion = 5
            case 5:
                //从版本5更新到版本6
                let sql = "create table etkey (etkey_id integer not null primary key autoincrement, master_code varchar(255) not null, electric_index integer not null, did integer, key_name varchar(255), key_res integer, key_x integer, key_y integer, key_value varchar(255), key_key integer, key_brandindex integer, key_brandpos integer, key_row integer, key_state integer);"
                g_SQLiteDB.query(sql: sql)
                let sql2 = "create table etairdevice (etairdevice_id integer not null primary key autoincrement, master_code varchar(255) not null, electric_index integer not null, air_brand integer, air_index integer, air_temp integer, air_rate integer, air_dir integer, air_auto_dir integer, air_mode integer, air_power integer);"
                g_SQLiteDB.query(sql: sql2)
                //将电器时间重置为空，保证下一次重新从web读取到et类型的数据
                let setDict:NSMutableDictionary = ["electric_time": "__:__:__"]
                let requiredDict:NSMutableDictionary = [:]
                requiredDict.removeAllObjects()
                gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "users")
                nCurrentDBVersion = 6
            default:
                break
            }
        }
        let filePath = DataFilePath("data.plist")//获得本地data.plist文件的路径
        let array = NSMutableDictionary.init(contentsOfFile: filePath)//根据plist文件路径读取到数据字典
        array?.setObject(gDC.m_dbVersion, forKey: "db_version" as NSCopying)//重置这里的db_version值
        array!.write(toFile: filePath, atomically: true)
    }
    
}












