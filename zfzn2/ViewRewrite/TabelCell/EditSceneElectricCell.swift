//
//  EditSceneElectricCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/4.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  情景模式的编辑界面中，切换情景电器的开关模式，以及删除情景电器用

import UIKit

class EditSceneElectricCell: UITableViewCell {

    @IBOutlet weak var m_imageSceneElectric: UIImageView!
    @IBOutlet weak var m_labelElectricName: UILabel!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_switchElectric: UISwitch!
    var delegate:EditSceneElectricCellDelegate!
    var m_nSceneElectricListFoot:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        m_switchElectric.addTarget(self, action: #selector(SwitchDidChange), for:UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func OnDelete(_ sender: UIButton) {
        self.delegate.didClickDeleteButton(m_nSceneElectricListFoot)
    }
    
    func SwitchDidChange() {
        self.delegate.didSwitchChange(m_nSceneElectricListFoot, isOn: m_switchElectric.isOn)
    }
    
}

@objc
public protocol EditSceneElectricCellDelegate{
    func didClickDeleteButton(_ sceneElectricFoot:Int)
    func didSwitchChange(_ sceneElectricFoot:Int, isOn:Bool)
}











