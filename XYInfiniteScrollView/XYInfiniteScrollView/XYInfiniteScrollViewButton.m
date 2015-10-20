//
//  XYInfiniteScrollViewButton.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYInfiniteScrollViewButton.h"
#import "XYInfiniteScrollItem.h"

@implementation XYInfiniteScrollViewButton

static CGFloat titleHeight = 30.0;

- (instancetype)init {
  if (self = [super init]) {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
  return self.bounds;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
  CGRect rect = CGRectZero;
  if (self.item.position == XYInfiniteScrollItemPositioTop) {
    rect = CGRectMake(10, 0, self.bounds.size.width - 10, titleHeight);
  } else if (self.item.position == XYInfiniteScrollItemPositionBottom) {
    rect = CGRectMake(10, self.bounds.size.height - titleHeight, self.bounds.size.width - 10, titleHeight);
  } 
  return rect;
}

- (void)setItem:(XYInfiniteScrollItem *)item {
  _item = item;
  
  [self setImage:item.image forState:UIControlStateNormal];
  [self setTitle:item.title forState:UIControlStateNormal];
}

- (void)btnClicked {
  __weak typeof(self.item) weakItem = self.item;
  if (self.item.operation != nil) {
    self.item.operation(weakItem);
  }
}

@end
