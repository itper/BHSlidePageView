//
//  UIScrollView+BHForceStop.m
//
//  Created by chendi on 15/7/20.
//  Copyright (c) 2015年 ganji. All rights reserved.
//

#import "UIScrollView+BHForceStop.h"

@implementation UIScrollView(BHForceStop)

-(void)forcedStopScrollViewScroll{
    
    CGPoint offset = self.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
    
}
@end
