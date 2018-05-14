//
//  GameVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
/*
 1、添加数据。
 2、添加视图，和前面的视图一样。
 */



class GameVC: BaseAnchorVC {
    //数据处理
    fileprivate lazy var gameVM : GameVM = GameVM()
    
    //滚动的视图处理
    fileprivate lazy var menuView : MenuView = {
        //初始化视图
        let menuView = MenuView.menuView()
        
        menuView.frame = CGRect(x: 0, y: -kMenuViewH, width: kScreenW, height: kMenuViewH)//设置collectionView的-y,放置menuView
        return menuView
    }()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        super.setupUI()
        collectionView.addSubview(menuView)
        collectionView.contentInset = UIEdgeInsets(top: kMenuViewH, left: 0, bottom: 0, right: 0)//设置让collectionView拉伸，添加menuView的大小。
        
        loadGameData()
    }


}


//添加数据部分
extension GameVC{
    func loadGameData() {
        baseVM = self.gameVM
        gameVM.requestData {
            self.collectionView.reloadData()
            var gameGroup = Array(self.gameVM.anchorGroups[1...15])
            //初始化用来准备数据转模型
            let moreGroup = AnchorGroup()
            
            moreGroup.tag_name = "更多分类"
            gameGroup.append(moreGroup)
            self.menuView.groups = gameGroup
            
            //数据已经加载完毕，然后隐藏动画
            self.loadDataFinished() 
        }
        
        
    }
    
}








