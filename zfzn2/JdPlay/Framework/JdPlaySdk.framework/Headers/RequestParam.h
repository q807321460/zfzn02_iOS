
#import <Foundation/Foundation.h>
#import "JdCategoryModel.h"
#import "SongListTypeUtils.h"
#import "PageInfo.h"
#import <UIKit/UIKit.h>


@interface RequestParam : NSObject


@property(nonatomic,strong) id ext1;

/**
 * 当前要请求的id
 */
@property(nonatomic,copy) NSString * id;

/**
 * 目录级别 0-》1-》2 获取category时用
 */
@property(nonatomic,assign) int level;

@property (nonatomic,strong) NSNumber * musicSourceId;

/**
 * 当前要请求的名字
 */
@property(nonatomic,copy) NSString *name;



@property(nonatomic,strong) PageInfo * pageInfo;

/**
 * 父节点，如当前界面专辑界面，父节点就是MusicCategoroes
 */
@property(nonatomic,retain) NSObject *parent;

@property(nonatomic) int type;

@property(nonatomic,assign) int version;

+ (RequestParam *)createRequestParamWithCategory:(JdCategoryModel *)category;

@end
