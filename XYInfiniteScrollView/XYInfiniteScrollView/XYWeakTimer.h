//
//  XYWeakTimer.h
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/26.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XYWeakTimerBlock)(id userInfo);

@interface XYWeakTimer : NSObject
+ (NSTimer *)xy_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                        target:(id)aTarget
                                      selector:(SEL)aSelector
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)yesOrNo;

+ (NSTimer *)xy_scheduledTimerWithTimeInterval:(NSTimeInterval)ti
                                         block:(XYWeakTimerBlock)block
                                      userInfo:(id)userInfo
                                       repeats:(BOOL)yesOrNo;
@end
