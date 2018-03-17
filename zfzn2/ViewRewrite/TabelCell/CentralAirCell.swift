//
//  CentralAirCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2018/3/12.
//  Copyright © 2018年 Hanwen Kong. All rights reserved.
//

import UIKit

class CentralAirCell: UITableViewCell {

   @IBOutlet weak var m_buttonBox: UIButton!
  @IBAction func Oncheckbox(_ sender: UIButton) {
        if m_imagecheck.isHidden == false {
            m_imagecheck.isHidden = true
        }else{
            m_imagecheck.isHidden = false
        }
    }
    @IBOutlet weak var m_imagecheck: UIImageView!
    @IBOutlet weak var m_imageState: UIImageView!
    @IBOutlet weak var m_labelErrorcode: UILabel!
    @IBOutlet weak var m_labelRoomtemperature: UILabel!
    @IBOutlet weak var m_labelSettemperature: UILabel!
    @IBOutlet weak var m_labelWindspeed: UILabel!
    @IBOutlet weak var m_labelPattern: UILabel!
    @IBOutlet weak var m_labelSwitch: UILabel!
    @IBOutlet weak var m_labelNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
