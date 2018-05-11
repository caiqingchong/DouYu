//
//  PageContentView.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

//MARK：- 定义代理 用于点击
protocol PageContentViewDelegate :class {
    func pageContentView(_ contentView : PageContentView,progress : CGFloat,sourceIndex :Int , targetIndex :Int)
}

private let ContentCellID = "ContentCellID"


class PageContentView: UIView {
    fileprivate var isForbidScrollDelegate : Bool = false
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var childVcs :[UIViewController]
    fileprivate weak var parentVc : UIViewController?//改成弱引用，在闭包里面使用

    //使用弱引用防止循环引用
    weak var delegate : PageContentViewDelegate?
    
    //Mark : 懒加载集合视图，然后设置frame、滚动、间距等
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        //1、设置布局  属性的大小、间距、滚动方向
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0  //最小行间距
        layout.minimumInteritemSpacing = 0 //最小item间隔
        layout.scrollDirection = .horizontal //水平滚动
        
        //2、设置collectionView视图 设置相应的页面属性
        let collectionView = UICollectionView(frame:CGRect.zero,collectionViewLayout:layout)
        collectionView.showsHorizontalScrollIndicator = false//消除水平滚动条
        collectionView.bounces = false //消除弹簧效果
        collectionView.isPagingEnabled = true //一页一页滚动
        
        //3、设置数据源代理、注册cell类
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        //4、设置操作代理
        collectionView.delegate = self
        
        return collectionView
    }()
    
    
    //将需要的数据全部初始化到视图里面 frame,子视图、父视图
    init(frame:CGRect,childVcs:[UIViewController],parentVc:UIViewController?) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 1、设置UI视图
 */
extension PageContentView{
    fileprivate func setupUI(){
        //取出数组中的所有视图，然后添加到父视图上
        for childVc in childVcs {
            parentVc?.addChildViewController(childVc)
        }
        addSubview(collectionView)
      
    }
    
    
}

/*
 2、遵循UICollectionViewDataSource协议的数据源代理
 */
extension PageContentView:UICollectionViewDataSource{
   //设置有几个item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.childVcs.count
    }
    
    
    //在Item中填充数据
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        //设置重用
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        //当cell重用的时候会导致重叠的问题，所以将cell.contentView上面的子视图全部取出来，把它们一一移除，这是解决问题的一种方法，如果子视图过多的话，每次重用的时候都会一一把子视图移除会在程序的执行效率上产生问题。
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        //childVc的frame设置，并添加到cell中
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
    
}


/*
 3、cell操作代理UICollectionViewDelegate
 */
extension PageContentView : UICollectionViewDelegate{
    //1.开始拖动时的代理
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    
    //2.滚动的时候调用，可以一直监控滚动的距离。这样的话在cell滚动的时候，title也会跟着做平滑的滚动，更加生动。  各种代理意义：https://www.cnblogs.com/longiang7510/p/5368197.html
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //2.1是点击传导过来的，则不处理 因为没啥意义
        if isForbidScrollDelegate { return }
        
        //2.2在滚动时的逻辑处理，主要是计算滚动的百分比，然后传递给title也产生相应的联动
        var progress : CGFloat = 0
        var sourceIndex :Int = 0
        var targetIndex :Int = 0
        let currentOffsetX = scrollView.contentOffset.x//滚动的距离 X
        let scrollViewW = scrollView.bounds.width//scrollview的宽度
        /*
         A:向后滑动的情况
         */
        if currentOffsetX > startOffsetX {
            //计算滚动的进度
            progress = currentOffsetX/scrollViewW - floor(currentOffsetX/scrollViewW)
            sourceIndex = Int(currentOffsetX/scrollViewW)//当前的页面
            targetIndex = Int(currentOffsetX/scrollViewW)+1//下一个页面
            //如果指向最后一个页面，下一个目标要指向当前的页面
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            //完全滑过去
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            /*
             B:向前滑动的情况  当前X坐标小于起始坐标滴 所以计算都是反着来了
             */
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
        //定义的代理

        delegate!.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
}


/*
 4、对外公开的方法，pagetitleview的代理中调用  具体是啥功能呢？
 */
extension PageContentView{
    func setCurrentIndex(currentIndex : Int) {
        isForbidScrollDelegate = true
        let offsetX = CGFloat( currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x:offsetX,y:0), animated: false)
    }

}




















