//
//  EditAreaViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/18.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//


import UIKit
private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height
private let CELL_WIDTH:CGFloat = (SCREEN_WIDTH - 2)/3

class EditAreaViewCtrl: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var sourceType = UIImagePickerControllerSourceType.photoLibrary //将sourceType赋一个初值类型，防止调用时不赋值出现崩溃
    @IBOutlet weak var m_eAreaName: UITextField!
    @IBOutlet weak var m_imageArea: UIImageView!
    @IBOutlet weak var m_collectionElectric: UICollectionView!
    @IBOutlet weak var m_btnDeleteElectric: UIButton!
    @IBOutlet weak var m_btnMoveElectricTo: UIButton!
    @IBOutlet weak var m_btnDeleteArea: UIButton!
    var m_nAreaListFoot:Int!
    var m_nBeginIndexPath: IndexPath?
    var m_nIndexPath: IndexPath?
    var m_nTargetIndexPath: IndexPath?
    var m_cellDraging: DeleteElectric!
    var m_nDraggedElectricIndex: Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_eAreaName.text = gDC.mAreaList[m_nAreaListFoot].m_sAreaName
        m_imageArea.image = gDC.mAreaList[m_nAreaListFoot].m_imageArea
        m_imageArea.isUserInteractionEnabled = true//设置允许交互属性
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(EditAreaViewCtrl.OnSelectImage(_:)))//将图片当做按钮来处理
        m_imageArea.addGestureRecognizer(tapGR)//添加交互
        m_btnDeleteElectric.layer.cornerRadius = 5.0
        m_btnDeleteElectric.layer.masksToBounds = true
        m_btnMoveElectricTo.layer.cornerRadius = 5.0
        m_btnMoveElectricTo.layer.masksToBounds = true
        m_btnDeleteArea.layer.cornerRadius = 5.0
        m_btnDeleteArea.layer.masksToBounds = true
        //设置与collection相关的参数
        m_collectionElectric.register(DeleteElectric.self, forCellWithReuseIdentifier: "deleteElectric")
        m_collectionElectric.register(UINib(nibName: "DeleteElectric", bundle: nil), forCellWithReuseIdentifier: "deleteElectric")
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(LongPressGesture(_:)))
        m_collectionElectric.addGestureRecognizer(longPress)
        m_cellDraging = Bundle.main.loadNibNamed("DeleteElectric", owner: self, options: nil)?.last as! DeleteElectric
        m_cellDraging.isHidden = true
        m_collectionElectric.addSubview(m_cellDraging)
        g_notiCenter.addObserver(self, selector:#selector(EditAreaViewCtrl.SyncData),name: NSNotification.Name(rawValue: "SyncData"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        m_collectionElectric.reloadData()
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        gDC.m_nSelectAreaSequ = gDC.mAreaList[self.m_nAreaListFoot].m_nAreaSequ
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnDeleteElectric(_ sender: AnyObject) {
        if (gDC.m_bRemote == true) {
            ShowNoticeDispatch("提示", content: "远程状态下不允许删除电器", duration: 1.0)
            return
        }
        //如果有任意一个电器被选中，则将bHavingSelected置为ture
        var bHavingSelected:Bool = false
        for i in 0..<gDC.mAreaList[self.m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_bSelected == true {
                bHavingSelected = true
                break
            }
        }
        if bHavingSelected == false {//如果遍历发现并没有选中任何的电器，则弹出提示信息
            ShowInfoDispatch("提示", content: "请先选中电器再进行删除操作", duration: 1.0)
            return
        }
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("确定", action: {()->Void in
                //双重for循环是为了防止出现数组越界
                for _ in 0..<gDC.mAreaList[self.m_nAreaListFoot].mElectricList.count{
                    for i in 0..<gDC.mAreaList[self.m_nAreaListFoot].mElectricList.count {
                        if gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_bSelected == true {//如果该电器被选中
                            //如果删除的是摄像头的话，需要和当前账户解绑，解绑需要调用乐橙提供的api
                            if gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_nElectricType == 8 {
                                let sPhoneNumber = gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_sExtras//该摄像头的拥有者的手机号
                                GetLechageTokenGlobal(sPhoneNumber, isShowLoading: false)//获取指定手机号的token，konnn
                                UIDevice.unbindLechangeCamera(gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_sElectricCode)
                                if gDC.m_sUnbindSuccess == "true" {
                                    let webReturn:String = MyWebService.sharedInstance.DeleteElectric1(
                                        masterCode: gDC.mUserInfo.m_sMasterCode,
                                        electricCode: gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_sElectricCode,
                                        electricIndex: gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_nElectricIndex,
                                        electricSequ: gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_nElectricSequ,
                                        roomIndex: gDC.mAreaList[self.m_nAreaListFoot].m_nAreaIndex)
                                    gDC.m_sUnbindSuccess = "false"
                                    self.WebDeleteElectric(webReturn, currentI:i)
                                }else {
                                    ShowInfoDispatch("提示", content: "权限不足，无法解绑，请使用最初绑定的账号进行解绑", duration: 3.0)
                                }
                            }else {//如果是非摄像头的其他电器
                                //新版本无需再调用这个MyWebService.sharedInstance.DeleteSceneElectric接口了，该功能直接在服务器中完成
                                //删除这个电器
                                let webReturn:String = MyWebService.sharedInstance.DeleteElectric1(
                                    masterCode: gDC.mUserInfo.m_sMasterCode,
                                    electricCode: gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_sElectricCode,
                                    electricIndex: gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_nElectricIndex,
                                    electricSequ: gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_nElectricSequ,
                                    roomIndex: gDC.mAreaList[self.m_nAreaListFoot].m_nAreaIndex)
                                self.WebDeleteElectric(webReturn, currentI:i)
                            }
                            break//删除当前电器后一定要break，否则会导致数组越界
                        }
                    }
                }
                ShowInfoDispatch("提示", content: "操作完成", duration: 0.5)
            })
            alertView.showInfo("提示", subTitle: "该操作不可撤销，是否继续？", duration: 0)//时间间隔为0时不会自动退出
        })
    }
    
    @IBAction func OnMoveElectricTo(_ sender: Any) {
        //如果有任意一个电器被选中，则将bHavingSelected置为ture
        var bHavingSelected:Bool = false
        for i in 0..<gDC.mAreaList[self.m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[self.m_nAreaListFoot].mElectricList[i].m_bSelected == true {
                bHavingSelected = true
                break
            }
        }
        if bHavingSelected == false {//如果遍历发现并没有选中任何的电器，则弹出提示信息
            ShowInfoDispatch("提示", content: "请先选中电器再进行移动操作", duration: 1.0)
            return
        }
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        let nextView = mainStory.instantiateViewController(withIdentifier: "moveElectricViewCtrl") as! MoveElectricViewCtrl
        nextView.m_nAreaListFoot = self.m_nAreaListFoot
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    @IBAction func OnDelete(_ sender: AnyObject) {
        if gDC.mAreaList[m_nAreaListFoot].mElectricList.count != 0 {
            ShowNoticeDispatch("提示", content: "在删除房间之前请先删除所有电器", duration: 1.0)
            return
        }
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("确定", action: {()->Void in
                let webReturn = MyWebService.sharedInstance.DeleteRoom(gDC.mUserInfo.m_sMasterCode, roomIndex: gDC.mAreaList[self.m_nAreaListFoot].m_nAreaIndex, roomSequ: gDC.mAreaList[self.m_nAreaListFoot].m_nAreaSequ)
                self.WebDeleteArea(webReturn)
            })
            alertView.showInfo("提示", subTitle: "是否确认删除这个房间？", duration: 0)//时间间隔为0时不会自动退出
        })
    }
    
    func OnSelectImage(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
        //从相册选取或是直接使用摄像头
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("相册", action: {() -> Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    if (PhotoLibraryPermissions() == true){
                        self.sourceType = UIImagePickerControllerSourceType.photoLibrary
                        self.OpenPhotoEdit()
                    }else {
                        ShowNoticeDispatch("提示", content: "请在设置中打开图库权限", duration: 1.0)
                    }
                }else{
                    ShowNoticeDispatch("提示", content: "未知的错误", duration: 0.5)
                }
            })
            alertView.addButton("拍摄", action: {() ->Void in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    if(CameraPermissions() == true){
                        self.sourceType = UIImagePickerControllerSourceType.camera
                        self.OpenPhotoEdit()
                    }else {
                        ShowNoticeDispatch("提示", content: "请在设置中打开摄像头权限", duration: 1.0)
                    }
                }else{
                    ShowNoticeDispatch("提示", content: "未知的错误", duration: 0.5)
                }
            })
            alertView.showInfo("操作", subTitle: "请选择一个修改区域图片的方式", duration: 0)//时间间隔为0时不会自动退出
        })
    }
    
    @IBAction func OnSave(_ sender: AnyObject) {
        //确保输入了房间名
        if m_eAreaName.text == "" {
            ShowNoticeDispatch("错误", content: "房间名不能为空", duration: 1.0)
            return
        }
        //判断是否和之前的区域名字重复
        for i in 0..<gDC.mAreaList.count {
            if i == m_nAreaListFoot {//不需要检测同一房间
                continue
            }
            if gDC.mAreaList[i].m_sAreaName == m_eAreaName.text {
                ShowNoticeDispatch("提示", content: "该房间名已被使用", duration: 1.0)
                return
            }
        }
        //向web发送更新指令
        let webReturn:String = MyWebService.sharedInstance.UpdateUserRoom(gDC.mUserInfo.m_sMasterCode, roomIndex:gDC.mAreaList[m_nAreaListFoot].m_nAreaIndex, roomName:m_eAreaName.text!, roomImg:0)
        WebUpdateArea(webReturn)
    }
    
    func SetImageName(type:Int, orderInfo: String) -> String {
        switch type {
        case 1:
            return "电器_一键开关_关"
        case 2:
            if orderInfo == "01" {
                return "电器_两键开关_左关"
            }else {
                return "电器_两键开关_右关"
            }
        case 3:
            if orderInfo == "01" {
                return "电器_三键开关_左关"
            }else if orderInfo == "02" {
                return "电器_三键开关_中关"
            }else {
                return "电器_三键开关_右关"
            }
        case 4, 10:
            if orderInfo == "01" {
                return "电器_四键开关_左上关"
            }else if orderInfo == "02" {
                return "电器_四键开关_右上关"
            }else if orderInfo == "03" {
                return "电器_四键开关_左下关"
            }else {
                return "电器_四键开关_右下关"
            }
        default:
            return gDC.m_arrayElectricImage[type] as! String
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    //MARK: - 长按动作
    func LongPressGesture(_ tap: UILongPressGestureRecognizer) {
        let point = tap.location(in: m_collectionElectric)
        switch tap.state {
        case UIGestureRecognizerState.began:
            dragBegan(point: point)
        case UIGestureRecognizerState.changed:
            drageChanged(point: point)
        case UIGestureRecognizerState.ended:
            drageEnded(point: point)
        case UIGestureRecognizerState.cancelled:
            drageEnded(point: point)
        default: break
        }
    }
    
    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        m_nIndexPath = m_collectionElectric.indexPathForItem(at: point)
        if (m_nIndexPath == nil) {// || (m_nIndexPath?.row)! >= gDC.mAreaList[m_nAreaListFoot].mElectricList.count
            return
        }
        m_nBeginIndexPath = m_nIndexPath//用于记录最开始的sequ值，方便长久保存排序顺序
        //将所有电器的选中状态取消掉
        for electric in gDC.mAreaList[m_nAreaListFoot].mElectricList {
            electric.m_bSelected = false
            if (electric.m_nElectricSequ == m_nBeginIndexPath?.row) {
                m_nDraggedElectricIndex = electric.m_nElectricIndex
            }
        }
        let item = m_collectionElectric.cellForItem(at: m_nIndexPath!) as? DeleteElectric
        item?.isHidden = true
        //在这里显示并初始化m_cellDraging这个单元
        m_cellDraging.isHidden = false
        m_cellDraging.frame = (item?.frame)!
        m_cellDraging.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        for i in 0..<gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            if (gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricSequ == m_nBeginIndexPath?.row) {
                let sElectricName:String = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sElectricName
                m_cellDraging.m_labelElectric.text = sElectricName
                m_cellDraging.m_imageSelected.isHidden = true
                let nType = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricType
                let sOrderInfo = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo
                m_cellDraging.m_imageElectric.image = UIImage(named : SetImageName(type: nType, orderInfo: sOrderInfo))
            }
        }
    }
    //MARK: - 长按过程
    private func drageChanged(point: CGPoint) {
        if (m_nIndexPath == nil) {
            return
        }
        m_cellDraging.center = point
        m_nTargetIndexPath = m_collectionElectric.indexPathForItem(at: point)
        if (m_nTargetIndexPath == nil) {
            return
        }
        //交换位置
        m_collectionElectric.moveItem(at: m_nIndexPath!, to: m_nTargetIndexPath!)
        m_nIndexPath = m_nTargetIndexPath
    }
    
    //MARK: - 长按结束
    private func drageEnded(point: CGPoint) {
        if (m_nIndexPath == nil) {
            return
        }
        let endCell = m_collectionElectric.cellForItem(at: m_nIndexPath!)
        UIView.animate(withDuration: 0.25, animations: {
            self.m_cellDraging.transform = CGAffineTransform.identity
            self.m_cellDraging.center = (endCell?.center)!
        }, completion: {
            (finish) -> () in
            endCell?.isHidden = false
            self.m_cellDraging.isHidden = true
            self.m_nIndexPath = nil
        })
        if (m_nIndexPath == m_nBeginIndexPath) {//位置没有变化的时候，不需要调用服务器的接口
            return
        }
        //调用服务器接口，实现sequ的换位
        let webReturn = MyWebService.sharedInstance.UpdateElectricSequ(masterCode: gDC.mUserInfo.m_sMasterCode, electricIndex: m_nDraggedElectricIndex, roomIndex: gDC.mAreaList[m_nAreaListFoot].m_nAreaIndex, oldElectricSequ: (m_nBeginIndexPath?.row)!, newElectricSequ: (m_nIndexPath?.row)!)
        WebUpdateElectricSequ(webReturn, electricIndex: m_nDraggedElectricIndex, oldSequ: (m_nBeginIndexPath?.row)!, newSequ: (m_nIndexPath?.row)!)
        m_collectionElectric.reloadData()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return gDC.mAreaList[m_nAreaListFoot].mElectricList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let viewWidth = collectionView.frame.width
        let cellWidth = (viewWidth-2)/3
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //返回Cell内容，这里我们使用刚刚建立的defaultCell作为显示内容
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deleteElectric", for: indexPath) as! DeleteElectric
        for i in 0..<gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricSequ == indexPath.row {
                if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_bSelected == true {
                    cell.m_imageSelected.isHidden = false
                }else {
                    cell.m_imageSelected.isHidden = true
                }
                cell.m_labelElectric.text = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sElectricName
                let nElectricType = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricType
                let sOrderInfo = gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_sOrderInfo
                cell.m_imageElectric.image = UIImage(named: SetImageName(type: nElectricType, orderInfo: sOrderInfo))
            }
        }
        
        return cell
    }
    
    //实现UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //某个Cell被选择的事件处理
        for i in 0..<gDC.mAreaList[m_nAreaListFoot].mElectricList.count {
            if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_nElectricSequ == indexPath.row {
                if gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_bSelected == true {
                    gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_bSelected = false
                }else {
                    gDC.mAreaList[m_nAreaListFoot].mElectricList[i].m_bSelected = true
                }
            }
        }
        collectionView.reloadData()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //    打开图库或相机
    func OpenPhotoEdit(){
//        m_bEditImage = true
        let imagePickerController:UIImagePickerController = UIImagePickerController()
        //各种编辑图片的设置
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false//true为拍照、选择完进入图片编辑模式
        imagePickerController.sourceType = sourceType
        //        imagePickerController.size
        self.present(imagePickerController, animated: true, completion:{
            print("进入imagePickerController")
        })
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //在ImageCropper自定义编辑界面中点击取消
    func imageCropperDidCancel(_ cropperViewController: VPImageCropperViewController!) {
        return
    }
    
    //在ImageCropper自定义编辑界面点击完成
    func imageCropper(_ cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        cropperViewController.dismiss(animated: true, completion: {()->Void in
            self.m_imageArea.image = editedImage
        })
    }
    
    //    取消图片选择操作
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //    选择完图片操作
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        //在这里调用网络通讯方法，上传图片至服务器...
        let width_view:CGFloat = self.view.bounds.width
        let height_view:CGFloat = self.view.bounds.height
        let height_image:CGFloat = width_view*40/72
        self.dismiss(animated: true, completion: {()->Void in
            let imgCropper:VPImageCropperViewController = VPImageCropperViewController.init(image: image, cropFrame: CGRect(x: 0,y: (height_view-height_image)/2,width: width_view,height: height_image), limitScaleRatio: 3)
            imgCropper.delegate = self
            self.present(imgCropper, animated: true, completion: nil)
        })
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateArea(_ responseValue:String){
        switch responseValue{
        case "WebError":
            break
        case "1":
//            //修改到本地数据库
//            let setDict:NSMutableDictionary = ["room_name":m_eAreaName.text!]
//            let requiredDict:NSMutableDictionary = ["master_code":gDC.mUserInfo.m_sMasterCode, "room_index":gDC.mAreaList[m_nAreaListFoot].m_nAreaIndex]
//            gMySqlClass.UpdateSql(setDict, requiredData: requiredDict, table: "userroom")
            
            //将图片保存到本地，如果编辑过图片，则重新保存
            if m_imageArea.image != nil {
                gDC.mAreaList[m_nAreaListFoot].m_imageArea = m_imageArea.image!
                //如果该图片存在的话，首先删除该图片
                let fullPath = GetFileFullPath(gDC.mUserInfo.m_sMasterCode+"/area/", fileName: "\(gDC.mAreaList[m_nAreaListFoot].m_sAreaName).png")
                DeleteFile(fullPath)
                SaveImage(m_imageArea.image!, newSize: CGSize(width: 720, height: 400), percent: 0.5, imagePath: gDC.mUserInfo.m_sMasterCode+"/area/", imageName: "\(m_eAreaName.text!).png")
                self.navigationController?.popViewController(animated: true)
            }else {
                print("暂时不添加图片")
            }
            //修改内存数据
            gDC.mAreaList[m_nAreaListFoot].m_sAreaName = m_eAreaName.text!
            //同样也涉及到图片的上传和下载的问题
            gDC.m_bRefreshAreaList = true
            self.navigationController?.popViewController(animated: true)
        default:
            ShowNoticeDispatch("错误", content: "更新区域失败", duration: 1.0)
            break
        }
    }
    
    func WebDeleteArea(_ responseValue:String){
        switch responseValue{
        case "WebError":
            break
        case "1":
            //删除本地图片
            let fullPath = GetFileFullPath(gDC.mUserInfo.m_sMasterCode+"/area/", fileName: "\(gDC.mAreaList[m_nAreaListFoot].m_sAreaName).png")
            DeleteFile(fullPath)
            gDC.mAreaData.DeleteAreaByFoot(m_nAreaListFoot)
            //返回后保证能够刷新界面
            gDC.m_bRefreshAreaList = true
            //删除房间时，对应的界面并没有被释放掉，所以无法返回其父类视图
            self.navigationController?.popViewController(animated: true)
        default:
            ShowNoticeDispatch("错误", content: "区域删除失败", duration: 1.0)
            break
        }
    }
    
    func WebDeleteElectric(_ responseValue:String, currentI:Int) {
        switch responseValue{
        case "WebError":
            break
        case "1":
            gDC.mElectricData.DeleteElectric(
                masterCode: gDC.mUserInfo.m_sMasterCode,
                electricIndex: gDC.mAreaList[m_nAreaListFoot].mElectricList[currentI].m_nElectricIndex,
                electricSequ: gDC.mAreaList[m_nAreaListFoot].mElectricList[currentI].m_nElectricSequ,
                areaFoot: m_nAreaListFoot)
            //返回后保证能够刷新界面
            gDC.m_bRefreshAreaList = true
            m_collectionElectric.reloadData()
        default:
            ShowNoticeDispatch("错误", content: "电器删除失败", duration: 1.0)
            break
        }
    }
    
    func WebUpdateElectricSequ(_ responseValue:String, electricIndex:Int, oldSequ:Int, newSequ:Int) {
        switch responseValue{
        case "WebError":
            break
        case "1":
            gDC.mElectricData.UpdateElectricSequ(electricIndex: electricIndex, roomFoot: m_nAreaListFoot, oldSequ: oldSequ, newSequ: newSequ)
            gDC.m_bRefreshAreaList = true
        default:
            ShowNoticeDispatch("错误", content: "电器位置调整失败", duration: 0.8)
            break
        }
    }
    
    func SyncData() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
