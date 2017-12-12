//
//  GlobalFunction.swift
//  zfzn2
//
//  Created by Hanwen Kong on 17/3/22.
//  Copyright © 2017年 Hanwen Kong. All rights reserved.
//

import UIKit
import Photos

/////////////////////////////////////////////////////////////////////////////
/**
 *  全局函数——仅测试用
 */
func TempFunc() {
    
}

/**swift
 *  全局函数——切换视图（UIViewController）尽量不要用上，防止将来的本地socket通信
 */
func SwitchViewCtrl(_ from:UIViewController, to:String, toType:String){
    DispatchQueue.main.async(execute: {
        let mainStory = UIStoryboard(name: "Main",bundle: nil)
        if toType == "view"{
            let nextView = mainStory.instantiateViewController(withIdentifier: to) as UIViewController
            nextView.modalTransitionStyle=UIModalTransitionStyle.crossDissolve//页面跳转效果，可以选择其他的CoverVertical,FlipHorizontal,PartialCurl,CrossDissolve等等
            from.present(nextView, animated: true, completion: nil)
        }else if toType == "navi"{
            let nextView = mainStory.instantiateViewController(withIdentifier: to) as! UINavigationController
            nextView.modalTransitionStyle=UIModalTransitionStyle.crossDissolve
            from.present(nextView, animated: true, completion: nil)
        }
    })
}

/**
 *  全局函数——显示警告窗口,没有用上
 */
func AlertMessage(_ alertTitle:String, message:String, actionTitle:String, viewControl:UIViewController){
    let alert = UIAlertController(title: alertTitle,message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
    alert.addAction(action)
    viewControl.present(alert, animated: true, completion: nil)
}

/**
 *  全局函数——获取路由器ip
 */
func GetRouterAddress() -> String{
    var sRouterIP:String!
    //    routerIp()
    sRouterIP = MyWifi.routerIp() as String
    //    print("当前路由器的IP是：\(sRouterIP)")
    return sRouterIP
}

/**
 *  全局函数——获取外网ip
 */
func GetOuterAddress() -> String{
    //    let dict = deviceWANIPAdress()
    //    let _:NSError
    var dict = NSDictionary()
    let url = URL(string: "http://pv.sohu.com/cityjson?ie=utf-8")!
    
    var ip:NSMutableString!
    do{ try ip = NSMutableString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)}
    catch{ print("error");return ""}
    
    //判断返回字符串是否为所需数据
    if (ip.hasPrefix("var returnCitySN =")) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        let range:NSRange = NSMakeRange(0, 19);
        ip.deleteCharacters(in: range)
        let nowIp:NSString = ip.substring(to: ip.length-1) as NSString//[ip :ip.length-1];
        //将字符串转换成二进制进行Json解析
        let data:Data = nowIp.data(using: String.Encoding.utf8.rawValue)!
        do{ try dict = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary}
        catch{ print("dict error")}
    }
    //    return dict;
    let sOuterIP:String =  dict["cip"] as! String;
    print("当前外网的IP是：\(sOuterIP)")
    return sOuterIP
}

/**
 *  全局函数——网络错误的提示信息
 */
func WebError() {
    DispatchQueue.main.async(execute: {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showNotice("错误", subTitle: "网络连接失败，请检查网络设置", duration: 1.5)
    })
}

/**
 *  全局函数——提示普通的错误信息
 */
func ShowNoticeDispatch(_ title:String, content:String, duration:TimeInterval) {
    DispatchQueue.main.async(execute: {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showNotice(title, subTitle: content, duration: duration)
    })
}

/**
 *  全局函数——提示普通的正确信息
 */
func ShowInfoDispatch(_ title:String, content:String, duration:TimeInterval) {
    DispatchQueue.main.async(execute: {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showInfo(title, subTitle: content, duration: duration)
    })
}

/**
 *  全局函数——获取手机本地当前时间
 */
func GetCurrentTime() -> String{
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let sTime = timeFormatter.string(from: date) as String
    return sTime
}

/**
 *  全局函数——获取手机本地当前时间，返回的是NSDate格式
 */
func ChangeStringToDate(_ sTime:String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // k = Hour in 1~24, mm = Minute
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    let date = dateFormatter.date(from: sTime)
    return date!
}

/**
 *  全局函数——获取沙盒持久化plist文件路径
 */
func DataFilePath(_ fileName:String)->String{
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentsDirectory = paths[0] as NSString
    return documentsDirectory.appendingPathComponent(fileName) as String
}


/**
 *  全局函数——初始化沙盒持久化plist文件路径，目前只是作为测试用的
 */
func InitPlistData(){
    let path = DataFilePath("data.plist")
    let manager = FileManager.default
    if  manager.fileExists(atPath: path) == false{
        print("plist文件不存在，创建之")
        let array = NSMutableDictionary()
        array.setObject("", forKey: "last_account" as NSCopying)
        array.setObject(gDC.m_dbVersion, forKey: "db_version" as NSCopying)
        array.write(toFile: path, atomically: true)
    }else {
        //不作任何处理
    }
}

/**
 *  全局函数——将原始info指令做一个标志位的调整
 */
func ModifyMarkBit(_ sOriginInfo:String)->String {
    var sum:Int! = 0
    let nOriginInfoLength:Int = sOriginInfo.count
    let sBefore:String = (sOriginInfo as NSString).substring(with: NSMakeRange(1,nOriginInfoLength-4))
    for ch in sBefore.unicodeScalars {
        sum = sum + Int(ch.value)
    }
    let sNumber = String(format: "%X", sum)
    let sTail:String = (sNumber as NSString).substring(with: NSMakeRange(sNumber.count-2 ,2))
    let sReturn:String = "<" + sBefore + sTail + ">\r\n"
    return sReturn
}

/**
 *  全局函数——获取指定文件在沙盒中的路径，如果没有找到路径则创建之
 */
func GetFileFullPath(_ filePath:String, fileName:String)->String{
    let myDire: String = NSHomeDirectory() + "/Documents/" + filePath
    do {
        try FileManager().createDirectory(atPath: myDire, withIntermediateDirectories: true, attributes: nil)
    }catch let err {
        debugPrint(err)
    }
    return myDire + fileName
}

/**
 全局函数——判断相机权限
 - returns: 有权限返回true，没权限返回false
 */
func CameraPermissions() -> Bool{
    let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
        return false
    }else {
        return true
    }
}

/**
 全局函数——判断相册权限
 - returns: 有权限返回ture， 没权限返回false
 */
func PhotoLibraryPermissions() -> Bool {
    let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
        return false
    }else {
        return true
    }
}

/**
 全局函数——保存图片至沙盒
 - returns: 有权限返回ture， 没权限返回false
 */
func SaveImage(_ currentImage: UIImage, newSize: CGSize, percent: CGFloat, imagePath:String, imageName: String){
    //压缩图片尺寸
    UIGraphicsBeginImageContext(newSize)
    currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    //高保真压缩图片质量
    //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
    let imageData: Data = UIImageJPEGRepresentation(newImage, percent)!
    // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
    let fullPath:String = GetFileFullPath(imagePath, fileName: imageName)
    // 将图片写入文件
    try? imageData.write(to: URL(fileURLWithPath: fullPath), options: [])
}

/**
 全局函数——删除文件，当前调试用
 - returns: 有权限返回ture， 没权限返回false
 */
func DeleteFile(_ path:String) {
    let fileManager = FileManager.default
    if  fileManager.fileExists(atPath: path) == false {
        return
    }else {
        do {
            try fileManager.removeItem(atPath: path)
        }catch let err {
            debugPrint(err)
        }
    }
}
/**
 全局函数——截取部分图像
 */
func CutImage(_ image:UIImage, rect:CGRect)->UIImage{
    let subImageRef:CGImage = image.cgImage!.cropping(to: rect)!
    let smallBounds:CGRect = CGRect(x: 0, y: 0, width: CGFloat(subImageRef.width), height: CGFloat(subImageRef.height))
    UIGraphicsBeginImageContext(smallBounds.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.draw(subImageRef, in: smallBounds)
    let smallImage:UIImage = UIImage(cgImage: subImageRef)
    UIGraphicsEndImageContext()
    return smallImage
}

/**
 全局函数——修改电器状态
 */
func RefreshElectricStates(_ sReceive:String) -> Bool {
    let nStart:Int = sReceive.positionOf("<")
    let nEnd:Int = sReceive.positionOf(">")//接收到的是“<030036C9Z6”,导致右尖括号丢失的情况，有时候还会接收到主机编号。。。
    let nLen:Int = nEnd - nStart
    //正常的结构是：
    //1、接收到主机主动返回的有效数据——030036C9Z603********00，22位，旧电器使用的是短地址，电器编号为8位
    //2、接收到主机主动返回的有效数据——030036C94E0BZ603********00，26位，新电器使用的是长地址，电器编号为12位
    if (nLen == 23 || nLen == 27) == false {
        return false
    }
    if nStart != -1 {
        let sReturn:String = (sReceive as NSString).substring(with: NSMakeRange(nStart+1, nEnd-nStart-1))
        var sElectricCode:String = ""
        var sElectricState:String = ""
        var sStateInfo:String = ""
        if sReturn.count == 22 {
            sElectricCode = (sReturn as NSString).substring(with: NSMakeRange(0, 8))
            sElectricState = (sReturn as NSString).substring(with: NSMakeRange(8, 2))
            sStateInfo = (sReturn as NSString).substring(with: NSMakeRange(10, 10))
        }else if sReturn.count == 26 {
            sElectricCode = (sReturn as NSString).substring(with: NSMakeRange(0, 12))
            sElectricState = (sReturn as NSString).substring(with: NSMakeRange(12, 2))
            sStateInfo = (sReturn as NSString).substring(with: NSMakeRange(14, 10))
        }
        gDC.mElectricData.ChangeElectricState(sElectricCode, electricState: sElectricState, stateInfo: sStateInfo)
        return true
    }else {
        return false
    }
}

//传入图片image回传对应的base64字符串,默认不带有data标识
func ImageToBase64String(_ image:UIImage,headerSign:Bool = false)->String?{
    //根据图片得到对应的二进制编码
    guard let imageData = UIImagePNGRepresentation(image) else {
        return nil
    }
    //根据二进制编码得到对应的base64字符串
    var base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue:0))
    //判断是否带有头部base64标识信息
    if headerSign {
        ///根据格式拼接数据头 添加header信息，扩展名信息
        base64String = "data:image/png;base64," + base64String
    }
    return base64String
}

//传入图片image名称回传对应的base64字符串,默认不带有data标识
func ImageToBase64String(_ imageName:String,headerSign:Bool = false)->String?{
    //根据名称获取图片
    guard let image : UIImage = UIImage(named:imageName) else {
        return nil
    }
    return ImageToBase64String(image,headerSign:headerSign)
}


//传入base64的字符串，可以是没有经过修改的转换成的以data开头的，也可以是base64的内容字符串，然后转换成UIImage
func Base64StringToUIImage(_ base64String:String)->UIImage? {
    var str = base64String
    // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
    if str.hasPrefix("data:image") {
        guard let newBase64String = str.components(separatedBy: ",").last else {
            return nil
        }
        str = newBase64String
    }
    // 2、将处理好的base64String代码转换成NSData
    guard let imgNSData = Data(base64Encoded: str, options: NSData.Base64DecodingOptions()) else {
        return nil
    }
    // 3、将NSData的图片，转换成UIImage
    guard let codeImage = UIImage(data: imgNSData) else {
        return nil
    }
    return codeImage
}

/// (recommended) 获取指定文件夹下符合扩展名要求的所有文件名
/// - parameter path: 文件夹路径
/// - parameter filterTypes: 扩展名过滤类型(注：大小写敏感)
/// - returns: 所有文件名数组
func findFiles(_ path: String, filterTypes: [String]) -> [String] {
    do {
        let files = try FileManager.default.contentsOfDirectory(atPath: path)
        if filterTypes.count == 0 {
            return files
        }
        else {
            let filteredfiles = NSArray(array: files).pathsMatchingExtensions(filterTypes)
            return filteredfiles
        }
    }
    catch {
        return []
    }
}

/**
 *  全局函数——生成一个固定不变的中国城市plist文件，用于获取天气信息，备用，使用不上
 */
func CreateAddressPlist() {
    let filePathAll = DataFilePath("address.plist")//获得本地data.plist文件的路径
    DeleteFile(filePathAll)
    
    let arrayProvince = PublicWebService.sharedInstance.getSupportProvince()
    for i in 0..<arrayProvince.count {
        print(arrayProvince[i] as! String)
    }
    
    let path = DataFilePath("address.plist")
    let manager = FileManager.default
    if  manager.fileExists(atPath: path) == false{
        print("plist文件不存在，创建之")
        let array1 = NSMutableArray()
        for i in 0..<arrayProvince.count-6 {
            let dictProvince = NSMutableDictionary()
            dictProvince.setObject(arrayProvince[i] as! String, forKey: "provinceName" as NSCopying)
            let arrayCity = PublicWebService.sharedInstance.GetSupportCity(arrayProvince[i] as! String)
            let array2 = NSMutableArray()
            for j in 0..<arrayCity.count {
                let str:String = arrayCity[j] as! String
                let index = str.index(str.endIndex, offsetBy: -8)//去除后面的城市编号
                let str2:String = str.substring(to: index)
                array2.add(str2)
            }
            dictProvince.setObject(array2, forKey: "cityList" as NSCopying)
            array1.add(dictProvince)
        }
        array1.write(toFile: path, atomically: true)
    }
    
}

/**
 *  全局函数——复制工程中的城市列表到沙盒中
 */
func InitAddressPlist() {
    //下面注释的代码是将工程内plist文件复制到沙盒中
    if gDC.m_bUseProgramSQL==true {
        let fm = FileManager.default
        let plistName:String = "address.plist"
        var docDir:String = ""
        let GROUP:String = ""
        // Is this for an app group?
        if GROUP.isEmpty {
            // Get path to DB in Documents directory
            docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        } else {
            // Get path to shared group folder
            if let url = fm.containerURL(forSecurityApplicationGroupIdentifier: GROUP) {
                docDir = url.path
            } else {
                assert(false, "Error getting container URL for group: \(GROUP)")
            }
        }
        let path = (docDir as NSString).appendingPathComponent(plistName)
        
        if !(fm.fileExists(atPath: path)) {
            guard let rp = Bundle.main.resourcePath else { return }
            let from = (rp as NSString).appendingPathComponent(plistName)
            do {
                try fm.copyItem(atPath: from, toPath:path)
            } catch let error as NSError {
                print("SwitchCityViewCtrl - failed to copy writable version of plist!")
                print("Error - \(error.localizedDescription)")
                return
            }
        }
    }
}

func GetLechageTokenGlobal(_ sPhoneNumber:String, isShowLoading:Bool) {
    if isShowLoading == true {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        var viewLoading:SCLAlertView! = nil
        viewLoading = SCLAlertView(appearance: appearance)
        viewLoading.showInfo("提示", subTitle: "加载中...", duration: 0)
        UIDevice.getLechangeToken(sPhoneNumber)
        viewLoading.hideView()//取消显示正在验证的字样
        print("gDC.m_sCameraToken——\(gDC.m_sCameraToken)")
    }else {
        UIDevice.getLechangeToken(sPhoneNumber)
    }
}

//func IsValidMasterCode(_ masterCode: String) -> Bool {
//    for ch in masterCode {
//        if (ch>="0"&&ch<="9") || (ch>="a"&&ch<="z") || (ch>="A"&&ch<="Z") {//如果满足三个条件任意一个，可以认为符号没有问题
//            continue
//        }else {
//            return false
//        }
//    }
//    return true
//}

/**
 扩展函数——对图像缩放
 */
extension UIImage {
    //重置图片大小
    func ReSizeImage(_ reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    //等比例缩放
    func ScaleImage(_ scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return ReSizeImage(reSize)
    }
}



