//
//  JSSelectedButton.m
//  Smart360
//
//  Created by sun on 15/8/17.
//  Copyright (c) 2015年 Jushang. All rights reserved.
//

#import "JSSelectedButton.h"

#define Q_RADIO_ICON_WH                     (16.0)
#define Q_ICON_TITLE_MARGIN                 (5.0)

static NSMutableDictionary *_groupRadioDic = nil;
@implementation JSSelectedButton

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _groupId = [groupId copy];
        
        [self addToGroup];
        
        self.exclusiveTouch = YES;
        
        [self setImage:[UIImage imageNamed:@"Chat_Radio_normal"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"Chat_Radio_pressed"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(radioBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addToGroup {
    if(!_groupRadioDic){
        _groupRadioDic = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    if (!_gRadios) {
        _gRadios = [NSMutableArray array];
    }
    [_gRadios addObject:self];
    [_groupRadioDic setObject:_gRadios forKey:_groupId];
}


- (void)uncheckOtherRadios {
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    if (_gRadios.count > 0) {
        for (JSSelectedButton *_radio in _gRadios) {
            if (_radio.checked && ![_radio isEqual:self]) {
                _radio.checked = NO;
            }
        }
    }
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [_delegate didSelectedRadioButton:self groupId:_groupId];
    }

}

- (void)radioBtnChecked {
    if (_checked) {
        return;
    }
    
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [_delegate didSelectedRadioButton:self groupId:_groupId];
        
    }
}


//- (CGRect)imageRectForContentRect:(CGRect)contentRect {
//    return CGRectMake((CGRectGetWidth(contentRect) - Q_RADIO_ICON_WH)/2.0, (CGRectGetHeight(contentRect) - Q_RADIO_ICON_WH)/2.0, Q_RADIO_ICON_WH, Q_RADIO_ICON_WH);
//}
//
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect {
//    return CGRectMake(Q_RADIO_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
//                      CGRectGetWidth(contentRect) - Q_RADIO_ICON_WH - Q_ICON_TITLE_MARGIN,
//                      CGRectGetHeight(contentRect));
//}



- (void)dealloc {
    NSLog(@"回收了");
    _delegate = nil;
    _groupId = nil;
}




@end
