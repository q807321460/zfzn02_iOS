//
//  SceneViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/1/2.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit

class SceneViewCtrl: UIViewController, ViewPagerIndicatorDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var m_viewPagerIndicator: ViewPagerIndicator!
    @IBOutlet weak var m_scrollView: UIScrollView!
    var m_nScrollViewHeight: CGFloat!
    var m_tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_nScrollViewHeight = m_scrollView.bounds.height
        m_viewPagerIndicator.titles = ["情景模式","联动场景"]
        m_viewPagerIndicator.delegate = self
        //ViewPagerIndicator样式设置
        m_viewPagerIndicator.setTitleColorForState(gDC.m_colorPurple, state: UIControlState.selected)//选中文字的颜色
        m_viewPagerIndicator.setTitleColorForState(gDC.m_colorFont, state: UIControlState())//正常文字颜色
        m_viewPagerIndicator.tintColor = gDC.m_colorPurple//指示器和基线的颜色
        m_viewPagerIndicator.showBottomLine = true//基线是否显示
        m_viewPagerIndicator.autoAdjustSelectionIndicatorWidth = false//下横线是否适应文字大小
        m_viewPagerIndicator.bouncySelectionIndicator = false
        //UIScrollView样式设置
        m_scrollView.isPagingEnabled = true
        m_scrollView.bounces = false
        m_scrollView.showsHorizontalScrollIndicator = false
        m_scrollView.showsVerticalScrollIndicator = false
        m_scrollView.delegate = self
        //内容大小
        m_scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(m_viewPagerIndicator.count ), height: m_nScrollViewHeight)
        //左侧视图添加一个tableview，右侧视图添加一个collectionview
        m_tableView = UITableView()
        m_tableView.bounces = false
        m_tableView.delegate = self
        m_tableView.dataSource = self
        m_tableView.tableFooterView = UIView()
        m_tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: m_nScrollViewHeight)
        m_scrollView.addSubview(m_tableView)
        m_tableView.register(MySceneCell.self, forCellReuseIdentifier: "mySceneCell")
        let nib = UINib(nibName: "MySceneCell", bundle: nil)
        m_tableView.register(nib, forCellReuseIdentifier: "mySceneCell")
        if gDC.m_nSelectSceneSequ != -1 {
            let mainStory = UIStoryboard(name: "Main",bundle: nil)
            let nextView = mainStory.instantiateViewController(withIdentifier: "scenePageViewCtrl") as! ScenePageViewCtrl
            for i in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[i].m_nSceneSequ == gDC.m_nSelectSceneSequ {
                    nextView.m_nSceneListFoot = i
                }
            }
            self.navigationController?.pushViewController(nextView, animated: true)
        }
        g_notiCenter.addObserver(self, selector:#selector(SceneViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        m_tableView.reloadData()
        if gDC.m_bQuickScene == true {//快捷跳转
            gDC.m_bQuickScene = false
            let mainStory = UIStoryboard(name: "Main",bundle: nil)
            let nextView = mainStory.instantiateViewController(withIdentifier: "scenePageViewCtrl") as! ScenePageViewCtrl
            for i in 0..<gDC.mSceneList.count {
                if gDC.mSceneList[i].m_nSceneSequ == gDC.m_nSelectSceneSequ {
                    nextView.m_nSceneListFoot = i
                }
            }
            self.navigationController?.pushViewController(nextView, animated: true)
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    //点击顶部选中后回调
    func indicatorChange(_ indicatorIndex: Int){
        m_scrollView.scrollRectToVisible(CGRect(x: self.view.bounds.width * CGFloat(indicatorIndex), y: 0, width: self.view.bounds.width, height: m_nScrollViewHeight), animated: true)
    }
    //滑动scrollview回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xOffset: CGFloat = scrollView.contentOffset.x
        let x: Float = Float(xOffset)
        let width:Float = Float(self.view.bounds.width)
        let index = Int((x + (width * 0.5)) / width)
        m_viewPagerIndicator.setSelectedIndex(index)//改变顶部选中
    }
    
    @IBAction func OnAdd(_ sender: AnyObject) {
        if gDC.mUserInfo.m_nIsAdmin == 0 {
            ShowNoticeDispatch("提示", content: "权限不足", duration: 0.5)
            return
        }
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "addSceneViewCtrl") as! AddSceneViewCtrl
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gDC.mSceneList.count
    }
    
    //每行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MySceneCell = tableView.dequeueReusableCell(withIdentifier: "mySceneCell", for: indexPath) as! MySceneCell
        for i in 0..<gDC.mSceneList.count {
            if gDC.mSceneList[i].m_nSceneSequ == indexPath.row {
                cell.m_imageScene.image = gDC.mSceneList[i].m_imageScene
                cell.m_labelSceneName.text = gDC.mSceneList[i].m_sSceneName
                break
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gDC.m_nSelectSceneSequ = -1
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "scenePageViewCtrl") as! ScenePageViewCtrl
        nextView.m_nSceneListFoot = indexPath.row
        self.navigationController?.pushViewController(nextView, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)//手指抬起后直接取消按下时的深色状态
    }
    
    func SyncData() {
        DispatchQueue.main.async {
            self.m_tableView.reloadData()
        }
    }
}




