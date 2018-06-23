//
//  BindingSwitch.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/6/21.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class BindingSwitch: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCellDelegate {

    
    @IBOutlet weak var m_tableBingdingSwitch: UITableView!
    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
    var m_newAreaListFoot:Int!
    var m_newElectricListFoot:Int!
    var m_sElectricOrder:String!
    var roomIndex:String!
    var bindingIndex:String!
    var m_bStretchArray = [Bool]()//用于标记该房间是否处于展开状态
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<gDC.mAreaList.count {
            m_bStretchArray.append(false)
        }
        self.automaticallyAdjustsScrollViewInsets = false//保证对齐顶端，去除的话，会在上部留出空白
        m_tableBingdingSwitch.tableFooterView = UIView()
        m_tableBingdingSwitch.bounces = false
        m_tableBingdingSwitch.register(MyAreaCell.self, forCellReuseIdentifier: "myAreaCell")
        m_tableBingdingSwitch.register(UINib(nibName: "MyAreaCell", bundle: nil), forCellReuseIdentifier: "myAreaCell")
        m_tableBingdingSwitch.delegate = self
        m_tableBingdingSwitch.dataSource = self
        g_notiCenter.addObserver(self, selector:#selector(BindingSwitch.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
        
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return gDC.mAreaList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_nAreaSequ == indexPath.row {//根据sequ排序
                if m_bStretchArray[indexPath.row] == true {
                    //计算高度
                    let width = self.view.bounds.width
                    let collectionCellWidth = (width-10)/3
                    let collectionCellHeight = collectionCellWidth*90/80
                    let rowCount = (gDC.mAreaList[i].mElectricList.count-1)/3 + 1
                    let height = 44 + (collectionCellHeight)*CGFloat(rowCount) + CGFloat(1)*CGFloat(rowCount)
                    return height
                }else {
                    return 44
                }
            }
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myAreaCell", for: indexPath) as! MyAreaCell
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_nAreaSequ == indexPath.row {//根据sequ排序
                if m_bStretchArray[indexPath.row] == true {
                    cell.m_imageView.image = UIImage(named: "导航栏_下拉")
                    cell.m_labelAreaName.text = gDC.mAreaList[i].m_sAreaName
                    cell.m_nAreaListFoot = i
                    cell.m_collectionView.delegate = cell.self
                    cell.m_collectionView.dataSource = cell.self
                }else {
                    cell.m_imageView.image = UIImage(named: "导航栏_收起")
                    cell.m_labelAreaName.text = gDC.mAreaList[i].m_sAreaName
                }
                break
            }
        }
        cell.delegate = self
        cell.m_collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        m_bStretchArray[indexPath.row] = !m_bStretchArray[indexPath.row]
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    func didSelectMyCollectionCellAtIndexPath(_ areaSequ: Int, electricSequ: Int) {
       
        //根据获取的房间和电器sequ，可以得到需要添加的电器的所有信息
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_nAreaSequ == areaSequ {
                m_newAreaListFoot = i
                break
            }
        }
        for i in 0..<gDC.mAreaList[m_newAreaListFoot].mElectricList.count {
            if gDC.mAreaList[m_newAreaListFoot].mElectricList[i].m_nElectricSequ == electricSequ {
                m_newElectricListFoot = i
                break
            }
        }
        
        let masterCode:String = gDC.mUserInfo.m_sMasterCode
        let electricIndex:Int = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricIndex
        roomIndex = String(gDC.mAreaList[m_newAreaListFoot].m_nAreaIndex)
        bindingIndex = String(gDC.mAreaList[m_newAreaListFoot].mElectricList[m_newElectricListFoot].m_nElectricIndex)
        
        let nType = gDC.mAreaList[m_newAreaListFoot].mElectricList[m_newElectricListFoot].m_nElectricType
        if (nType >= 0 && nType <= 4){
            DispatchQueue.main.async(execute: {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("确定", action: {
                    () -> Void in
                    self.m_sElectricOrder = gDC.mAreaList[self.m_nAreaListFoot].mElectricList[self.m_nElectricListFoot].m_sOrderInfo + gDC.mAreaList[self.m_newAreaListFoot].mElectricList[self.m_newElectricListFoot].m_sElectricCode +
                    "XH" + gDC.mAreaList[self.m_newAreaListFoot].mElectricList[self.m_newElectricListFoot].m_sOrderInfo
                    MyWebService.sharedInstance.UpdateElectricOrder(gDC.mUserInfo.m_sMasterCode, electricCode:gDC.mAreaList[self.m_nAreaListFoot].mElectricList[self.m_nElectricListFoot].m_sElectricCode, order:gDC.m_sCentralAir+gDC.m_sOrderOpen, orderInfo:self.m_sElectricOrder)
                    let webResult:String = MyWebService.sharedInstance.BindingDuplexSwift(masterCode:masterCode,electricIndex:electricIndex,roomIndex:self.roomIndex,bindingIndex:self.bindingIndex)
                    self.WebBindingDuplexSwift(responseValue:webResult)
                })
                alertView.showInfo("提示", subTitle: "是否确定绑定该电器", duration: 0)//时间间隔为0时不会自动退出
            })
        }else {
            ShowInfoDispatch("提示", content: "不支持该类型电器绑定双控开关", duration: 1.0)
        }
    }
    
    func WebBindingDuplexSwift(responseValue:String){
        switch responseValue {
        case "WebError":
            break
        case "1":
            ShowInfoDispatch("提示", content: "绑定成功", duration: 0.8)
            gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_sExtras = roomIndex + "-" + bindingIndex
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    func SyncData() {
        DispatchQueue.main.async {
//            //可能会数组越界，还需要判断当前的情景是否已经不存在了（被其他app删除）
//            if (self.m_nSceneListFoot >= gDC.mSceneList.count || gDC.mSceneList[self.m_nSceneListFoot].m_nSceneIndex != self.m_nSceneIndex) {
//                self.navigationController?.popToRootViewController(animated: true)
//                return
//            }
            self.m_tableBingdingSwitch.reloadData()
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
