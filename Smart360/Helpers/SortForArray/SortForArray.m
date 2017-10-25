//
//  SortForArray.m
//  Smart360
//
//  Created by sun on 15/12/31.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "SortForArray.h"
#import "PinYin4Objc.h"

@interface SortForArray ()

//@property (nonatomic, strong) NSArray *paramsArray;

@end

@implementation SortForArray

- (instancetype)initWithDataArray:(NSArray *)dataArray {
    self = [super init];
    if (self) {
//        _paramsArray = dataArray;
        [self fetchResultDicAndArrayWithParamsArray:dataArray];
        
    }
    return self;
}

- (void)fetchResultDicAndArrayWithParamsArray:(NSArray *)paramsArray {
    
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    for (TJBrand * brand in paramsArray) {
        if (brand.brand_cn.length > 0) {
            NSString *key = [[brand.pinyin substringToIndex:1] uppercaseString];
            //            NSLog(@"*******汉字、拼音、首字符为:  %@,%@, %@",tempStr,pinYin,key);
            //根据key取出字典中的数对应组
            NSMutableArray *arr = [mutDic objectForKey:key];
            if (!arr) {
                arr = [NSMutableArray array];
                [mutDic setObject:arr forKey:key];
                
            }
//            NSDictionary *brandDic = @{};
            [arr addObject:brand];
        }

    }
    
    
//    for (NSString *tempStr in paramsArray) {
//        if (tempStr.length > 0) {
//            NSString *pinYin = [self chineseToPinYinWithChinese:tempStr];
//            NSString *key = [[pinYin substringToIndex:1] uppercaseString];;
////            NSLog(@"*******汉字、拼音、首字符为:  %@,%@, %@",tempStr,pinYin,key);
//            //根据key取出字典中的数对应组
//            NSMutableArray *arr = [mutDic objectForKey:key];
//            if (!arr) {
//                arr = [NSMutableArray array];
//                [mutDic setObject:arr forKey:key];
//                
//            }
//            [arr addObject:tempStr];
//        }
//    }
    NSArray *sortedKeys = [[mutDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@"sortedKeys ==  %@  mutDic == %@",sortedKeys,mutDic);
    self.resultKeysArray = sortedKeys;
    self.resultDataDic = [NSDictionary dictionaryWithDictionary:mutDic];

}



- (NSString *)chineseToPinYinWithChinese:(NSString *)chinese {
    
    if ([chinese hasPrefix:@"长"]) {
        chinese = [chinese stringByReplacingOccurrencesOfString:@"长" withString:@"chang"];
    }
    
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:chinese withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return outputPinyin;
}



@end
