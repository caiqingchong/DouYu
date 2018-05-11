//
//  UIColor-Extension.swift
//  DouYu
//
//  Created by 张齐 on 2018/4/24.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

extension UIColor{

    /*
     convenience便利构造函数，通常在对系统的类进行构造函数扩充时使用。
     1、便利构造函数通常都是写在extension里面
     2、便利函数init前面需要加载convenience
     3、在便利构造函数中需要明确的调用self.init()
     */
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat){
        self.init(red: r/255.0 ,green: g/255.0 ,blue: b/255.0 ,alpha:1.0)
        
    }
    
    class func randomColor() -> UIColor{
        
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
}
