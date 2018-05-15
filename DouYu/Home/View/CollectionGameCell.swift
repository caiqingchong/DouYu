//
//  CollectionGameCell.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/3.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class CollectionGameCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //在此处添加游戏的数据到相应的UI中
    
    @objc var game : BaseModel?{
        didSet{
//            titleLabel.text = game?.tag_name
//            titleLabel.font = UIFont.systemFont(ofSize: 15.0)
            titleLabel.text = game?.tag_name
//            这里先取出来相应图片的URL，然后进行加载 如果找不到URL就使用图片替换加载https://cs-op.douyucdn.cn/dycatr/668eadfdb030394d9522b32a903b37da.jpg
            //https://rpic.douyucdn.cn//amrpic-180510//4673521_1521.jpg
            print("-----------------------URL:\(String(describing: game?.icon_url))")

            if let iconURL = URL(string: game?.icon_url ?? ""){         
                iconImageView.kf.setImage(with: iconURL)
            }else{
                iconImageView.image = UIImage.init(named: "home_column_more")
            }
            
        }
        
    }
    

}
