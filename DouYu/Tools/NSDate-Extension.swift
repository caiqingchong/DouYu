//
//  NSDate-Extension.swift
//  DouYu
//
//  Created by 张齐 on 2018/4/24.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit


//获取当前时间   
extension NSDate{
    class func getCurrentTime() -> String {
        return "\(NSDate().timeIntervalSince1970)"
    }
    
    
}
