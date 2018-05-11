//
//  BaseAnchorVC.swift
//  1106-douyu
//
//  Created by targetcloud on 2016/11/10.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kHeaderViewH : CGFloat = 50
private let NormalCellID = "NormalCellID"
private let HeaderViewID = "HeaderViewID"
let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4
let kPrettyItemH = kNormalItemW * 5 / 4
let PrettyCellID = "PrettyCellID"
//Anchor  美  ['æŋkɚ]
class BaseAnchorVC: BaseVC {
    
    // !表示用到的时候保证有值
    var baseVM : BaseVM!
    
    lazy var collectionView : UICollectionView = {[unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        //注册各种cell
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: NormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: PrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderViewID)
        
        return collectionView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameUI()
        loadData()
    }
    
}

extension BaseAnchorVC {
     func setupGameUI() {
        contentView = collectionView
        view.addSubview(collectionView)
        super.setupUI()
    }
}

extension BaseAnchorVC {
    func loadData() {
    }
}

extension BaseAnchorVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 4。结果是十个区，打印十个区中的内容
//        print("获取多少个区呢：\(baseVM.anchorGroups.count)-----------")

        return baseVM.anchorGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
        
        //问题，在这里。应该是没有将数组数据赋值到anchors数组中，导致无法取出数组全部为0。导致无cell的传参nil
        print("获取每个区中有多少个cell：\(baseVM.anchorGroups[section].anchors.count)")
        return baseVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCellID, for: indexPath) as! CollectionNormalCell
        
        cell.anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        print("获取cell的作者为:\(String(describing: cell.anchor?.room_name))")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.group = baseVM.anchorGroups[indexPath.section]
        return headerView
    }
    
}

extension BaseAnchorVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let anchor = baseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
//        anchor.isVertical == 0 ? pushNormalRoomVc(anchor) : presentShowRoomVc(anchor)
    }
    
//    private func presentShowRoomVc(_ anchor : AnchorModel) {
//        let showVc = ShowRoomVC()
//        showVc.anchor = anchor
//        present(showVc, animated: true, completion: nil)
//    }
//
//    private func pushNormalRoomVc(_ anchor : AnchorModel) {
//        let normalVc = NormalRoomVC()
//        normalVc.anchor = anchor
//        navigationController?.pushViewController(normalVc, animated: true)
//    }
}

