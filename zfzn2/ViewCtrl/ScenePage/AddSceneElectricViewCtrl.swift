//
//  AddSceneElectricViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/5.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class AddSceneElectricViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource, MyCellDelegate {

    @IBOutlet weak var m_tableSceneElectric: UITableView!
    var m_nSceneListFoot:Int!
    var m_nSceneIndex:Int!
    var m_nAreaListFoot:Int!
    var m_nElectricListFoot:Int!
    var m_bStretchArray = [Bool]()//用于标记该房间是否处于展开状态
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<gDC.mAreaList.count {
            m_bStretchArray.append(false)
        }
        self.automaticallyAdjustsScrollViewInsets = false//保证对齐顶端，去除的话，会在上部留出空白
        m_tableSceneElectric.tableFooterView = UIView()
        m_tableSceneElectric.bounces = false
        m_tableSceneElectric.register(MyAreaCell.self, forCellReuseIdentifier: "myAreaCell")
        m_tableSceneElectric.register(UINib(nibName: "MyAreaCell", bundle: nil), forCellReuseIdentifier: "myAreaCell")
        m_tableSceneElectric.delegate = self
        m_tableSceneElectric.dataSource = self
        g_notiCenter.addObserver(self, selector:#selector(AddSceneElectricViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func OnBack(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
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
    
    ////////////////////////////////////////////////////////////////////////////////////
    func didSelectMyCollectionCellAtIndexPath(_ areaSequ:Int, electricSequ: Int) {
        print("获得委托数据为：房间sequ——\(areaSequ)    电器sequ——\(electricSequ)")
        //根据获取的房间和电器sequ，可以得到需要添加的电器的所有信息
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_nAreaSequ == areaSequ {
                m_nAreaListFoot = i
                break
            }
        }
        for i in 0..<gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricSequ == electricSequ {
                m_nElectricListFoot = i
                break
            }
        }
        //跳转到具体的电器界面
        let nType = gDC.mAreaList[m_nAreaListFoot].mElectricList[m_nElectricListFoot].m_nElectricType
        //只有部分电器支持添加到情景模式中，需要在这里做一个判断
        if (nType >= 0 && nType <= 4) || (nType >= 6 && nType <= 7) || nType == 11 || nType == 18 || nType == 20 {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let nextView = sb.instantiateViewController(withIdentifier: "editSceneElectricViewCtrl") as! EditSceneElectricViewCtrl
            nextView.m_nAreaListFoot = m_nAreaListFoot
            nextView.m_nElectricListFoot = m_nElectricListFoot
            nextView.m_nSceneListFoot = m_nSceneListFoot
//            nextView.m_nElectricIndex = gDC.mAreaList[self.m_nAreaListFoot].mElectricList[self.m_nElectricListFoot].m_nElectricIndex
            self.navigationController?.pushViewController(nextView , animated: true)
        }else {
            ShowInfoDispatch("提示", content: "暂时不支持该类型电器的情景控制", duration: 1.0)
        }
    }
    
    func SyncData() {
        DispatchQueue.main.async {
            //可能会数组越界，还需要判断当前的情景是否已经不存在了（被其他app删除）
            if (self.m_nSceneListFoot >= gDC.mSceneList.count || gDC.mSceneList[self.m_nSceneListFoot].m_nSceneIndex != self.m_nSceneIndex) {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            self.m_tableSceneElectric.reloadData()
        }
    }
    
}
