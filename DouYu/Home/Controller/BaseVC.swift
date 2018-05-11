//
//  BaseVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/4.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    var contentView : UIView?
    //懒加载出动画
    fileprivate lazy var animImageView : UIImageView = {[unowned self] in
        let imageView = UIImageView.init(image: UIImage.init(named: "img_loading_1"))
        imageView.center = self.view.center
        imageView.animationImages = [UIImage(named : "img_loading_1")!, UIImage(named : "img_loading_2")!]
        //完整动画播放时长
        imageView.animationDuration = 0.5
        //无限播放
        imageView.animationRepeatCount = LONG_MAX
        //适配动画，撑满整个屏幕
        imageView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin]
        return imageView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
}


extension BaseVC{
    //添加动画视图
    func setupUI()  {
        view.addSubview(animImageView)
        animImageView.startAnimating()//开始动画
        view.backgroundColor = UIColor(r: 250, g: 250, b: 250)
    }
    
    //停止动画并隐藏
    func  loadDataFinished()  {
        animImageView.stopAnimating()
        animImageView.isHidden = true
    }
    
    
}




















