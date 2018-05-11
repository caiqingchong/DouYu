
//
//  GameVM.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/8.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit


class GameVM: BaseVM {
    
    func requestData(finishedCallback : @escaping () -> ()) {
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/homeCate/getHotRoom?client_sys=ios&identification=ba08216f13dd1742157412386eee1225", finishedCallback: finishedCallback)
    }
}


