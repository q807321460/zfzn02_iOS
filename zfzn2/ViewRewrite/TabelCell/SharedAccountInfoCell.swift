//
//  SharedAccountInfoCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/4/5.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SharedAccountInfoCell: UITableViewCell {

    @IBOutlet weak var m_labelTitle: UILabel!
    @IBOutlet weak var m_sContent: UILabel!
    @IBOutlet weak var m_imageNavi: UIImageView!
    @IBOutlet weak var m_switch: UISwitch!
    var delegate:SharedAccountInfoCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        m_switch.addTarget(self, action: #selector(SwitchDidChange), for:UIControlEvents.valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func SwitchDidChange(){
        self.delegate.didSwitchChange(m_switch.isOn)
    }
    
}

@objc
public protocol SharedAccountInfoCellDelegate {
    func didSwitchChange(_ bSwitchOn:Bool)
}
