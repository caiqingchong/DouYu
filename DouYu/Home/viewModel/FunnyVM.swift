//
//  FunnyVM.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/8.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class FunnyVM: BaseVM {

    func requestData(finishedCallback : @escaping () -> ()) {
        
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/homeCate/getHotRoom?client_sys=ios&identification=393b245e8046605f6f881d415949494c",finishedCallback: finishedCallback)
    }
}
