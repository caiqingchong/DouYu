//
//  FunnyVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class FunnyVC: BaseAnchorVC {

    fileprivate lazy var funnyVM : FunnyVM = FunnyVM()
    //懒加载视图，设置好frame
    fileprivate lazy var menuView : MenuView = {
        let menuView = MenuView.menuView()
        menuView.frame = CGRect(x: 0, y: -kMenuViewH, width: kScreenW, height: kMenuViewH)
        return menuView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purple
        super.setupUI()
        //1、单纯这样添加是无法
        collectionView.addSubview(menuView)
        //2、扩展collectionView的大小
        collectionView.contentInset = UIEdgeInsets(top: kMenuViewH, left: 0, bottom: 0, right: 0)
    
        loadFunnyData()
    }
}





/*
 2、获取数据并进行赋值
 */
extension FunnyVC{
    func loadFunnyData()  {
        baseVM = funnyVM
        
        funnyVM.requestData {
            //请求到数据，刷新cell
            self.collectionView.reloadData()
            
            var tempGroups = self.funnyVM.anchorGroups
            tempGroups.removeFirst()//为什么要移除第一个呢？
            self.menuView.groups = tempGroups//将获取的数据赋值到视图group上面
            
            //请求到数据之后，结束动画
            self.loadDataFinished()
        }
        
    }
    
}
