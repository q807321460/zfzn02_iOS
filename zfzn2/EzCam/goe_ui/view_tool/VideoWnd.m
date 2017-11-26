//
//  VideoWnd.m
//  iDMSS
//
//  Created by Flying on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoWnd.h"
#import <QuartzCore/QuartzCore.h>

@implementation VideoWnd

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id)initWithCoder:(NSCoder*)coder {
    if ((self = [super initWithCoder:coder])) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        eaglLayer.contentsScale = 2.0;
    }
    return self;
}

@end
