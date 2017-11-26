//
//  InsetsTextField.m
//  ppview_zx
//
//  Created by zxy on 14-10-17.
//  Copyright (c) 2014年 vveye. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField


//控制 placeHolder 的位置，左右缩 20
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}

// 控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}
@end
