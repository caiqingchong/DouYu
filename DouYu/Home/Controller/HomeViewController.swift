//
//  HomeViewController.swift
//  DouYu
//
//  Created by 张齐 on 2018/4/23.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
private let kTitleViewH :CGFloat = 40

class HomeViewController: UIViewController {
    
    let titles = ["推荐","手游","娱乐","游戏","趣玩"]
//    let titles = ["手游","娱乐","游戏","趣玩"]

    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH+kNavBarH, width: kScreenW, height: kTitleViewH)
        let titleView = PageTitleView(frame: titleFrame, titles: (self?.titles)!)
        //MARK:- 控制器作为PageTitleViewDelegate代理
        titleView.delegate = self
        return titleView
        }()
    
    fileprivate lazy var pageContentView : PageContentView = { [weak self] in
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH + kTitleViewH, width: kScreenW, height: kScreenH - kStatusBarH - kNavBarH - kTitleViewH - kTabBarH)
        var childVcs = [UIViewController]()
        
        //这里抽离出来一个基类，让之后的类继承
        childVcs.append(RecommendVC())
        childVcs.append(HandsVC())
        childVcs.append(AmuseVC())
        childVcs.append(GameVC())
        childVcs.append(FunnyVC())
  
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
        //MARK:- 控制器作为PageContentViewDelegate代理
        contentView.delegate = self
        return contentView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension HomeViewController{
    fileprivate func setupUI(){
        //不需要调整scrollview的内边距
//        automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.barTintColor =
                    UIColor.orange
        
        setupNavBar()
        self.view.addSubview(pageTitleView)
        self.view.addSubview(pageContentView)
    }
    
    fileprivate func setupNavBar(){
        navigationItem.leftBarButtonItem=UIBarButtonItem(imageName: "homeLogoIcon")
        let size=CGSize(width: 40, height: 40)
        let searchItem = UIBarButtonItem(imageName: "searchBtnIcon", highlightedImage: "searchBtnIconHL", size: size)
        let qrItem = UIBarButtonItem(imageName: "scanIcon", highlightedImage: "scanIconHL", size: size)
        let historyItem = UIBarButtonItem(imageName: "viewHistoryIcon", highlightedImage: "viewHistoryIconHL", size: size)
        let MessageItem = UIBarButtonItem(imageName: "siteMessageHome", highlightedImage: "siteMessageHomeH", size: size)
        navigationItem.rightBarButtonItems = [searchItem,qrItem,historyItem,MessageItem]
    }
}

//MARK:- PageTitleViewDelegate代理实现
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
        print("张凯点击的当前的titlepage为:\(index)")
        
        
    }
}

//MARK:- PageContentViewDelegate代理实现   这里的代理没有执行，为什么呢？

/*
 问题分析：这里可以移动，但是代理方法不调用，说明可能是代理的问题。
 确实是代理的问题，是我忘了在PageContentView添加代理设置了，所以导致代理根本不能走，不够细心啊。
 */
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}





















//class HomeViewController: UIViewController {
//    let titles = ["推荐","手游","娱乐","游戏","趣玩"]
//
//    //titleView的视图，懒加载视图 添加头视图，放到view模块中实现。
//    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
//        let titleFrame = CGRect(x: 0, y: kStatusBarH+kNavBarH, width: kScreenW, height: kTitleViewH)
//        let titleView = PageTitleView(frame: titleFrame, titles: (self?.titles)!)
//        //MARK:- 控制器作为PageTitleViewDelegate代理
//        titleView.delegate = self as? PageTitleViewDelegate
//        return titleView
//        }()
//
//    //滚动式图的懒加载
//    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
//        /*
//         整体:设置相应的子视图、frame、代理
//         步骤1：frame为出去状态栏、导航栏、title栏、tabbar的高度
//         步骤2：添加所有的子视图
//         步骤3：设置相应的代理
//         */
//       let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavBarH + kTitleViewH, width: kScreenW, height: kScreenH - kStatusBarH - kNavBarH - kTitleViewH - kTabBarH)
//        var childVcs = [UIViewController]()
//        childVcs.append(RecommendVC())
//        childVcs.append(HandsVC())
//        childVcs.append(AmuseVC())
//        childVcs.append(GameVC())
//        childVcs.append(FunnyVC())
//
//        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self)
//        //MARK:- 控制器作为PageContentViewDelegate代理
//        contentView.delegate = (self as! PageContentViewDelegate)
//        return contentView
//    }()
//
//
//
//
//
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.orange
//
//        //修改导航栏颜色：http://www.hangge.com/blog/cache/detail_962.html
//        self.navigationController?.navigationBar.barTintColor =
//            UIColor.orange
//
//        setupUI()
//    }
//
//}
//
//
//extension HomeViewController{
//    fileprivate func setupUI(){
//
//        automaticallyAdjustsScrollViewInsets = true
//        setupNavBar()
//        //添加相应的视图
//        view.addSubview(pageContentView)
//        view.addSubview(pageTitleView)
//    }
//
//    func setupNavBar() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "homeLogoIcon"), style: .plain, target: self, action: #selector(clickLeft))
//
////        let size = CGSize(width: 40, height: 40)
//        //这里自定义的item怎么添加事件捏?????? 未知
//
//
//        //设置右侧导航栏按钮
//         /*
//        let size = CGSize(width: 40, height: 40)
//        //这里自定义的item怎么添加事件捏
//        let searchItem = UIBarButtonItem(imageName: "searchBtnIcon", highlightedImage: "searchBtnIconHL", size: size)
//        searchItem.tag = 1
//        searchItem.action = #selector(clickLeft)//可以在此处单独添加事件
//
//        let qrItem = UIBarButtonItem(imageName: "scanIcon", highlightedImage: "scanIconHL", size: size)
//        qrItem.action = #selector(clickLeft)
//
//        let historyItem = UIBarButtonItem(imageName: "viewHistoryIcon", highlightedImage: "viewHistoryIconHL", size: size)
//        historyItem.action = #selector(clickLeft)
//
//        let MessageItem = UIBarButtonItem(imageName: "siteMessageHome", highlightedImage: "siteMessageHomeH", size: size)
//        MessageItem.action = #selector(clickLeft)
//
//        qrItem.tag = 2
//        historyItem.tag = 3
//        MessageItem.tag = 4
// */
//        /*
//         (clickLeft)事件不必享OC那样添加tag。 切记啊老铁
//         */
//         let searchItem = UIBarButtonItem.init(image: UIImage.init(named: "searchBtnIcon"), style: .plain, target: self, action: #selector(clickLeft))
//         searchItem.tag = 1
//         let qrItem = UIBarButtonItem.init(image: UIImage.init(named: "scanIcon"), style: .plain, target: self, action: #selector(clickLeft))
//         qrItem.tag = 2
//
//         let historyItem = UIBarButtonItem.init(image: UIImage.init(named: "viewHistoryIcon"), style: .plain, target: self, action: #selector(clickLeft))
//         historyItem.tag = 3
//
//         let MessageItem = UIBarButtonItem.init(image: UIImage.init(named: "siteMessageHome"), style: .plain, target: self, action: #selector(clickLeft))
//         MessageItem.tag = 4
//
//
//
//        navigationItem.rightBarButtonItems = [searchItem,qrItem,historyItem,MessageItem]
//
//
//    }
//
//}
//
////事件处理 怎么处理添加tag的事件呢？ 方法到底应该怎么写呢？
//extension HomeViewController{
//
//    @objc fileprivate func clickLeft(item:UIBarButtonItem){
//
//        print("张凯点击了导航栏左侧的按钮:\(item.tag)")
//
//    }
//
//}
//
//
////MARK:- PageTitleViewDelegate代理实现
//extension HomeViewController : PageTitleViewDelegate{
//
//    func PageTitleView(_ titleView: PageTitleView, selectedIndex index: Int) {
//        pageContentView.setCurrentIndex(currentIndex: index)
//    }
//}
//
////MARK:- PageContentViewDelegate代理实现
//extension HomeViewController : PageContentViewDelegate{
//    func pageContentView(_ contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
//        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
//    }
//}

