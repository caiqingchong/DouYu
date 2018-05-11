
//
//  BaseVM.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/4.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class BaseVM {
    
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    
    func loadAnchorData(isGroupData : Bool, URLString : String, parameters : [String : Any]? = nil, finishedCallback : @escaping () -> ()) {
        HttpTools.requestData(.get, URLString: URLString, parameters: parameters) { (result) in
            
            
            //校验数据，如果没有数据就直接返回
            guard let dict = result as? [String : Any] else { return }
            guard let arr = dict["data"] as? [[String : Any]] else { return }
            if isGroupData {
                for dict in arr {
                    

                    self.anchorGroups.append(AnchorGroup(dict: dict))
                }
            } else  {
                let group = AnchorGroup()
                for dict in arr {
                    group.anchors.append(AnchorModel(dict: dict))
                }
                self.anchorGroups.append(group)
            }
            finishedCallback()
        }
    }
    
    
    
}
