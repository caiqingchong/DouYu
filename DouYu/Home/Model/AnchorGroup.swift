//
//  FunnyVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//


import UIKit

class AnchorGroup: BaseModel {
    @objc lazy var anchors : [AnchorModel] = [AnchorModel]()
    @objc var icon_name : String = "home_header_normal"
   
    @objc var room_list : [[String : Any]]? {
        didSet {
            guard let room_list2 = room_list else { return }
            for dict in room_list2 {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }

}



