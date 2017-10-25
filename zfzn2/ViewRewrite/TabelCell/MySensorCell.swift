//
//  MySensorCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/22.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class MySensorCell: UITableViewCell {

    @IBOutlet weak var m_imageView: UIImageView!
    @IBOutlet weak var m_labelElectric: UILabel!
    @IBOutlet weak var m_labelArea: UILabel!
    @IBOutlet weak var m_labelStateInfo: UILabel!
    @IBOutlet weak var m_switch: UISwitch!
    var delegate:MySensorCellDelegate!
    var m_nAreaFoot:Int!
    var m_nElectricFoot:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        m_switch.addTarget(self, action: #selector(SwitchDidChange), for:UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func SwitchDidChange() {
        self.delegate.didSwitchChange(m_switch.isOn, nAreaFoot:m_nAreaFoot, nElectricFoot:m_nElectricFoot)
    }

}

@objc
public protocol MySensorCellDelegate {
    func didSwitchChange(_ bSwitchOn:Bool, nAreaFoot:Int, nElectricFoot:Int)
}
