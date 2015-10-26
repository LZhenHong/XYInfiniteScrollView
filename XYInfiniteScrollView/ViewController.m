//
//  ViewController.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "ViewController.h"
#import "XYInfiniteScrollViewHeader.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) XYInfiniteScrollView *isv;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation ViewController

- (NSArray *)items {
  if (!_items) {
    NSMutableArray *tempItems = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
      NSString *imageName = [NSString stringWithFormat:@"Image_%d", i];
      
      XYInfiniteScrollItem *item = [[XYInfiniteScrollItem alloc] init];
      item.imageName = imageName;
      item.operation = ^(XYInfiniteScrollItem *blockItem) {
        NSLog(@"%@", blockItem.title);
      };
      item.title = [NSString stringWithFormat:@"ImageName -> %@", imageName];
      item.titleFont = [UIFont fontWithName:@"Monoisome-Regular" size:12];
      item.titleColor = [UIColor redColor];
      item.titleBackgroundColor = [UIColor blueColor];
      
      item.position = XYInfiniteScrollItemTextPositionHidden;
//      item.position = XYInfiniteScrollItemTextPositionTop;
//      item.maxTitleWidth = self.view.frame.size.width * 0.5;
      
      [tempItems addObject:item];
    }
    _items = [tempItems copy];
  }
  return _items;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self customPageControl];
  
  self.view.backgroundColor = [UIColor lightGrayColor];
  
  XYInfiniteScrollView *isv = [[XYInfiniteScrollView alloc] init];
  isv.items = self.items;
  isv.center = self.view.center;
  CGFloat width = self.view.frame.size.width - 2 * 20;
  isv.bounds = CGRectMake(0, 0, width, width * 0.5625);
  isv.timerEnabled = YES;
//  isv.timeInterval = 0.4f;
  [self.view addSubview:isv];
  self.isv = isv;
}

// 在快速切换垂直滚动和竖直滚动时有 bug
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (self.isv.scrollDirection == XYInfiniteScrollViewDirectionPortrait) {
    self.isv.scrollDirection = XYInfiniteScrollViewDirectionLandscape;
    self.isv.pageControlHidden = NO;
    self.isv.customPageControl = self.pageControl;
  } else {
    self.isv.scrollDirection = XYInfiniteScrollViewDirectionPortrait;
    self.isv.pageControlHidden = YES;
  }
}

- (void)customPageControl {
  self.pageControl = [[UIPageControl alloc] init];
  self.pageControl.pageIndicatorTintColor = [UIColor redColor];
  self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
}

@end
