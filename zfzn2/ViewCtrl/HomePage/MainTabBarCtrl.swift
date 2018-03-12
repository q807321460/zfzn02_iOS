//
//  MainTabBarCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/10/25.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class MainTabBarCtrl: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        initTabBarSelectedItem()
        initTabBarSelectedItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTabBarSelectedItem(){
        let tabBar = self.tabBar
        
        //设置第一个图标
        let homeItem = (tabBar.items?[0])! as UITabBarItem
        var unSelectedImg = UIImage(named: "主视图_首页.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        homeItem.image = unSelectedImg
        var selectedImg = UIImage(named: "主视图_首页_选中.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        homeItem.selectedImage = selectedImg
        homeItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.purple], for: UIControlState.selected)

        //设置第二个图标
        let areaItem = (tabBar.items?[1])! as UITabBarItem
        unSelectedImg = UIImage(named: "主视图_区域.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        areaItem.image = unSelectedImg
        selectedImg = UIImage(named: "主视图_区域_选中.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        areaItem.selectedImage = selectedImg
        areaItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.purple], for: UIControlState.selected)
        
        //设置第三个图标
        let releaseItem = (tabBar.items?[2])! as UITabBarItem
        unSelectedImg = UIImage(named: "主视图_情景.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        releaseItem.image = unSelectedImg
        selectedImg = UIImage(named: "主视图_情景_选中.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        releaseItem.selectedImage = selectedImg
        releaseItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.purple], for: UIControlState.selected)
        
        //设置第四个图标
        let myItem = (tabBar.items?[3])! as UITabBarItem
        unSelectedImg = UIImage(named: "主视图_安防.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myItem.image = unSelectedImg
        selectedImg = UIImage(named: "主视图_安防_选中.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        myItem.selectedImage = selectedImg
        myItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.purple], for: UIControlState.selected)
    }
    
//    func initTabBarSelectedItem2() {
//        let page1 = HomePageViewCtrl()
//        let page2 = UIViewController()
//        let page3 = UIViewController()
//        let page4 = UIViewController()
//        let navi1 = UINavigationController(rootViewController: page1)
//        let navi2 = UINavigationController(rootViewController: page2)
//        let navi3 = UINavigationController(rootViewController: page3)
//        let navi4 = UINavigationController(rootViewController: page4)
//        let controllers = [navi1, navi2, navi3,navi4]
//        self.viewControllers = controllers
//        navi1.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "主视图_首页.png"), tag: 1)
//        navi2.tabBarItem = UITabBarItem(title: "区域", image: UIImage(named: "主视图_区域.png"), tag: 2)
//        navi3.tabBarItem = UITabBarItem(title: "情景", image: UIImage(named: "主视图_情景.png"), tag: 3)
//        navi4.tabBarItem = UITabBarItem(title: "安防", image: UIImage(named: "主视图_安防.png"), tag: 4)
//    }

}

//// Add anywhere in your app
//extension UIImage {
//    func imageWithColor(_ tintColor: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//        
//        let context = UIGraphicsGetCurrentContext()! as CGContext
//        context.translateBy(x: 0, y: self.size.height)
//        context.scaleBy(x: 1.0, y: -1.0);
//        context.setBlendMode(.normal)
//        
//        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
//        context.clip(to: rect, mask: self.cgImage!)
//        tintColor.setFill()
//        context.fill(rect)
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }
//}
