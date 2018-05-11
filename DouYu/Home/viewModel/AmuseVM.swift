//
//  AmuseVM.swift
//  DouYu
//
//  Created by 张张凯 on 2018/5/8.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class AmuseVM: BaseVM {

    func requestData(finishedCallback : @escaping () -> ()) {
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishedCallback: finishedCallback)
    }

}
