//
//  UIBarButtonItem-Extension.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    //初始化的时候给参数一个初始值
    convenience init(imageName:String = "", highlightedImage:String = "",size:CGSize=CGSize.zero) {
        let btn = UIButton()
        btn.setImage(UIImage(named : imageName), for: .normal)
        if highlightedImage != ""{
            btn.setImage(UIImage(named : highlightedImage), for: .highlighted)
        }
        if size != CGSize.zero{
            btn.frame = CGRect (origin: CGPoint.zero, size: size)
        }else
        {
            btn.sizeToFit()
        }
        self.init(customView: btn)
        
        }
        
    }

