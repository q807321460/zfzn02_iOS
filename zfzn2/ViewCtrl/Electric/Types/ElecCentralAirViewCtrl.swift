//
//  ElecCentralAirViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/3/13.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class ElecCentralAirViewCtrl: ElecSuperViewCtrl, UITableViewDelegate, UITableViewDataSource {
    @IBAction func CentralAirAdd(_ sender: Any) {
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "addCentralAir") as! AddCentralAir
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    
    @IBOutlet weak var m_btnTemperature4: UIButton!
    @IBOutlet weak var m_btnTemperature3: UIButton!
    @IBOutlet weak var m_btnTemperature2: UIButton!
    @IBOutlet weak var m_btnTemperature1: UIButton!
    @IBOutlet weak var m_btnCold: UIButton!
    @IBOutlet weak var m_btnLow: UIButton!
    @IBOutlet weak var m_btnMiddle: UIButton!
    @IBOutlet weak var m_btnHigh: UIButton!
    @IBOutlet weak var m_btnWet: UIButton!
    @IBOutlet weak var m_btnWind: UIButton!
    @IBOutlet weak var m_btnHot: UIButton!
    @IBOutlet weak var m_btnOff: UIButton!
    @IBOutlet weak var m_btnOn: UIButton!
    @IBOutlet weak var m_tableCentralAir: UITableView!
    var mCentralAirList=[ElecCentralAirData]()
    var m_nCentralAirListFoot:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_tableCentralAir.register(CentralAirCell.self, forCellReuseIdentifier: "centralAirCell")
        m_tableCentralAir.register(UINib(nibName: "CentralAirCell", bundle: nil), forCellReuseIdentifier: "centralAirCell")//创建一个可重用的单元格
        m_tableCentralAir.bounces = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//         return gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "centralAirCell", for: indexPath) as! CentralAirCell
//        cell.m_imageState.image = gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirState
//        cell.m_imagecheck.image = gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAircheck
//        cell.m_labelNumber.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirNumber
//        cell.m_labelPattern.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirPattern
//        cell.m_labelSwitch.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirSwitch
//        cell.m_labelRoomtemperature.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirRoomtemperature
//        cell.m_labelSettemperature.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirSettemperature
//        cell.m_labelWindspeed.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirWindspeed
//        cell.m_labelErrorcode.text=gDC.mCentralAirList[m_nCentralAirListFoot].mCentralAir[indexPath.row].m_CentralAirErrorcode
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
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
