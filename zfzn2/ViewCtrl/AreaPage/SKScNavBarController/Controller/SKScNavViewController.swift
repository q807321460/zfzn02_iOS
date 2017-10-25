//
//  SKScNavViewController.swift
//  SCNavController
//
//  Created by lanouhn on 15/10/29.
//  Copyright © 2015年 Sue. All rights reserved.
//

import UIKit

class SKScNavViewController: UIViewController, SKScNavBarDelegate, UIScrollViewDelegate {

    //MARK:必须设置的一些属性
    /**
     * @param scNaBarColor
     * @param showArrowButton
     * @param lineColor
     */
    //MARK: -- 公共设置属性
    /**
     * 是否显示扩展按钮
     */
    var showArrowButton:Bool!         // 默认值是true
    /**
     * 导航栏的颜色
     */
    var scNavBarColor:UIColor!        //默认值clearColor
    /**
     * 扩展按钮上的图片
     */
    var scNavBarArrowImage:UIImage!
    /**
     * 包含所有子视图控制器的数组
     */
    var subViewControllers:NSArray!
    /**
     * 线的颜色
     */
    var lineColor:UIColor!           //默认值redColor
    
    /**
     * 扩展菜单栏的高度
     */
    var launchMenuHeight:CGFloat!
    
    //MARK: -- 私有属性
    fileprivate var currentIndex:Int!       //当前显示的页面的下标
    fileprivate var titles:NSMutableArray!  //子视图控制器的title数组
    fileprivate var scNavBar:SKScNavBar!    //导航栏视图
    open var mainView:UIScrollView!  //主页面的ScrollView
    
    //MARK: ----- 方法 -----
    
    //MARK: -- 外界接口
    
    /**
     * 初始化withShowArrowButton
     * @param showArrowButton 显示扩展菜单按钮
     */
    init(show:Bool){
        super.init(nibName: nil, bundle: nil)
        self.showArrowButton = show
    }
    
    /**
     * 初始化withSubViewControllers
     * @param subViewControllers 子视图控制器数组
     */
    init(subViewControllers:NSArray) {
        super.init(nibName: nil, bundle: nil)
        self.subViewControllers = subViewControllers
    }
    
    /**
     * 初始化withParentViewController
     * @param parentViewController 父视图控制器
     */
    init(parentViewController:UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.addParentController(parentViewController)
    }
    
    /**
     * 初始化SKScNavBarController
     * @param subViewControllers   子视图控制器
     * @param parentViewController 父视图控制器
     * @param show 是否显示展开扩展菜单栏按钮
     */
    init(subViewControllers:NSArray, parentViewController:AreaViewCtrl, show:Bool) {
        super.init(nibName: nil, bundle: nil)
        self.subViewControllers = subViewControllers
        self.showArrowButton = show
        self.addParentController(parentViewController)
    }
    /**
     * 添加父视图控制器的方法
     * @param viewController 父视图控制器
     */
    func addParentController(_ viewcontroller:UIViewController) {
        if viewcontroller.responds(to: #selector(getter: UIViewController.edgesForExtendedLayout)) {
            viewcontroller.edgesForExtendedLayout = UIRectEdge()
        }
        
        viewcontroller.addChildViewController(self)
        viewcontroller.view.addSubview(self.view)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        //调用初始化属性的方法
        initParamConfig()
        //调用初始化、配置视图的方法
        viewParamConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: -- 私有方法
    
    //初始化一些属性
    fileprivate func initParamConfig() {
        //初始化一些变量
        currentIndex = 1
        scNavBarColor = scNavBarColor != nil ? scNavBarColor : kNavColor
        if scNavBarArrowImage == nil {
            scNavBarArrowImage = UIImage(named: "arror.png")
        }
        if showArrowButton == nil {
            showArrowButton = true
        }
        if lineColor == nil {
            lineColor = UIColor.red
        }
        //获取所有子视图控制器上的title
        titles = NSMutableArray(capacity: subViewControllers.count)
        for vc in subViewControllers {
            titles.add((vc as AnyObject).navigationItem.title!)
        }
    }
    
    //初始化视图
    fileprivate func initWithScNavBarAndMainView() {
        scNavBar = SKScNavBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScNavBarHeight), show: showArrowButton, image: scNavBarArrowImage)
        scNavBar.delegate = self
        scNavBar.backgroundColor = scNavBarColor
        scNavBar.itemsTitles = titles
        scNavBar.lineColor = lineColor
        scNavBar.setItemsData()
        
        mainView = UIScrollView(frame: CGRect(x: 0, y: scNavBar.frame.origin.y + scNavBar.frame.size.height, width: kScreenWidth, height: kScreenHeight - scNavBar.frame.origin.y - scNavBar.frame.size.height))
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.bounces = false
        mainView.showsHorizontalScrollIndicator = false
        mainView.contentSize = CGSize(width: kScreenWidth * CGFloat(subViewControllers.count), height: 0)
        view.addSubview(mainView)
        view.addSubview(scNavBar)
    }
    
    //配置视图参数
    fileprivate func viewParamConfig() {
        
        initWithScNavBarAndMainView()
        
        //将子视图控制器的view添加到mainView上
        subViewControllers.enumerateObjects( { (_, index:Int, _) -> Void in
            let vc = self.subViewControllers[index] as! UIViewController
            vc.view.frame = CGRect(x: CGFloat(index) * kScreenWidth, y: 0, width: kScreenWidth, height: self.mainView.frame.size.height)
            self.mainView.addSubview(vc.view)
            self.mainView.backgroundColor = UIColor.white
            self.addChildViewController(vc)
        })
    }
    
    //MARK: -- ScrollView Delegate 方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / kScreenWidth)
        scNavBar.setViewWithItemIndex = currentIndex
    }
    
    //MARK: -- SKScNavBarDelegate 中的方法
    func didSelectedWithIndex(_ index: Int) {
        gDC.m_nSelectAreaSequ = index
        mainView.setContentOffset(CGPoint(x: CGFloat(index) * kScreenWidth, y: 0), animated: true)
    }
    
    func isShowScNavBarItemMenu(_ show: Bool, height: CGFloat) {
        if show {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.scNavBar.frame = CGRect(x: self.scNavBar.frame.origin.x, y: self.scNavBar.frame.origin.y, width: kScreenWidth, height: height)
            }) 
        }else{
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.scNavBar.frame = CGRect(x: self.scNavBar.frame.origin.x, y: self.scNavBar.frame.origin.y, width: kScreenWidth, height: kScNavBarHeight)
            })
        }
        scNavBar.refreshAll()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
