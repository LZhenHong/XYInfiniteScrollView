//
//  XYDownloadImageViewController.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/11/9.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYDownloadImageViewController.h"
#import "XYInfiniteScrollViewHeader.h"

@interface XYDownloadImageViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, weak) XYInfiniteScrollView *isv;
@end

@implementation XYDownloadImageViewController

- (NSArray *)imageURLs {
  return @[
           @"http://img31.mtime.cn/mt/2015/10/19/084628.87920280_186X279X4.jpg",
           @"http://img31.mtime.cn/mt/2015/10/19/090840.54785701_186X279X4.jpg",
           @"http://img31.mtime.cn/mt/2015/10/16/090856.70013382_186X279X4.jpg",
           @"http://img31.mtime.cn/mt/2015/10/30/091410.18885862_186X279X4.jpg",
           @"http://img31.mtime.cn/mt/2015/09/15/163509.99636592_140X210X4.jpg"
           ];
}

- (NSArray *)items {
  if (!_items) {
    NSMutableArray *tempItems = [NSMutableArray array];
    for (int i = 0; i < self.imageURLs.count; ++i) {
      
      XYInfiniteScrollItem *item = [[XYInfiniteScrollItem alloc] init];
      item.imageURL = self.imageURLs[i];
      item.operation = ^(XYInfiniteScrollItem *blockItem) {
        NSLog(@"%@", blockItem.title);
      };
      item.title = [NSString stringWithFormat:@"%@", self.imageURLs[i]];
      item.titleFont = [UIFont fontWithName:@"Monoisome-Regular" size:12];
      
      item.position = XYInfiniteScrollItemTextPositionBottom;
      
      [tempItems addObject:item];
    }
    _items = [tempItems copy];
  }
  return _items;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor lightGrayColor];
  self.title = @"Internet Download";
  
  XYInfiniteScrollView *isv = [[XYInfiniteScrollView alloc] init];
  isv.center = self.view.center;
  CGFloat width = self.view.frame.size.width - 2 * 20;
  isv.bounds = CGRectMake(0, 0, width, width * 0.5625);
  
  isv.items = self.items;
  // 拖拽时图片会闪烁
  isv.scrollDirection = XYInfiniteScrollViewDirectionLandscape;
  
  isv.timerEnabled = YES;
  
  [self.view addSubview:isv];
}
@end
