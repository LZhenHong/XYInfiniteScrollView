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
#import "XYWeakTimer.h"

@interface XYInfiniteScrollView () <UIScrollViewDelegate>
@property (nonatomic, strong) XYInfiniteScrollViewButton *leftButton;
@property (nonatomic, strong) XYInfiniteScrollViewButton *currentButton;
@property (nonatomic, strong) XYInfiniteScrollViewButton *rightButton;

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation XYInfiniteScrollView

- (instancetype)init {
  if (self = [super init]) {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    [self setupButtons];
    
    self.scrollDirection = XYInfiniteScrollViewDirectionLandscape;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)setupButtons {
  self.leftButton = [[XYInfiniteScrollViewButton alloc] init];
  [self.scrollView addSubview:self.leftButton];
  
  self.currentButton = [[XYInfiniteScrollViewButton alloc] init];
  [self.scrollView addSubview:self.currentButton];
  
  self.rightButton = [[XYInfiniteScrollViewButton alloc] init];
  [self.scrollView addSubview:self.rightButton];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.scrollView.frame = self.bounds;
  
  [self resetButtonPosition];  
  [self setupTimer];

  if (!self.isPageControlHidden) {
    [self setupPageControl];
  }
  
}

- (void)resetButtonPosition {
  CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
  CGFloat scrollViewHeight = self.scrollView.bounds.size.height;
  if (self.scrollDirection == XYInfiniteScrollViewDirectionLandscape) {
    self.leftButton.frame = CGRectMake(-scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.currentButton.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.rightButton.frame = CGRectMake(scrollViewWidth, 0, scrollViewWidth, scrollViewHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake(0, scrollViewWidth, 0, 2 * scrollViewWidth);
  } else {
    self.leftButton.frame = CGRectMake(0, -scrollViewHeight, scrollViewWidth, scrollViewHeight);
    self.currentButton.frame = CGRectMake(0, 0, scrollViewWidth, scrollViewHeight);
    self.rightButton.frame = CGRectMake(0, scrollViewHeight, scrollViewWidth, scrollViewHeight);
    self.scrollView.contentInset = UIEdgeInsetsMake(scrollViewHeight, 0, 2 * scrollViewHeight, 0);
  }
  self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)dealloc {
  [self.timer invalidate];
  self.timer = nil;
}



#pragma mark - setter

- (void)setScrollDirection:(XYInfiniteScrollViewDirection)scrollDirection {
  _scrollDirection = scrollDirection;
  
  [self resetButtonPosition];
  [self updateButtons];
}

- (void)setPageControlHidden:(BOOL)pageControlHidden {
  _pageControlHidden = pageControlHidden;
  
  if (pageControlHidden) {
    [self.pageControl removeFromSuperview];
    self.pageControl = nil;
  } else {
    [self setupPageControl];
  }
}

- (void)setPageControlCenter:(CGPoint)pageControlCenter {
  _pageControlCenter = pageControlCenter;
  
  self.pageControl.center = pageControlCenter;
}

- (void)setTimerEnabled:(BOOL)timerEnabled {
  _timerEnabled = timerEnabled;
  
  [self setupTimer];
}

- (void)setupTimer {
  if (self.isTimerEnabled) {
    [self.timer invalidate];
    self.timer = nil;
    NSTimeInterval tempInterval = self.timeInterval == 0.0f ? 1.0f : self.timeInterval;
    self.timer = [XYWeakTimer xy_scheduledTimerWithTimeInterval:tempInterval block:^(id userInfo) {
      [self nextImage];
    } userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
  } else {
    [self.timer invalidate];
    self.timer = nil;
  }
}

- (void)nextImage {
  if (self.scrollDirection == XYInfiniteScrollViewDirectionPortrait) {
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.bounds.size.height) animated:YES];
  } else {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0) animated:YES];
  }
  
  [self scrollViewDidScroll:self.scrollView];
  [self updateButtons];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
  _timeInterval = timeInterval;
  
  [self setTimerEnabled:self.isTimerEnabled];
}

- (void)setupPageControl {
  if (self.pageControl == nil) {
    if (self.customPageControl != nil) {
      self.pageControl = self.customPageControl;
    } else {
      UIPageControl *pageControl = [[UIPageControl alloc] init];
      self.pageControl = pageControl;
    }
  }
  
  self.pageControl.numberOfPages = self.items.count;
  self.pageControl.currentPage = self.currentButton.tag;
  self.pageControl.center = !CGPointEqualToPoint(self.pageControlCenter, CGPointZero) ? self.pageControlCenter : CGPointMake(self.bounds.size.width * 0.5, self.currentButton.pageControlCenterY);
  self.pageControl.userInteractionEnabled = NO;
  [self addSubview:self.pageControl];
}

- (void)setItems:(NSArray *)items {
  _items = items;

  [self.leftButton setTag:self.items.count - 1];
  [self.currentButton setTag:0];
  [self.rightButton setTag:1];
  [self updateButtons];
}



#pragma mark - scrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self updateButtons];
  [self.timer invalidate];
  self.timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGFloat firstDistance = 0;
  CGFloat secondDistance = 0;
  CGFloat thirdDistance = 0;
  
  if (self.scrollDirection == XYInfiniteScrollViewDirectionPortrait) {
    firstDistance = fabs(self.scrollView.contentOffset.y - self.leftButton.frame.origin.y);
    secondDistance = fabs(self.scrollView.contentOffset.y - self.currentButton.frame.origin.y);
    thirdDistance = fabs(self.scrollView.contentOffset.y - self.rightButton.frame.origin.y);
  } else {
    firstDistance = fabs(self.scrollView.contentOffset.x - self.leftButton.frame.origin.x);
    secondDistance = fabs(self.scrollView.contentOffset.x - self.currentButton.frame.origin.x);
    thirdDistance = fabs(self.scrollView.contentOffset.x - self.rightButton.frame.origin.x);
  }
  
  self.currentButton.tag = [self tagWithShortestDistanceWithLeftDistance:firstDistance
                                                         currentDistance:secondDistance
                                                           rightDistance:thirdDistance];
  self.pageControl.currentPage = self.currentButton.tag;
//  NSLog(@"leftTAG: %ld, currentTAG: %ld, rightTAG: %ld", self.leftButton.tag, self.currentButton.tag, self.rightButton.tag);
}

- (NSInteger)tagWithShortestDistanceWithLeftDistance:(CGFloat)left currentDistance:(CGFloat)current rightDistance:(CGFloat)right {
  if (left < current) {
    return self.leftButton.tag;
  } else if (right < current) {
    return self.rightButton.tag;
  }
  return self.currentButton.tag;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  [self setupTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self updateButtons];
}



#pragma mark - private methods

- (void)updateButtons {
  self.leftButton.tag = self.currentButton.tag - 1 < 0 ? self.items.count - 1 : self.currentButton.tag - 1;
  self.rightButton.tag = self.currentButton.tag + 1 >= self.items.count ? 0 : self.currentButton.tag + 1;
  
  self.leftButton.item = self.items[self.leftButton.tag];
  self.currentButton.item = self.items[self.currentButton.tag];
  self.rightButton.item = self.items[self.rightButton.tag];

  self.scrollView.contentOffset = CGPointZero;
//  NSLog(@"leftTAG: %ld, currentTAG: %ld, rightTAG: %ld", self.leftButton.tag, self.currentButton.tag, self.rightButton.tag);
}

@end
