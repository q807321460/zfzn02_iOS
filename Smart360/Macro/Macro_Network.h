//
//  Macro_Network.h
//  Smart360
//
//  Created by nimo on 15/8/10.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#ifndef Smart360_Macro_Network_h
#define Smart360_Macro_Network_h


#define AP_HOT_IP @"192.168.43.1"
#define AP_HOT_PORT 9099
#define AP_HOT_NAME @"smallzhi-ap"
#define AP_UDP_SEND_PORT 10001
#define AP_UDP_RECEIVE_PORT 20000

//启动广告页
#define Fetch_WelcomePage @"/appProvider/queryWelcomePage"

// 用户登陆系统
//登陆
#define USER_Login @"/appUser/login"
//注册
//发送验证码
#define USER_GetVerifyCode @"/appUser/sendVerifyCode"
//校验验证码
#define USER_CheckVerifyCode @"/appUser/checkVerifyCode"
//提交注册
#define USER_CommitRegister @"/appUser/reg"
//根据id查询用户信息
#define USER_FindUserInfo @"/appUser/findUserById"
//更新用户信息
#define USER_UpdateUserInfo @"/appUser/modifyUser"
//获取用户标签
#define USER_FindUserLabel @"/appUser/findUserLabel"
//修改用户标签
#define USER_UpdateUserLabel @"/appUser/updateUserLabel"
//登出
#define USER_Logout @"/appUser/logout"
//重置密码
#define USER_ForgetPassword @"/appUser/forgetPassword"
//忘记密码
//#define USER_ForgetPassword @"/appUser/getVerifyCode"
//头像上传
//#define USER_CommitPhoto @""
//投诉建议
#define USER_FeedBack @"/appUser/addUserSuggest"

//用户订单系统
//根据userId查询订单信息
#define ORDER_FindUserByUserId @"/appUserOrder/findUserOrderByUserId"
//订单生成
#define ORDER_AddOrder @"/userorder/addUserOrder"
//根据订单id查询订单详情
#define ORDER_FindUserOrderByOrderId @"/appUserOrder/findUserOrderByOrderId"

//订单更新
#define ORDER_UpdateUserOrderByOrderId @"/userorder/updateUserOrderByOrderId"
//订单取消
#define ORDER_CancelUserOrderByOrderId @"/userorder/cancelUserOrderByOrderId"

//订单发表评论
#define ORDER_EvaluateByOrderId @"/appUserOrder/addEvaluate"
//查看订单评价
#define ORDER_FindOrderEvaluateInfo @"/appUserOrder/findUserOrderByOrderId"
//

//主界面滚动栏
#define Query_QueryBanner @"/appProvider/findBanner"

//主界面服务查询
#define Query_QueryHomePage @"/appProvider/queryHomePage"

//查询其子服务种类
#define Query_ServiceProviderCardPage @"/appProvider/serviceProviderCardPage"


//城市定位查询
#define Query_ServiceCity @"/appProvider/findCity"

//点击服务子类跳转到对话页面
#define Query_FetchChildServiceCard  @"/appProvider/findServiceProviderCardConfigure"

//获取所有样式表
#define Query_FetchAllServiceCard  @"/appProvider/queryAllServiceProviderCard"

//获取单个样式表
#define Query_FetchSingleServiceCard  @"/appProvider/queryServiceProviderCard"

//收货地址列表
#define Address_FetchAddressList @"/appUser/findAddressList"

//添加/修改收获地址

#define Address_AddOrUpdateAddressList @"/appUser/addOrUpdateAddress"

//删除收获地址

#define Address_DeleteAddressList @"/appUser/deleteAddress"

//设置默认收获地址

#define Address_SetDefaultAddressList @"/appUser/addOrUpdateAddress"


//余额查询
#define Balance_FetchBlance @"/appWallet/findWallet"

//余额详细界面查询

//余额详细界面查询
#define Balance_FetchBlanceInfo @"/appWallet/findBillListByCondition"

//获得优惠券信息
#define Vouchers_FetchVoucherList @"/appWallet/findCouponRelate"

//优惠券详情
#define Vouchers_FetchVoucherInfo @"/appWallet/findCouponRelateByCondition"

//支付密码
#define Wallet_IsSetPayPassword @"/appWallet/isSetPayPwd"

//设置支付密码
#define Wallet_SetPayPassword @"/appWallet/setPassword"

//验证身份是否合法
#define Wallet_VerifyAuthentication @"/appWallet/verifyAuthentication"

//验证密码
#define Wallet_VerifyPayPassword @"/appWallet/verifyPassword"

//修改支付密码
#define Wallet_ModifyPayPassword @"/appWallet/modifyAuthentication"

//确定订单(先发送http请求到后台,后台将对订单进行验证，如果验证通过，则再跳转到支付界面)
#define Order_EnsureOrder @"/appUserOrder/updateUserOrderByOrderId"

//余额支付
#define Wallet_BalancePay @"/appWallet/orderPay"

//余额充值
#define Wallet_Recharge @"/appWallet/addUserRecharge"


//我的消息
#define Message_MessageCenterFetchMessageList @"/appUser/findMessageCenterPage"

//查看消息详情
#define Message_MessageCenterFetchMessageInfo @"/appUser/findMessageDetail"

//删除消息
#define Message_MessageCenterDelegateMessage @"/appUser/deleteMessage"

//会话界面加载h5页面立即下单
#define Order_Immediately @"/appProvider/queryH5MarkByMark"

//问候语
#define Find_Greeting @"/appProvider/findGreeting"

//小智助手音乐部分

//喜马拉雅专辑热门
#define XiMaLaMaYa_BaseUrl @"http://api.ximalaya.com/openapi-gateway-app"
#define XiMaLaMaYa_CategoriesList @"/categories/list"
#define XiMaLaMaYa_AlbumsHot @"/albums/hot"
#define XiMaLaMaYa_AlbumsHotGetAll  @"/albums/get_all"
//
#define XiMaLaMaYa_TracksGetBatch @"/tracks/get_batch"
//
#define XiMaLaMaYa_ColumnDetail @"/column/detail"
//喜马拉雅专辑下的声音列表，即专辑浏览
#define XiMaLaMaYa_AlbumsBrowse @"/albums/browse"
//喜马拉雅bannner
#define XiMaLaMaYa_Banners @"/banners/discovery_banners"


#endif
