//
//  XYInfiniteScrollView.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYInfiniteScrollView.h"
#import "XYInfiniteScrollItem.h"
#import "XYInfiniteScrollViewButton.h"

#pragma mark - XYInfiniteScrollView
/**
 * scrollView 中图片滚动的方向
 * 当 scrollView 的滚动方向为 Portrait 时，只有 Up 和 Down 是有效的
 * 当 scrollView 的滚动方向为 Landscape 时，只有 Left 和 Right 是有效的
 */
typedef enum {
  InfiniteScrollDirectionUpRight,
  InfiniteScrollDirectionDownLeft
}InfiniteScrollDirection;

@interface XYInfiniteScrollView () <UIScrollViewDelegate>
@property (nonatomic, weak) XYInfiniteScrollViewButton *leftButton;
@property (nonatomic, weak) XYInfiniteScrollViewButton *currentButton;
@property (nonatomic, weak) XYInfiniteScrollViewButton *rightButton;
@end

@implementation XYInfiniteScrollView

- (instancetype)init {
  if (self = [super init]) {
    
    [self setupButtons];
    
//    self.scrollDirection = XYInfiniteScrollViewDirectionLandscape;
    
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    
    self.delegate = self;
  }
  return self;
}

- (void)setupButtons {
  XYInfiniteScrollViewButton *leftButton = [[XYInfiniteScrollViewButton alloc] init];
  [self addSubview:leftButton];
  self.leftButton = leftButton;
  
  XYInfiniteScrollViewButton *currentButton = [[XYInfiniteScrollViewButton alloc] init];
  [self addSubview:currentButton];
  self.currentButton = currentButton;
  
  XYInfiniteScrollViewButton *rightButton = [[XYInfiniteScrollViewButton alloc] init];
  [self addSubview:rightButton];
  self.rightButton = rightButton;
}

//- (void)setScrollDirection:(XYInfiniteScrollViewDirection)scrollDirection {
//  _scrollDirection = scrollDirection;
//  [self layoutSubviews];
//}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat scrollViewWidth = self.bounds.size.width;
  CGFloat scrollViewHeight = self.bounds.size.height;
//  if (self.scrollDirection == XYInfiniteScrollViewDirectionLandscape) {
    self.leftButton.frame = CGRectMake(-scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.currentButton.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.rightButton.frame = CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.contentInset = UIEdgeInsetsMake(0, scrollViewWidth, 0, 2 * scrollViewWidth);
//  } else {
//    self.leftButton.frame = CGRectMake(0, -scrollViewHeight, scrollViewWidth, scrollViewHeight);
//    self.currentButton.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
//    self.rightButton.frame = CGRectMake(0, scrollViewHeight, scrollViewWidth, scrollViewHeight);
//    self.contentInset = UIEdgeInsetsMake(scrollViewHeight, 0, 2 * scrollViewHeight, 0);
//  }
}

- (void)setItems:(NSArray *)items {
  _items = items;

  [self.leftButton setTag:self.items.count - 1];
  [self.currentButton setTag:0];
  [self.rightButton setTag:1];
  [self updateButtons];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if (self.contentOffset.x < 0 || self.contentOffset.y < 0) {
    [self updateButtonsWithScrollDirection:InfiniteScrollDirectionUpRight];
  } else if (self.contentOffset.x > 0 || self.contentOffset.y > 0) {
    [self updateButtonsWithScrollDirection:InfiniteScrollDirectionDownLeft];
  }
  self.contentOffset = CGPointMake(0, 0);
}

- (void)updateButtonsWithScrollDirection:(InfiniteScrollDirection)direction {
  
  NSInteger firstTag = [self.leftButton tag];
  NSInteger secondTag = [self.currentButton tag];
  NSInteger thirdTag = [self.rightButton tag];
  
  if (direction == InfiniteScrollDirectionUpRight) {
    [self.currentButton setTag:firstTag];
    [self.rightButton setTag:secondTag];
    NSInteger tempTag = firstTag - 1 < 0 ? self.items.count - 1 : firstTag - 1;
    [self.leftButton setTag:tempTag];
  } else {
    [self.leftButton setTag:secondTag];
    [self.currentButton setTag:thirdTag];
    NSInteger tempTag = thirdTag + 1 >= self.items.count ? 0 : thirdTag + 1;
    [self.rightButton setTag:tempTag];
  }
  
  [self updateButtons];
}

- (void)updateButtons {
  self.leftButton.item = self.items[self.leftButton.tag];
  self.currentButton.item = self.items[self.currentButton.tag];
  self.rightButton.item = self.items[self.rightButton.tag];
}

@end
