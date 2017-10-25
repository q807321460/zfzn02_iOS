//
//  DestructorHelper.m
//  Smart360
//
//  Created by michael on 15/10/28.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "DestructorHelper.h"

@interface DestructorHelper ()

{
    const char *functionNameSave;
}

@end

@implementation DestructorHelper

-(void)dealloc{
    NSLog(@"[TRACE] : %s------",functionNameSave);
}

-(instancetype)initWithFunctionName:(const char *)functionName{

    if (self = [super init]) {
        
        functionNameSave = functionName;
        NSLog(@"[TRACE] : %s++++++",functionName);
    }
    
    return self;
}


@end
