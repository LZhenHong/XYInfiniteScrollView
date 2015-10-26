//
//  XYInfiniteScrollView.h
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 scrollView 滚动的方向
 */
typedef enum {
  XYInfiniteScrollViewDirectionPortrait,
  XYInfiniteScrollViewDirectionLandscape
} XYInfiniteScrollViewDirection;

@interface XYInfiniteScrollView : UIView
/**
 *  XYInfiniteScrollItem 对象数组
 */
@property (nonatomic, strong) NSArray *items;
/**
 *  默认是 XYInfiniteScrollViewDirectionLanscape
 */
@property (nonatomic, assign) XYInfiniteScrollViewDirection scrollDirection;
/**
 *  只有在 pageControlHidden == NO 的时候才有用，相对于 infinitScrollView.bounds 来说的
 */
@property (nonatomic, assign) CGPoint pageControlCenter;

/**
 *  自定义的 pageControl
 */
@property (nonatomic, strong) UIPageControl *customPageControl;
/**
 *  自定义 pageControl 时该属性为 YES
 */
@property (nonatomic, assign, getter=isPageControlHidden) BOOL pageControlHidden;
/**
 *  是否开启定时器
 */
@property (nonatomic, assign, getter=isTimerEnabled) BOOL timerEnabled;
/**
 *  只有在 timerEnabled == YES 有用
 *  默认 1.0f
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end
