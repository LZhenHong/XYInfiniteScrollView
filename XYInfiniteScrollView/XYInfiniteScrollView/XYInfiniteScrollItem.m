//
//  XYInfiniteScrollItem.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYInfiniteScrollItem.h"

@implementation XYInfiniteScrollItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image position:(XYInfiniteScrollItemTextPosition)position {
  if (self = [super init]) {
    self.title = [title copy];
    self.image = image;
    self.position = position;
  }
  return self;
}

+ (instancetype)infiniteScrollItemWithTitle:(NSString *)title image:(UIImage *)image position:(XYInfiniteScrollItemTextPosition)position {
  return [[self alloc] initWithTitle:title image:image position:position];
}

- (XYInfiniteScrollItemTextPosition)position {
  if (!_position) {
    return XYInfiniteScrollItemTextPositionHidden;
  }
  return _position;
}
@end
