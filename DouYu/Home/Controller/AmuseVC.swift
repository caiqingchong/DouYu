//
//  AmuseVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
private let kCycleViewH : CGFloat = kScreenW * 3 / 8
private let kGameViewH : CGFloat = 90
class AmuseVC: BaseAnchorVC {
    fileprivate lazy var amuseVM : AmuseVM = AmuseVM()

    fileprivate lazy var menuView : MenuView = {
        let menuView = MenuView.menuView()
        menuView.frame = CGRect(x: 0, y: -kMenuViewH, width: kScreenW, height: kMenuViewH)//设置collectionView的-y,放置menuView
        return menuView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       super.loadData()
        super.setupGameUI()
        super.setupUI()
        
        collectionView.addSubview(menuView)
        collectionView.contentInset = UIEdgeInsets(top: kMenuViewH, left: 0, bottom: 0, right: 0)//设置内边距
        
        
        
        
        //打印滚动视图的frame，看是否添加成功
        print("menuView的frame为：\(menuView)")
        self.view.backgroundColor = UIColor.darkGray
        amuseLoadData()
    }
}


extension AmuseVC{
    
    func amuseLoadData() {
        baseVM = amuseVM
        amuseVM.requestData {
            
            print("在此处刷新数据，找到问题")
            self.collectionView.reloadData()
            
            var tempGroups = self.amuseVM.anchorGroups
            tempGroups.removeFirst()
//            self.menuView.groups = tempGroups
            //请求出来数据之后，动画结束。
            self.loadDataFinished()
    }
    }
}









