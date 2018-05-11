//
//  CollectionCycleCell.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/3.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
import Kingfisher
class CollectionCycleCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    //定义模型属性  在这里给属性添加相应的参数
    var cycleModel : CycleModel? {
        didSet{
            titleLabel.text = cycleModel?.title
            //这里给一个判断，如果去不到URL，内容传空
            let iconURL = URL(string: cycleModel?.pic_url ?? "")
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "Img_default"))
        }
    }
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
