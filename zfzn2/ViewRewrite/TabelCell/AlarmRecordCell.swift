//
//  AlarmRecordCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/10/31.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  报警历史记录列表里使用

import UIKit

class AlarmRecordCell: UITableViewCell {

    @IBOutlet weak var m_imageElectric: UIImageView!
    @IBOutlet weak var m_labelElectricName: UILabel!
    @IBOutlet weak var m_labelRoomName: UILabel!
    @IBOutlet weak var m_labelAlarmTime: UILabel!
    @IBOutlet weak var m_labelStateInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
