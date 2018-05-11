//
//  MainVC.swift
//  DouYu
//
//  Created by 张齐 on 2018/4/23.
//  Copyright © 2018年 zhangaki. All rights reserved.
//

import UIKit

class MainVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /*
         要有集中化处理的思想！ 数组就是一个很好的方式
         */
        let homeVC = HomeViewController()
        let liveVC = LiveViewController()
        let videoVC = VideoViewController()
        let followVC = FollowViewController()
        let profileVC = ProfileViewController()
        
        let VCArr = [homeVC,liveVC,videoVC,followVC,profileVC]
        
        let titleArr = ["首页","直播","视频","关注","我的"]
        let NormalImageArr = ["tabMine","tabLiving","tabVideo","tabFocus","tabHome"]
        let SelectImageArr = ["tabMineHL","tabLivingHL","tabVideoHL","tabFocusHL","tabHomeHL"]
        
        
        
        //swift初始化数组
        let tabArray = NSMutableArray()
        for index in 0..<titleArr.count {
            let vc = VCArr[index]
//            vc.title = titleArr[index]
            
            //设置图片和文字一起变色 参考文章：http://www.hangge.com/blog/cache/detail_1002.html
            self.tabBar.tintColor = UIColor.orange
            let Nav = UINavigationController(rootViewController:vc)
    
            let item : UITabBarItem = UITabBarItem (title:titleArr[index], image: UIImage(named: NormalImageArr[index]), selectedImage: UIImage(named:SelectImageArr[index]))
            vc.tabBarItem = item
            //            self.addChildViewController(vc)  这样没有导航栏奥，注意！
            
            tabArray.add(Nav)
        }
        self.viewControllers = (tabArray as! [UIViewController])
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

