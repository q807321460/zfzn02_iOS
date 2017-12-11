//
//  AddSceneCell.swift
//  zfzn2
//
//  Created by Hanwen Kong on 2017/6/29.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  添加情景模式时，选择情景图片的下拉列表里使用

import UIKit

class AddSceneCell: UITableViewCell {

    @IBOutlet weak var m_imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
