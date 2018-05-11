//
//  HandsVM.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/8.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class HandsVM: BaseVM {

    func requestData(finishedCallback : @escaping () -> ()) {
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/homeCate/getHotRoom?client_sys=ios&identification=3e760da75be261a588c74c4830632360", finishedCallback: finishedCallback)
    }
}
