//
//  XYLandscapeViewController.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/27.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYLandscapeViewController.h"
#import "XYInfiniteScrollView.h"
#import "XYInfiniteScrollItem.h"


@interface XYLandscapeViewController ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation XYLandscapeViewController

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
      
//      item.position = XYInfiniteScrollItemTextPositionHidden;
        item.position = XYInfiniteScrollItemTextPositionBottom;
        item.maxTitleWidth = self.view.frame.size.width * 0.5;
      
      [tempItems addObject:item];
    }
    _items = [tempItems copy];
  }
  return _items;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor lightGrayColor];
  self.title = @"Landscape";
  
  UIPageControl *pageControl = [[UIPageControl alloc] init];
  pageControl.pageIndicatorTintColor = [UIColor redColor];
  pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
  
  
  XYInfiniteScrollView *isv = [[XYInfiniteScrollView alloc] init];
  isv.center = self.view.center;
  CGFloat width = self.view.frame.size.width - 2 * 20;
  isv.bounds = CGRectMake(0, 0, width, width * 0.5625);
  
  isv.items = self.items;
  
  isv.timerEnabled = YES;
//  isv.timeInterval = 0.4f;
  
  isv.customPageControl = pageControl;

  [self.view addSubview:isv];
}

@end
