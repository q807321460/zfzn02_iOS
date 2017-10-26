//
//  AccountInfoViewCtrl.swift
//  zfzn2
//
//  Created by Hanwen Kong on 16/11/14.
//  Copyright © 2016年 Hanwen Kong. All rights reserved.
//

import UIKit
import Photos
import Foundation
class AccountInfoViewCtrl: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var m_tableAccountInfo: UITableView!
    var sheet:UIAlertController!
    var m_imageView:UIImage!
    var m_viewUpdatingPhoto:SCLAlertView! = nil
    var sourceType = UIImagePickerControllerSourceType.photoLibrary //将sourceType赋一个初值类型，防止调用时不赋值出现崩溃
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_tableAccountInfo.register(MyAccountImageCell.self, forCellReuseIdentifier: "myAccountImageCell")
        let nib1 = UINib(nibName: "MyAccountImageCell", bundle: nil)
        m_tableAccountInfo.register(nib1, forCellReuseIdentifier: "myAccountImageCell")
        
        m_tableAccountInfo.register(MyAccountInfoCell.self, forCellReuseIdentifier: "myAccountInfoCell")
        let nib2 = UINib(nibName: "MyAccountInfoCell", bundle: nil)
        m_tableAccountInfo.register(nib2, forCellReuseIdentifier: "myAccountInfoCell")
        
        self.automaticallyAdjustsScrollViewInsets = false//保证对齐顶端，去除的话，会在上部留出空白
//        m_tableAccountInfo.separatorStyle = UITableViewCellSeparatorStyle.None//不显示分割线
        m_tableAccountInfo.bounces = false//不需要弹簧效果
        m_tableAccountInfo.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        m_tableAccountInfo.reloadData()//修改数据返回时处理这个
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: {
            print("从个人账户界面返回到侧边栏界面")
        })
    }

    ////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    //每行的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:MyAccountImageCell = tableView.dequeueReusableCell(withIdentifier: "myAccountImageCell", for: indexPath) as! MyAccountImageCell
//            cell.m_imageAccount = UIImageView(image: UIImage(named: "首页_用户logo.png"))
            cell.m_imageAccount.image = gDC.mAccountInfo.m_imageAccountHead
            cell.m_imageAccount.layer.cornerRadius = 32//实现按钮左右两侧完整的圆角
            cell.m_imageAccount.layer.masksToBounds = true//允许圆角
            return cell
        }else {
            let cell:MyAccountInfoCell = tableView.dequeueReusableCell(withIdentifier: "myAccountInfoCell", for: indexPath) as! MyAccountInfoCell
            switch indexPath.row {
            case 1:
                cell.m_sTitle.text = "姓名"
                cell.m_sContent.text = gDC.mAccountInfo.m_sAccountName
            case 2:
                cell.m_sTitle.text = "手机"
                //将手机号中间4位数字修改为****
                var sPhone:String = gDC.mAccountInfo.m_sAccountCode
                let range = (sPhone.index(sPhone.startIndex, offsetBy: 3) ..< sPhone.index(sPhone.startIndex, offsetBy: 7)) //Swift 2.0
                sPhone.replaceSubrange(range, with: "****")
                cell.m_sContent.text = sPhone
            case 3:
                cell.m_sTitle.text = "地址"
                cell.m_sContent.text = gDC.mAccountInfo.m_sAccountAddress
            case 4:
                cell.m_sTitle.text = "邮箱"
                cell.m_sContent.text = gDC.mAccountInfo.m_sAccountEmail
            case 5:
                cell.m_sTitle.text = "修改密码"
                cell.m_sContent.text = ""
            default:
                break
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("点击了头像")
//            ShowInfoDispatch("提示", content: "该功能暂时没有开启，敬请期待~", duration: 1.5)
            DispatchQueue.main.async(execute: {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("相册", action: {() ->Void in
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
                alertView.showInfo("操作", subTitle: "请选择一个头像获取方式", duration: 0)//时间间隔为0时不会自动退出
            })
        case 1:
//            print("进入修改姓名界面")
            self.performSegue(withIdentifier: "changeAccountName", sender: self)
        case 2:
            ShowNoticeDispatch("提示", content: "手机号作为您的登录账号不可以修改~", duration: 1.0)
        case 3:
//            print("进入修改地址界面")
            self.performSegue(withIdentifier: "changeAccountAddress", sender: self)
        case 4:
//            print("进入修改邮箱界面")
            self.performSegue(withIdentifier: "changeAccountEmail", sender: self)
        case 5:
//            print("进入修改密码界面")
            let mainStory = UIStoryboard.init(name: "Main", bundle: nil)
            let nextView = mainStory.instantiateViewController(withIdentifier: "changeAccountPasswordViewCtrl") as! ChangeAccountPasswordViewCtrl
            self.navigationController?.pushViewController(nextView, animated: true)
        default:
            break
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////
    //    取消图片选择操作
    func imagePickerControllerDidCancel(_ picker:UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //    选择完图片操作
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        //在这里调用网络通讯方法，上传头像至服务器...
        MyWebService.sharedInstance.StopPolling()//先暂停一段时间的电器状态获取，防止出现冲突
        m_imageView = image.ReSizeImage(CGSize(width: 128, height: 128))
        let photoData = ImageToBase64String(m_imageView, headerSign: false)
        let webReturn = MyWebService.sharedInstance.UpdateAccountPhoto(gDC.mAccountInfo.m_sAccountCode, photo:photoData!)
        WebUpdateAccountPhoto(webReturn)
        self.dismiss(animated: true, completion: nil)
        MyWebService.sharedInstance.OpenPolling()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    func WebUpdateAccountPhoto(_ responseValue:String) {
        switch responseValue {
        case "0":
            ShowNoticeDispatch("错误", content: "未知的错误", duration: 1.0)
        case "1":
            ShowInfoDispatch("成功", content: "修改账户头像成功！", duration: 1.0)
            // 保存图片至本地，方法见下文
            gDC.mAccountInfo.m_imageAccountHead = m_imageView
            SaveImage(m_imageView, newSize: CGSize(width: 128, height: 128), percent: 0.5, imagePath: "account_head/", imageName: "\(gDC.mAccountInfo.m_sAccountCode).png")
        default:
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////
    //    打开图库或相机
    func OpenPhotoEdit(){
        let imagePickerController:UIImagePickerController = UIImagePickerController()
        //各种编辑图片的设置
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true//true为拍照、选择完进入图片编辑模式
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion:{
            print("进入imagePicjerController")
        })
    }
    

    
}
