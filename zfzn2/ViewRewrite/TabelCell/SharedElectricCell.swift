//
//  SharedElectricCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/4/10.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  被分享的电器列表里使用

import UIKit

class SharedElectricCell: UITableViewCell {

    @IBOutlet weak var m_imageElectric: UIImageView!
    @IBOutlet weak var m_labelElectricName: UILabel!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_switch: UISwitch!
    var delegate:SharedElectricCellDelegate!
    var m_nElectricListFoot:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        m_switch.addTarget(self, action: #selector(SwitchDidChange), for:UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func SwitchDidChange() {
        self.delegate.didSwitchChange(m_switch.isOn, foot: m_nElectricListFoot)
    }

}

@objc
public protocol SharedElectricCellDelegate {
    func didSwitchChange(_ bSwitchOn:Bool, foot:Int)
}


