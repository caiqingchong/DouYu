//
//  MenuViewCell.swift
//  1106-douyu
//
//  Created by targetcloud on 2016/11/11.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

private let MenuViewCellID = "MenuViewCellID"

class MenuViewCell: UICollectionViewCell {

    var groups : [AnchorGroup]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: MenuViewCellID)
    }
    
    /*
     这里有个大坑，要注意一下，不要使用collectionView，因为这个cell上面添加了collectionView，所以大小也是cell的大小。
     所以不可以再使用它的计量单位。
     
     */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //设置cell的宽度为view的1/4,高度为1/2。那么就相当于设置cell每页数据为两行，每行四个cell。
        let itemW = UIScreen.main.bounds.size.width / 4
//        let itemH = collectionView.bounds.height / 2
        
//        print("打印cell的宽高分别为W:\(itemW)------H:\(itemH)")
        layout.itemSize = CGSize(width: itemW, height: 90)
    }

}

extension MenuViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuViewCellID, for: indexPath) as! CollectionGameCell
        cell.game = groups![indexPath.item]
        cell.clipsToBounds = true//去掉底线
        return cell
    }
}
