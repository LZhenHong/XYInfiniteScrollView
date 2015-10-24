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
  XYInfiniteScrollItemTextPositionHidden,
// TODO
//  XYInfiniteScrollItemTextPositionLeft,
//  XYInfiniteScrollItemTextPositionRight,
  XYInfiniteScrollItemTextPositionTop,
  XYInfiniteScrollItemTextPositionBottom
} XYInfiniteScrollItemTextPosition;

@interface XYInfiniteScrollItem : NSObject

/**
 *  文字默认隐藏，设置 title 之后，还需设置 position
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, assign) CGFloat maxTitleWidth;
/**
 *  当同时需要控制 height\width 的时候就必须使用
 */
@property (nonatomic, assign) CGSize maxTitleSize;

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleBackgroundColor;

@property (nonatomic, copy) InfiniteScrollItemOperationBlock operation;
@property (nonatomic, assign) XYInfiniteScrollItemTextPosition position;


- (instancetype)initWithTitle:(NSString *)title
                    imageName:(NSString *)imageName
                     position:(XYInfiniteScrollItemTextPosition)position;

+ (instancetype)infiniteScrollItemWithTitle:(NSString *)title
                                  imageName:(NSString *)imageName
                                   position:(XYInfiniteScrollItemTextPosition)position;
@end
