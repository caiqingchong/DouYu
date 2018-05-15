//
//  FunnyVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//


import UIKit
private let MenuCellID = "MenuCellID"

class MenuView: UIView {

    var groups : [AnchorGroup]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIViewAutoresizing()
        //注册  MenuViewCell
        collectionView.register(UINib(nibName: "MenuViewCell", bundle: nil), forCellWithReuseIdentifier: MenuCellID)
//        print(collectionView.bounds);//(0.0, 0.0, 375.0, 181.0) xib大小
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
        collectionView.dataSource = self
        collectionView.delegate = self
        //注意去掉xib 中Menu View 中的autosizing四条线（< 、^、 右、下、）否则下面打印的为 (0.0, 0.0, 414.0, 33.0)
        //如果不使用上面的方法，也可以使用autoresizingMask = UIViewAutoresizing() , 这条语句写在override func awakeFromNib() {中
        //print(collectionView.bounds);//(0.0, 0.0, 414.0, 181.0) 实际大小
    }
}

//加载MenuView的Xib视图
extension MenuView {
    class func menuView() -> MenuView {
        return Bundle.main.loadNibNamed("MenuView", owner: nil, options: nil)?.first as! MenuView
    }
}

extension MenuView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if groups == nil { return 0 }
        /*
         判断显示pageControl的显示：
         1、如果在一个页面中（8个cell），隐藏cell。
         2、否则显示pageControl的个数。
         */
        let pageNum = (groups!.count - 1) / 8 + 1
        pageControl.numberOfPages = pageNum
        if pageNum <= 1 {
            pageControl.isHidden = true
        }
        return pageNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCellID, for: indexPath) as! MenuViewCell
        setupCellDataWithCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func setupCellDataWithCell(cell : MenuViewCell, indexPath : IndexPath) {
        let startIndex = indexPath.item * 8
        var endIndex = (indexPath.item + 1) * 8 - 1
        if endIndex > groups!.count - 1 {
            endIndex = groups!.count - 1
        }
        cell.groups = Array(groups![startIndex...endIndex])
    }
}







//使用pageControl与UICollectionViewDelegate进行联动，在移动的时候触发代理，移动pageControl，完美！
extension MenuView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
    }
    

}





