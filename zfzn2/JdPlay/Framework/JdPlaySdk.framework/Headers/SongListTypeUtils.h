

/**
 * @desc
 *      歌单类型
 *      songListType  资源类型（resourceType）：4位
        1000=我的最爱电台，1001=自定义的电台单，
        1011=蜻蜓fm电台，1010=蜻蜓fm点播，
        1021=喜马拉雅fm电台，1020=喜马拉雅fm点播,
        1031=考拉fm电台，1030=考拉fm点播，
        1040=荔枝FM
        1041=百度电台，1042=百度场景电台
        1050＝懒人听书 
        1060=口袋故事
        2000=我的最爱读物，2001=自定义的读物单
        3000=我的最爱歌单，3001=自定义的歌单，
        3010=虾米音乐，3011=虾米排行，3012=虾米电台 
        3020=qq音乐的系统歌单 
        3030=百度歌单，
        3040=咪咕音乐 
        3050=豆瓣兆赫，3051=豆瓣歌单
        4000 = 我的最爱亲子儿童
 */

#import <Foundation/Foundation.h>

@interface SongListTypeUtils:NSObject

typedef NS_ENUM(NSInteger, SongListType)
{
    RadioMyFavor = 1000,
    RadioCustom = 1001,
    QingTingOrdemand = 1010,
    QingTingLive = 1011,
    RadioXiMaLaYaOrdemand = 1020,
    RadioXiMaLaYaLive = 1021,
    RadioKaoLaOrdemand = 1030,
    RadioKaoLaLive = 1031,
    LiZhi = 1040,
    LanRenTingShu = 1050,
    GongChengShiBaBa = 1060,
    ReadingMyFavor = 2000,
    ReadingCustom = 2001,
    MusicMyFavor = 3000,
    MusicCustom = 3001,
    MusicXiaMi = 3010,
    MusicXiaMiRank = 3011,
    MusicXiaMiRadio = 3012,
    MusicQQ = 3020,
    MusicBaiDu = 3030,
    MusicMigu = 3040,
    MusicBaiDuRadio = 1041,
    MusicBaiDuSceneRadio = 1042,
    RadioDouBanFM = 3050,
    MusicQPlay = 6000,  //Qplay推送的音乐类型
    MusicAirPlay = 6001,//Airplay推送的音乐类型
    Local = -1
};


typedef NS_ENUM(int , MusicResource){
    UnknownType = -1,/*未知*/
    Xiami = 1,
    Qingting = 2,
    Kaola = 3,
    Lizhi =4,
    Baidu = 5,
    Lrts = 6,
    Kdgs = 7,
    ChildrendReading = 8,
    Xmly = 9,
    Migu = 10,
    Douban = 11
};



/**
 根据SongListType获取MusicResource
 */
+(MusicResource) getMusicResourceFromSongListType:(SongListType)type;

/**
 根据类型判断是否需要翻页
 */
+(bool) isAvailablePage:(int) slt;

@end
