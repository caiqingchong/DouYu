//
//  FunnyVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//


import UIKit

class CycleModel: NSObject {
    @objc var title : String = ""
    @objc var pic_url : String = ""
    @objc var anchor : AnchorModel?
    @objc var room :[String :Any]?{
        didSet{
            guard let room = room  else {
                return
            }
            anchor = AnchorModel(dict: room)
        }
    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
