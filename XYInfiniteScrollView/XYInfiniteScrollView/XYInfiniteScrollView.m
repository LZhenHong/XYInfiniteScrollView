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

@interface XYInfiniteScrollView () <UIScrollViewDelegate>
@property (nonatomic, weak) XYInfiniteScrollViewButton *leftButton;
@property (nonatomic, weak) XYInfiniteScrollViewButton *currentButton;
@property (nonatomic, weak) XYInfiniteScrollViewButton *rightButton;
@end

@implementation XYInfiniteScrollView

- (instancetype)init {
  if (self = [super init]) {
    
    [self setupButtons];
    
    self.scrollDirection = XYInfiniteScrollViewDirectionLandscape;
    
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

- (void)setScrollDirection:(XYInfiniteScrollViewDirection)scrollDirection {
  _scrollDirection = scrollDirection;
  [self resetButtonPosition];
  [self updateButtons];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self resetButtonPosition];
}

- (void)resetButtonPosition {
  CGFloat scrollViewWidth = self.bounds.size.width;
  CGFloat scrollViewHeight = self.bounds.size.height;
  if (self.scrollDirection == XYInfiniteScrollViewDirectionLandscape) {
    self.leftButton.frame = CGRectMake(-scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.currentButton.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.rightButton.frame = CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.contentInset = UIEdgeInsetsMake(0, scrollViewWidth, 0, 2 * scrollViewWidth);
  } else {
    self.leftButton.frame = CGRectMake(0, -scrollViewHeight, scrollViewWidth, scrollViewHeight);
    self.currentButton.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.rightButton.frame = CGRectMake(0, scrollViewHeight, scrollViewWidth, scrollViewHeight);
    self.contentInset = UIEdgeInsetsMake(scrollViewHeight, 0, 2 * scrollViewHeight, 0);
  }
}

- (void)setItems:(NSArray *)items {
  _items = items;

  [self.leftButton setTag:self.items.count - 1];
  [self.currentButton setTag:0];
  [self.rightButton setTag:1];
  [self updateButtons];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self updateButtons];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGFloat firstDistance = 0;
  CGFloat secondDistance = 0;
  CGFloat thirdDistance = 0;
  if (self.scrollDirection == XYInfiniteScrollViewDirectionPortrait) {
    firstDistance = fabs(self.contentOffset.y - self.leftButton.frame.origin.y);
    secondDistance = fabs(self.contentOffset.y - self.currentButton.frame.origin.y);
    thirdDistance = fabs(self.contentOffset.y - self.rightButton.frame.origin.y);
  } else {
    firstDistance = fabs(self.contentOffset.x - self.leftButton.frame.origin.x);
    secondDistance = fabs(self.contentOffset.x - self.currentButton.frame.origin.x);
    thirdDistance = fabs(self.contentOffset.x - self.rightButton.frame.origin.x);
  }
  
  self.currentButton.tag = [self tagWithShortestDistanceWithLeftDistance:firstDistance
                                                         currentDistance:secondDistance
                                                           rightDistance:thirdDistance];
//  NSLog(@"left: %ld, currnet: %ld, right: %ld", leftImage, currentImage, rightImage);
}

- (NSInteger)tagWithShortestDistanceWithLeftDistance:(CGFloat)left currentDistance:(CGFloat)current rightDistance:(CGFloat)right {
  if (left <= current) {
    return self.leftButton.tag;
  } else if (right <= current) {
    return self.rightButton.tag;
  }
  return self.currentButton.tag;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self updateButtons];
}

- (void)updateButtons {
  self.leftButton.tag = self.currentButton.tag - 1 < 0 ? self.items.count - 1 : self.currentButton.tag - 1;
  self.rightButton.tag = self.currentButton.tag + 1 >= self.items.count ? 0 : self.currentButton.tag + 1;
  
  self.leftButton.item = self.items[self.leftButton.tag];
  self.currentButton.item = self.items[self.currentButton.tag];
  self.rightButton.item = self.items[self.rightButton.tag];
  
  self.contentOffset = CGPointZero;
  
//  NSLog(@"leftTAG: %ld, currnetTAG: %ld, rightTAG: %ld", self.leftButton.tag, self.currentButton.tag, self.rightButton.tag);
}

@end
