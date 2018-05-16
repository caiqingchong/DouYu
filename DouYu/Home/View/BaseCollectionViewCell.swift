//
//  BaseCollectionViewCell.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//


import UIKit
import Kingfisher

class BaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    
   @objc var anchor : AnchorModel? {
        didSet {
            guard let anchor = anchor else { return }

            var onlineStr : String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int(anchor.online / 10000))万"
                onlineStr = String(format:"%.1f万",Float(anchor.online) / 10000)
            } else {
                onlineStr = "\(anchor.online)"
            }
            onlineBtn.setTitle(onlineStr, for: UIControlState())
            
            nickNameLabel.text = anchor.nickname
            
            guard let iconURL = URL(string: anchor.vertical_src) else { return }
            iconImageView.kf.setImage(with: iconURL)
            
        }
    }
}
