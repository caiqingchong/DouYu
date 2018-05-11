//
//  AnchorModel.swift
//  1106-douyu
//
//  Created by targetcloud on 2016/11/9.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {
   @objc  var room_id : Int = 0
   @objc  var vertical_src : String = ""
   @objc  var isVertical : Int = 0
   @objc  var room_name : String = ""
   @objc  var nickname : String = ""
   @objc  var online : Int = 0
   @objc  var anchor_city : String = ""
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
    }
}
