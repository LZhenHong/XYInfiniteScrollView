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
 *  装的是 XYInfiniteScrollItem 对象
 */
@property (nonatomic, strong) NSArray *items;
/**
 *  默认是 XYInfiniteScrollViewDirectionLanscape
 */
@property (nonatomic, assign) XYInfiniteScrollViewDirection scrollDirection;

@property (nonatomic, assign, getter=isPageControlHidden) BOOL pageControlHidden;
/**
 *  只有在 pageControlHidden == NO 的时候才有用，相对于 infinitScrollView.bounds 来说的
 */
@property (nonatomic, assign) CGPoint pageControlCenter;

/**
 *  自定义的 pageControl
 */
//@property (nonatomic, strong) UIPageControl *constomPageControl;
@end
