//
//  DoorRecordCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/10/19.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  门锁开锁记录列表里使用

import UIKit

class DoorRecordCell: UITableViewCell {

    @IBOutlet weak var m_labelOpenTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
