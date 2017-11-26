//
//  
//
//  Created by kimziv on 13-9-14.
//

#ifndef _ChineseToPinyinResource_H_
#define _ChineseToPinyinResource_H_

#import <Foundation/Foundation.h>

@class NSArray;
@class NSMutableDictionary;

///Users/yy/Desktop/ZaoFengZhiNeng/zfzn2/zfzn2/EzCam/goe_tool/Pinyin/ChineseToPinyinResource.h:13:38: Cannot find interface declaration for 'NSObject', superclass of 'ChineseToPinyinResource'

@interface ChineseToPinyinResource : NSObject {
    NSString* _directory;
    NSDictionary *_unicodeToHanyuPinyinTable;
}
//@property(nonatomic, strong)NSDictionary *unicodeToHanyuPinyinTable;

- (id)init;
- (void)initializeResource;
- (NSArray *)getHanyuPinyinStringArrayWithChar:(unichar)ch;
- (BOOL)isValidRecordWithNSString:(NSString *)record;
- (NSString *)getHanyuPinyinRecordFromCharWithChar:(unichar)ch;
+ (ChineseToPinyinResource *)getInstance;

@end

#endif // _ChineseToPinyinResource_H_
