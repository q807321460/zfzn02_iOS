//
//  MyAreaCell.swift
//
//  Created by Hanwen Kong on 17/1/5.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//  这个是用于在情景模式中添加具体电器时使用的自定义TableCell类，同时该Table中集成了一个自定义的Cell类

import UIKit

class MyAreaCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var m_imageView: UIImageView!
    @IBOutlet weak var m_labelAreaName: UILabel!
    @IBOutlet weak var m_collectionView: UICollectionView!
    var m_nAreaListFoot:Int!
    var delegate:MyCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        m_collectionView.register(MiniElectric.self, forCellWithReuseIdentifier: "miniElectric")
        m_collectionView.register(UINib(nibName: "MiniElectric", bundle: nil), forCellWithReuseIdentifier: "miniElectric")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = gDC.mAreaList[m_nAreaListFoot].mElectricList.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.frame.width
        let cellWidth = (viewWidth-10)/3
        let cellHeight = cellWidth*90/80
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniElectric", for: indexPath) as! MiniElectric
        //编辑具体的电器cell属性
        for i in 0..<gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricSequ == indexPath.row {
                let nType = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricType
                cell.m_imageElectricType.image = UIImage(named: gDC.m_arrayElectricImage[nType] as! String)
                cell.m_labelElectricType.text = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sElectricName
            }
        }
        return cell
    }
    
    // 允许cell点击变色
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //cell点击变色
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = gDC.m_colorTouching
    }
    
    //允许cell重置背景色
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //cell重置背景色
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
    
    // 离开时cell重置背景色
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.didSelectMyCollectionCellAtIndexPath(m_nAreaListFoot, electricSequ: indexPath.row)
    }
    
}

@objc
public protocol MyCellDelegate {
    func didSelectMyCollectionCellAtIndexPath(_ areaSequ:Int, electricSequ: Int)
}




