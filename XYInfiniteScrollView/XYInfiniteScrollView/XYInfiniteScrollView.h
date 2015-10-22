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
}XYInfiniteScrollViewDirection;

@interface XYInfiniteScrollView : UIScrollView
/**
 *  装的是 XYInfiniteScrollItem 对象
 */
@property (nonatomic, strong) NSArray *items;
/**
 *  默认是 XYInfiniteScrollViewDirectionLanscape
 */
@property (nonatomic, assign) XYInfiniteScrollViewDirection scrollDirection;
@end
