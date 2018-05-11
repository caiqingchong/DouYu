//
//  PageContentView.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/27.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
/*
 主要技术点：代理、懒加载、视图滑动距离计算
 1、定义滑动移动的的代理，用于传给title栏，使两者产生联动  最好能弄个第三方，以后方便自己使用。
 */

//MARK : - 1、设置滑动代理传递相应的数据以移动title视图
protocol PageContentViewDelegate : class{
    //contentView：当前视图  progress：滚动进度  sourceIndex：原索引  targetIndex：目标索引
    func pageContentView(_ contentView : PageContentView,progress : CGFloat,sourceIndex :Int , targetIndex :Int)
}

//设置cell的标识
private let ContentCellID = "ContentCellID"


//MARK : - 2、自定义视图，里面包含collectionView以及相应的布局和处理
class PageContentView: UIView {
    fileprivate var isForbidScrollDelegate : Bool = false//代理是否有效
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var childVcs :[UIViewController]
    fileprivate weak var parentVc : UIViewController?//改成弱引用，那么是可选类型，那么就有?

    //2.1 弱引用修饰代理
    weak var delegate : PageContentViewDelegate?
    
    //2.2 懒加载collectionView视图，并布局处理
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        //进行布局设置
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0//最小行间距
        layout.minimumInteritemSpacing = 0 //间隔cell的最小列间距
        layout.scrollDirection = .horizontal//设置水平滚动
        
        //设置UICollectionView属性，首先要进行初始化
        let collectionView = UICollectionView(frame: CGRect.zero , collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        
        //注册cell 设置操作代理和数据代理
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
    }()
    
    //2.3 init初始化view
    init(frame:CGRect ,childVcs:[UIViewController],parentVc:UIViewController?) {
        self.childVcs = childVcs
        self.parentVc = parentVc //可选类型赋值给可选类型
        super.init(frame : frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK ： - 3、添加相应的视图
extension PageContentView{
     func setupUI(){
        for childVc in childVcs {
            //为父视图关联子视图
            parentVc?.addChildViewController(childVc)
        }
        //添加子视图
        collectionView.frame = bounds
        addSubview(collectionView)
    }
    
}




//MARK  - 4、数据代理
extension PageContentView : UICollectionViewDataSource{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return childVcs.count
    }
    
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        //为了防止视图在重用的过程中导致的重影,移除子视图所有的数据
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        //向cell中填充数据 也就是child的视图
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    
}


//MARK ： - 5、操作代理
extension PageContentView : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    
    //在不断滚动的过程中，设置
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //是点击传导过来的，则不处理
        if isForbidScrollDelegate { return }
        
        var progress : CGFloat = 0
        var sourceIndex :Int = 0
        var targetIndex :Int = 0
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {
            progress = currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW)
            sourceIndex = Int(currentOffsetX/scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            progress = 1 - (currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW))
            targetIndex =  Int(currentOffsetX/scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
            //完全划过去
            if startOffsetX - currentOffsetX == scrollViewW {
                sourceIndex = targetIndex
            }
        }
        
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


//MARK:-对外公开的操作FUNC,1、用于homevc作为pagetitleview的代理，再由homevc调用到这里
extension PageContentView{
    func setCurrentIndex(currentIndex : Int){
        isForbidScrollDelegate = true
        let offsetX = CGFloat( currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offsetX,y:0), animated: false)
    }
}


