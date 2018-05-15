//
//  FunnyVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//



import UIKit

class CollectionPrettyCell: BaseCollectionViewCell {

    @IBOutlet weak var cityBtn: UIButton!
    
    override var anchor : AnchorModel? {
        didSet {
            super.anchor = anchor
            cityBtn.setTitle(anchor?.anchor_city, for: UIControlState())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
