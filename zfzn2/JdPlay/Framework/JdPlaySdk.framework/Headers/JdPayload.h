#ifndef JDPAYLOAD_H
#define JDPAYLOAD_H

#define JDPLAY2_VERSION 1

#define TOPIC_TYPE_DC  "/DC/"
#define TOPIC_TYPE_DS   "/DS/"

#define PAYLOAD_TYPE_DEVICE   1
#define PAYLOAD_TYPE_MEDIA   2
#define PAYLOAD_TYPE_MULTIROOM 3
#define PAYLOAD_TYPE_MESSAGE 4

//----------------------------------- DEVICE_TYPE  设备类型

#define DEVICE_TYPE_LAMP  1         //灯
#define DEVICE_TYPE_CURTAINS  2     //窗帘
#define DEVICE_TYPE_SOCKECT  3      //插座
#define DEVICE_TYPE_SPEAKER  4      //音箱
#define DEVICE_TYPE_AIRCONDITION 5  //空调
#define DEVICE_TYPE_AIRPURIFIER  6  //空气净化器
#define DEVICE_TYPE_DIMLAMP 7      //调光灯

//-----------------------------------------------------------------------------PAYLOAD_TYPE_DEVICE
#define DEVICE_IP   1
#define DEVICE_ONLINE    2
#define DEVICE_GET_DEVICE_INFO   3
#define DEVICE_INFO 4
#define DEVICE_GET_DEVICE_MODE  5 //在线模式，蓝牙模式
#define DEVICE_SET_DEVICE_MODE   6
#define DEVICE_SET_DEVICE_NAME 7
#define DEVICE_VOICE_SEARCH   8
#define DEVICE_GET_BINDERS  9 //获取QQ绑定者
#define DEVICE_GET_STORAGE_SONGS   10  //获取本地歌曲
#define DEVICE_GET_BINDKEY_SONGLIST_NAME  11
//账号相关
#define DEVICE_GET_ACCOUNT_INFO 13  //获取设备账号信息

#define DEVICE_SET_ACCOUNT_INFO 14  //手机端登录成功，同步账号信息给设备端

#define DEVICE_DEL_STORAGE_SONGS  15    // 刪除本地歌曲


#define DEVICE_SET_ALARM  50
#define DEVICE_UPDATE_ALARM  51
#define DEVICE_QUERY_ALARM  52
#define DEVICE_DELETE_ALARM  53

//#define DEVICE_CHECK_UPDATE   "checkUpdate" xxxx
#define DEVICE_CHECK_UPDATE   55
#define DEVICET_DOWNLOAD_PACKAGE   56
#define DEVICE_START_UPDATE   57
#define DEVICE_SETUPDATE_MODE   58

//蓝牙相关
#define DEVICE_GET_BT_NAME  60
#define DEVICE_SET_BT_NAME  61
#define DEVICE_GET_BT_PWD  62//获取当前蓝牙密码
#define DEVICE_SET_BT_PWD  63//设置蓝牙密码

//开关机
#define DEVICE_SET_DEVICE_STATUS  70 //假开关机
#define DEVICE_GET_SHUTDOWN_STATUS  71  //获取开关机状态
#define DEVICE_SET_SHUTDOWN_TIME  72  //定时关闭 args  time format  yyyyMMdd HH:mm:ss
#define DEVICE_GET_SHUTDOWN_TIME  73 //获取定时关闭时间
#define DEVICE_CANCEL_SHUTDOWN  74 //取消定时关闭

#define DEVICE_SET_LED_MODE    80//设置Led灯模式开启或关闭 value = 1打开 value = 0关闭
#define DEVICE_GET_LED_MODE   81 //获取Led灯模式 value = 1小夜灯 value = 0正常
#define DEVICE_SET_LED_BRIGHT  82 //设置环形灯亮度
#define DEVICE_GET_LED_BRIGHT 83 //获取环形灯亮度

//智能硬件相关命令从100开始
//100
#define DEVICE_JSMART_CTRL_SCENE  101    //控制场景
#define DEVICE_JSMART_CTRL_DEVICE  102   //控制设备
#define DEVICE_JSMART_GET_SCENES  103    //获取场景
#define DEVICE_JSMART_GET_DEVICES  104   //获取智能设备
#define DEVICE_JSMART_GET_DEVICE_STATE  105  //获取设备状态
#define DEVICE_JSMART_SET_SCENE_MUSIC  106 //设置场景音乐
#define DEVICE_JSMART_GET_SCENES_DETAIL  107// 获取场景详情  请求参数是选中的场景

//智能硬件事件反馈消息从120开始
#define DEVICE_JSMART_ON_SCENES_INFO_CHANGE  120 //场景总信息改变
#define DEVICE_JSMART_ON_DEVICES_INFO_CHANGE  121 //设备总信息改变
#define DEVICE_JSMART_ON_DEVICE_STATE_CHANGE  122 //智能硬件设备状态改变






//-----------------------------------------------------------------------------PAYLOAD_TYPE_MEDIA
#define MEDIA_DATASOURCE   1
#define MEDIA_PLAY   2
#define MEDIA_PAUSE   3
#define MEDIA_NEXT   4
#define MEDIA_PREV   5
#define MEDIA_SEEK   6
#define MEDIA_POSITION   7 //GET OR NOTIFY
#define MEDIA_DURATION   8
#define MEDIA_REPORT_STATES   9
#define MEDIA_REPORT_PLAYLIST_ETAG   10
#define MEDIA_DATASOURCE_INDEX   11

#define MEDIA_GET_VOLUME   20
#define MEDIA_VOLUME   21
//#define MEDIA_GET_PLAYMODE   22
#define MEDIA_PLAYMODE   23
#define  MEDIA_PLAYLIST   24
#define MEDIA_GET_MUSIC_RESOURCE   25 //TODO

#define MEDIA_ACTION_ARRAY   30
#define MEDIA_METADATA   31 //NOTIFY
#define MEDIA_PLAYSTATE   32

#define MEDIA_ON_SEEK_COMPLETE   40
#define MEDIA_ON_SETDATASOURCE   41
#define MEDIA_ON_PREPARED   42
#define MEDIA_ON_COMPLETE   43
#define MEDIA_ON_ERROR   44
#define MEDIA_ON_BUFFERING_UPDATE   45
#define MEDIA_ON_DATASOURCE_MISMATCH 46

#define MEDIA_DEL_CURRENT_DOUBAN_SONG  47  // 删除当前豆瓣歌曲
#define MEDIA_COLLECT_DOUBAN_SONG  48      // 收藏当前豆瓣歌曲
#define MEDIA_UNCOLLECT_DOUBAN_SONG  49    // 取消收藏当前豆瓣歌曲

//---------------------------------PAYLOAD_TYPE_MULTIROOM

#define MULTIROOM_CREATE_GROUP		 1
#define MULTIROOM_JOIN_GROUP		 2
#define MULTIROOM_LEAVE_GROUP		 3
#define MULTIROOM_GET_GROUPS_INFO	 4
#define MULTIROOM_REPORT_GROUPS_INFO 5

#define MULTIROOM_ON_CREATE_GROUP  	11
#define MULTIROOM_ON_JOIN_GROUP  	12
#define MULTIROOM_ON_LEAVE_GROUP  	13
#define MULTIROOM_ON_GROUPS_INFO	14

#define MULTIROOM_SET_CHANNEL       21

//-----------------------------------------------------------------------------PAYLOAD_TYPE_MESSAGE
//PAYLOAD_TYPE_MESSAGE
#define MESSAGE_P2P 1

//----------------------------------------------------------------------------------------------------------

#define PAYLOAD_FLAG_COMPRESS  (1<<0)
//#define PAYLOAD_FLAG_P2P			   (1<<1) //点对点消息
#define PAYLOAD_FLAG_REMOTE       (1<<2) //远程推送标识
#define PAYLOAD_FLAG_EVENT          (1<<3) //事件反馈标识

#endif
