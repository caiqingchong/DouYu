
//
//  HttpTools.swift
//  DouYu
//
//  Created by 张张凯 on 2018/4/25.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType {
    case get
    case post
}

//设置网络请求
class HttpTools {
    class func requestData(_ type:MethodType , URLString : String,parameters:[String:Any]? = nil,finishedCallback : @escaping (_ result : Any) -> ()) {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post

        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error as Any)
                return
            }
            finishedCallback(result)
        }
    }
    

}
