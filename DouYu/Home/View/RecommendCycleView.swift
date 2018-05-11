//
//  RecommendCycleView.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/27.
//  Copyright © 2018年 zhangaki. All rights reserved.
//



import UIKit
private let CycleCellID = "CycleCellID"

class RecommendCycleView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!

//创建定时器
    var cycleTimer : Timer?
    
    //一旦数据有变化就刷新所有数据，重置数据。
    var cycleModels : [CycleModel]? {
        didSet{
            collectionView.reloadData()
            //??用于判断，前面的数据如果为nil，就取后面的数据0。
            pageControl.numberOfPages = cycleModels?.count ?? 0
            let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * 100, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            //移除定时器，然后重新添加定时器。
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing()
        
        //重用cell
        collectionView.register(UINib(nibName: "CollectionCycleCell",bundle:nil), forCellWithReuseIdentifier: CycleCellID)
        
    }
    
    //设置对cell的相应的适配  layoutSubviews中的适配才是准确的，否则bounds是xib中的宽高，出现不适配的情况。
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        
        //这些值都可以在xib中设置。
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal//水平移动
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension RecommendCycleView{
    //类方法，添加Xib
    class func recommendCycleView() -> RecommendCycleView {
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }
}
//这里要有具体的值，否则无法判断数据
extension RecommendCycleView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleCellID, for: indexPath) as! CollectionCycleCell
//        cell.cycleModel = cycleModels![indexPath.item % cycleModels!.count]
        return cell
    }
}




extension RecommendCycleView : UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    //开始拖动的时候移除定时器，=
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("开始拖动滚动条")
        removeCycleTimer()
    }
    //停止拖动重新添加定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
    
    
}

extension RecommendCycleView{
    fileprivate func addCycleTimer(){
        //定时器的写法
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        //将定时器添加到特定的RunLoopmode中，防止因为拖动导致的定时器暂停
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    //移除定时器，然后制nil
    fileprivate func removeCycleTimer(){
        //invalidate使无效、使作废
        cycleTimer?.invalidate()
        cycleTimer = nil
        
    }
    
    @objc fileprivate func scrollToNext(){
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width, y: 0), animated: true)
        
    }
}












