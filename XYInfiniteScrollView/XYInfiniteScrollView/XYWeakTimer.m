//
//  XYWeakTimer.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/26.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYWeakTimer.h"

@interface XYWeakTimerTarget : NSObject

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) id target;

@end

@implementation XYWeakTimerTarget

- (void)fireTimer:(NSTimer *)timer {
  if (self.target) {
    [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0f];
  } else {
    [self.timer invalidate];
    self.timer = nil;
  }
}

@end

@implementation XYWeakTimer

+ (NSTimer *)xy_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
  XYWeakTimerTarget *timerTarget = [[XYWeakTimerTarget alloc] init];
  timerTarget.selector = aSelector;
  timerTarget.target = aTarget;
  timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:timerTarget selector:@selector(fireTimer:) userInfo:userInfo repeats:yesOrNo];
  
  return timerTarget.timer;
}

+ (NSTimer *)xy_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(XYWeakTimerBlock)block userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
  NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:[block copy], nil];
  if (userInfo != nil) {
    infoArray[1]  = userInfo;
  }
  return [self xy_scheduledTimerWithTimeInterval:ti target:self selector:@selector(_timerOperation:) userInfo:[infoArray copy] repeats:yesOrNo];
}

+ (void)_timerOperation:(NSArray *)userInfoArray {
  XYWeakTimerBlock operation = userInfoArray[0];
  
  id info = nil;
  if (userInfoArray.count == 2) {
    info = userInfoArray[1];
  }
  
  !operation ? : operation(info);
}

@end
