//
//  AddAreaViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/12/16.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit

class AddAreaViewCtrl: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate {

    var sourceType = UIImagePickerControllerSourceType.photoLibrary //将sourceType赋一个初值类型，防止调用时不赋值出现崩溃
    @IBOutlet weak var m_eAreaName: UITextField!
    @IBOutlet weak var m_imageArea: UIImageView!
    @IBOutlet weak var m_btnSave: UIButton!
    var m_nIndexMax:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_imageArea.isUserInteractionEnabled = true//设置允许交互属性
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(AddAreaViewCtrl.OnSelectImage(_:)))//将图片当做按钮来处理
        m_imageArea.addGestureRecognizer(tapGR)//添加交互
        m_btnSave.layer.cornerRadius = 5//实现按钮左右两侧完整的圆角
        m_btnSave.layer.masksToBounds = true//允许圆角
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    func OnSelectImage(_ sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
        //从相册选取或是直接使用摄像头
        DispatchQueue.main.async(execute: {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("相册", action: {
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
            alertView.addButton("拍摄", action: {
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
            alertView.showInfo("提示", subTitle: "搜索完成，请选择一个主节点", duration: 0)//时间间隔为0时不会自动退出
        })
    }

    @IBAction func OnSave(_ sender: UIButton) {
        //确保输入了房间名
        if m_eAreaName.text == "" {
            ShowNoticeDispatch("错误", content: "房间名不能为空", duration: 0.5)
            return
        }
        //判断是否和之前的区域名字重复
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_sAreaName == m_eAreaName.text {
                ShowNoticeDispatch("提示", content: "该房间名已被使用", duration: 0.5)
                return
            }
        }
        
        //寻找最大的房间号
        for i in 0..<gDC.mAreaList.count {
            if gDC.mAreaList[i].m_nAreaIndex > m_nIndexMax {
                m_nIndexMax = gDC.mAreaList[i].m_nAreaIndex
            }
        }
        m_nIndexMax = m_nIndexMax + 1
        let webReturn:String = MyWebService.sharedInstance.AddUserRoom(gDC.mUserInfo.m_sMasterCode, roomName: m_eAreaName.text!, roomIndex: m_nIndexMax, roomSequ: gDC.mAreaList.count)
        WebAddArea(webReturn)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebAddArea(_ responseValue:String){
        switch responseValue{
        case "WebError":
            //错误的提示已经在WS类中处理过了
            break
        case "-2":
            print("添加失败")
            ShowNoticeDispatch("错误", content: "未知的失败", duration: 0.5)
        case "1":
            ShowInfoDispatch("提示", content: "房间添加成功", duration: 0.5)
            //添加到本地数据库
            gDC.mAreaData.AddArea(m_eAreaName.text!, areaIndex:m_nIndexMax, areaSequ:gDC.mAreaList.count)
            //将图片保存到本地
            if (m_imageArea.image != nil) {
                SaveImage(m_imageArea.image!, newSize: CGSize(width: 720, height: 400), percent: 0.5, imagePath: gDC.mUserInfo.m_sMasterCode+"/area/", imageName: "\(m_eAreaName.text!).png")
                gDC.mAreaList[gDC.mAreaList.count-1].m_imageArea = m_imageArea.image!//同时保存到内存数据中，默认是在数组的最后一个中
            }else {
                print("下次再编辑图片")
            }
            gDC.m_nSelectAreaSequ = gDC.mAreaList.count - 1
            gDC.m_bRefreshAreaList = true
            self.navigationController?.popViewController(animated: true)
        case "2":
            ShowNoticeDispatch("错误", content: "已添加过该房间", duration: 0.5)
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
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
    
    ////////////////////////////////////////////////////////////////////////////////////
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
    //    打开图库或相机
    func OpenPhotoEdit(){
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
    
}
