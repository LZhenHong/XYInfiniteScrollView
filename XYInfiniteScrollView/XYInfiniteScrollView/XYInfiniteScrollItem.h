//
//  XYInfiniteScrollItem.h
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYInfiniteScrollItem;

typedef void(^InfiniteScrollItemOperationBlock)(XYInfiniteScrollItem *item);

typedef enum {
  XYInfiniteScrollItemPositionHidden,
// TODO
//  XYInfiniteScrollItemPositionLeft,
//  XYInfiniteScrollItemPositionRight,
  XYInfiniteScrollItemPositioTop,
  XYInfiniteScrollItemPositionBottom
}XYInfiniteScrollItemPosition;

@interface XYInfiniteScrollItem : NSObject

/**
 *  文字默认隐藏，设置 title 之后，还需设置 position
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) InfiniteScrollItemOperationBlock operation;
@property (nonatomic, assign) XYInfiniteScrollItemPosition position;



- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
                     position:(XYInfiniteScrollItemPosition)position;

+ (instancetype)infiniteScrollItemWithTitle:(NSString *)title
                                      image:(UIImage *)image
                                   position:(XYInfiniteScrollItemPosition)position;
@end
