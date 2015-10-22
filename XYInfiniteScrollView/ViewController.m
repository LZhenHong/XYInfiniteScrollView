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
@end

@implementation ViewController

- (NSArray *)items {
  if (!_items) {
    NSMutableArray *tempItems = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
      NSString *imageName = [NSString stringWithFormat:@"Image_%d", i];
      UIImage *image = [UIImage imageNamed:imageName];
      
      XYInfiniteScrollItem *item = [[XYInfiniteScrollItem alloc] init];
      item.image = image;
      item.operation = ^(XYInfiniteScrollItem *blockItem) {
        NSLog(@"%@", blockItem.title);
      };
      
      item.position = XYInfiniteScrollItemTextPositionBottom;
      item.title = [NSString stringWithFormat:@"----> %d", i];
      
      [tempItems addObject:item];
    }
    _items = [tempItems copy];
  }
  return _items;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor lightGrayColor];
  
  XYInfiniteScrollView *isv = [[XYInfiniteScrollView alloc] init];
  isv.items = self.items;
  isv.center = self.view.center;
  CGFloat width = self.view.frame.size.width - 2 * 20;
  isv.bounds = CGRectMake(0, 0, width, width * 0.5625);
  [self.view addSubview:isv];
  self.isv = isv;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (self.isv.scrollDirection == XYInfiniteScrollViewDirectionPortrait) {
    self.isv.scrollDirection = XYInfiniteScrollViewDirectionLandscape;
  } else {
    self.isv.scrollDirection = XYInfiniteScrollViewDirectionPortrait;
  }
}

@end
