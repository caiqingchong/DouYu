//
//  HandsVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class HandsVC: BaseAnchorVC {
    fileprivate lazy var handsVM : HandsVM = HandsVM()
    fileprivate lazy var menuView : MenuView = {
        let menuView = MenuView.menuView()
        menuView.frame = CGRect(x: 0, y: -kMenuViewH, width: kScreenW, height: kMenuViewH)//设置collectionView的-y,放置menuView
        return menuView
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray

        super.setupUI()
        collectionView.addSubview(menuView)
        collectionView.contentInset = UIEdgeInsets(top: kMenuViewH, left: 0, bottom: 0, right: 0)//设置内边距
        loadHandsData()
    }
}



extension HandsVC{
     func loadHandsData() {
        baseVM = handsVM
        handsVM.requestData {
            self.collectionView.reloadData()
            
            var tempGroups = Array(self.handsVM.anchorGroups[1...15])// 0...15 & tempGroups.removeFirst()
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多分类"
            tempGroups.append(moreGroup)
            self.menuView.groups = tempGroups
            
            self.loadDataFinished()
        }
    }
}








