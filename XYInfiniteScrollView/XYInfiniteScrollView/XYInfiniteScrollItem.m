//
//  XYInfiniteScrollItem.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYInfiniteScrollItem.h"

@implementation XYInfiniteScrollItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image position:(XYInfiniteScrollItemPosition)position {
  if (self = [super init]) {
    self.title = [title copy];
    self.image = image;
    self.position = position;
  }
  return self;
}

+ (instancetype)infiniteScrollItemWithTitle:(NSString *)title image:(UIImage *)image position:(XYInfiniteScrollItemPosition)position {
  return [[self alloc] initWithTitle:title image:image position:position];
}

- (XYInfiniteScrollItemPosition)position {
  if (!_position) {
    return XYInfiniteScrollItemPositionHidden;
  }
  return _position;
}
@end
