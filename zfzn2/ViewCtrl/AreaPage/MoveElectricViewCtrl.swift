//
//  MoveElectricViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/12/11.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class MoveElectricViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var m_tableArea: UITableView!
    var m_nAreaListFoot:Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_tableArea.tableFooterView = UIView()
        m_tableArea.bounces = false
        m_tableArea.register(MyAreaCell2.self, forCellReuseIdentifier: "myAreaCell2")
        m_tableArea.register(UINib(nibName: "MyAreaCell2", bundle: nil), forCellReuseIdentifier: "myAreaCell2")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gDC.mAreaList.count
    }
    
    //每行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyAreaCell2 = tableView.dequeueReusableCell(withIdentifier: "myAreaCell2", for: indexPath) as! MyAreaCell2
        for i in 0..<gDC.mAreaList.count {
            if (gDC.mAreaList[i].m_nAreaSequ == indexPath.row) {
                //自动裁剪成居中的正方形图片
                if gDC.mAreaList[i].m_imageArea != nil {
                    let sizeImage = gDC.mAreaList[i].m_imageArea?.size
                    let cubeImage:UIImage = CutImage(gDC.mAreaList[i].m_imageArea!, rect:CGRect(x: (sizeImage!.width-sizeImage!.height)/2.0, y: 0, width: sizeImage!.height, height: sizeImage!.height))
                    cell.m_imageArea.image = cubeImage
                    cell.m_imageArea.layer.cornerRadius = cell.m_imageArea.frame.height/2
                    cell.m_imageArea.layer.masksToBounds = true
                }else {
                    cell.m_imageArea.image = nil
                }
                cell.m_labelAreaName.text = gDC.mAreaList[i].m_sAreaName
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var targetRoomIndex:Int!
        for i in 0..<gDC.mAreaList.count {
            if (gDC.mAreaList[i].m_nAreaSequ == indexPath.row) {
                if (i == self.m_nAreaListFoot) {
                    ShowNoticeDispatch("提示", content: "请移动到其他区域", duration: 0.5)
                    return
                }else {
                    targetRoomIndex = gDC.mAreaList[i].m_nAreaIndex
                    break
                }
            }
        }
        //双重for循环是为了防止出现数组越界
        for _ in 0..<gDC.mAreaList[self.m_nAreaListFoot].mElectricList.count{
            for i in 0..<gDC.mAreaList[self.m_nAreaListFoot].mElectricList.count {
                if gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_bSelected == true {//如果该电器被选中
                    let electricIndex = gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_nElectricIndex
                    let re = MyWebService.sharedInstance.MoveElectricToAnotherRoom(
                        masterCode: gDC.mUserInfo.m_sMasterCode,
                        electricIndex: electricIndex,
                        roomIndex: targetRoomIndex
                    )
                    
                    break
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)//手指抬起后直接取消按下时的深色状态
    }

}
