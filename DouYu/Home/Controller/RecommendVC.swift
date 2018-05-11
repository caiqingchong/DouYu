//
//  RecommendVC.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/26.
//  Copyright © 2018年 zhangaki. All rights reserved.
//


/*
 设置滚动式图可以分为两种方式，一种是使用第三方OC的要进行桥接，另一种使用字写的方法来
 1、使用OC中常用的第三方SDCycleScrollView来设置滚动视图，进行桥接。这里注意不要从cocoapods中获取第三方，否则是找不到SDCycleScrollView文件的。这一点目前没找到原因。
 2、使用scrollView或者collectionView两种方法来实现，这里我们使用collectionView来实现，它更加的高效。
 步骤：使用xib来进行关联
 */

/*
 在项目中的发现：
 1、在collectionVIew中添加的视图，如果滑到最后一个还接着滑动会滑到下一个页面。
 问题的原因是并没有将添加的游戏、轮滑视图添加的collectionView中，而是添加到了页面的view中。所以会被滑动到下一个界面
 解决方法:添加到collectionView中去。
 */


import UIKit
private let kCycleViewH : CGFloat = kScreenW * 3 / 8
private let kGameViewH : CGFloat = 90
//private let PrettyCellID = "PrettyCellID"

class RecommendVC: BaseAnchorVC {
    fileprivate lazy var recommendVM : RecommendVM = RecommendVM()

    
    //懒加载滚动式图
    fileprivate lazy var cycleView : RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        //设置frame  
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH+kGameViewH), width: kScreenW, height: kCycleViewH)
        
        cycleView.backgroundColor = UIColor.blue
        return cycleView
    }()
    
    //懒加载设置game滚动式图
    
    /*
     为啥子没有显示，连cell的图标都没有text
     这里创建的view是有的
     */
    fileprivate lazy var gameView : RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        gameView.backgroundColor = UIColor.orange
        return gameView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        super.setupUI()
        collectionView.addSubview(cycleView)
        collectionView.addSubview(gameView)
        //边距是两个额外的视图
        
        //这里是重点，这里可以扩展collectionView的空间大小，让视图填充
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH+kGameViewH, left: 0, bottom: 0, right: 0)
        
        
        loadGameData()
        /*
         使用OC的第三方SDCycleScrollView 但是这里请注意一下，要进行必要的设置，且不能使用pods里面的的第三方，会出现找不到的情况。拖拽进去的没有问题，也是非常奇怪了。 设置网址：https://www.cnblogs.com/keqipu/p/6543830.html
         */
        /*
        let imageNames = ["1.png", "2.png", "3.png", "4.png","5.png"]
        let cycleScrollView = SDCycleScrollView.init(frame: CGRect (x: 0, y: 0, width: self.view.frame.size.width, height: 200), shouldInfiniteLoop: true, imageNamesGroup: imageNames)
        cycleScrollView?.autoScrollTimeInterval = 5.0
        cycleScrollView?.delegate = self
        self.view.addSubview(cycleScrollView!)
        */
        
    }

}


extension RecommendVC {
     func loadGameData(){
       baseVM = recommendVM
        
        recommendVM.requestData {
            self.collectionView.reloadData()
            
            //进行二次处理，将之前的收全部清空  移除两次的原因是啥来这
            
            var gameGroups = self.recommendVM.anchorGroups
            gameGroups.removeFirst()
            gameGroups.removeFirst()
            gameGroups.remove(at: 1)
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            gameGroups.append(moreGroup)
            self.gameView.groups = gameGroups
//            print("self.gameView.groups获取的值为:\(String(describing: self.gameView.groups))")
            self.loadDataFinished()
            
        }
        
//        请求循环的数据
        recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
        
        
    }
}

//进行数据装填

extension RecommendVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }else{
            return CGSize(width: kNormalItemW, height: kNormalItemH)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrettyCellID, for: indexPath) as! CollectionPrettyCell
            cell.anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
            return cell
        }else{
            //            cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCellID, for: indexPath) as! CollectionNormalCell
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
}
/** 点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;
*/

/*
 1、按照swift的代理执行方式来就可以。
 */
extension RecommendVC : SDCycleScrollViewDelegate{
    //图片滚动回调
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        print("图片滚动回调\(index)")
    }
    //点击图片回调
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print("点击图片回调\(index)")
    }
}





