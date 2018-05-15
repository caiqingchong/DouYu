//
//  FunnyVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//


import UIKit

class BaseModel: NSObject {
   @objc  var tag_name : String = ""
   @objc  var icon_url : String = ""

    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
