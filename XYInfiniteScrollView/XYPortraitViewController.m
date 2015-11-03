//
//  XYPortraitViewController.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/27.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYPortraitViewController.h"
#import "XYInfiniteScrollViewHeader.h"

@interface XYPortraitViewController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) XYInfiniteScrollView *isv;
@end

@implementation XYPortraitViewController

- (NSArray *)items {
  if (!_items) {
    NSMutableArray *tempItems = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
      NSString *imageName = [NSString stringWithFormat:@"Image_%d", i + 1];
      
      XYInfiniteScrollItem *item = [[XYInfiniteScrollItem alloc] init];
      item.imageName = imageName;
      item.operation = ^(XYInfiniteScrollItem *blockItem) {
        NSLog(@"%@", blockItem.title);
      };
      item.title = [NSString stringWithFormat:@"ImageName -> %@", imageName];
      item.titleFont = [UIFont fontWithName:@"Monoisome-Regular" size:12];
      item.titleColor = [UIColor redColor];
      item.titleBackgroundColor = [UIColor greenColor];
      
      item.position = XYInfiniteScrollItemTextPositionTop;
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
  self.title = @"Portrait";

  
  XYInfiniteScrollView *isv = [[XYInfiniteScrollView alloc] init];
  isv.center = self.view.center;
  CGFloat width = self.view.frame.size.width - 2 * 20;
  isv.bounds = CGRectMake(0, 0, width, width * 0.5625);
  
  isv.items = self.items;
  isv.scrollDirection = XYInfiniteScrollViewDirectionPortrait;
  
  isv.timerEnabled = YES;
  isv.timeInterval = 0.4f;
  
  
  [self.view addSubview:isv];
}

@end
