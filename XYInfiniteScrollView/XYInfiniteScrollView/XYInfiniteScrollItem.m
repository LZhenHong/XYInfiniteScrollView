//
//  XYInfiniteScrollItem.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYInfiniteScrollItem.h"

@implementation XYInfiniteScrollItem
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName position:(XYInfiniteScrollItemTextPosition)position {
  if (self = [super init]) {
    self.title = [title copy];
    self.imageName = [imageName copy];
    self.position = position;
  }
  return self;
}

+ (instancetype)infiniteScrollItemWithTitle:(NSString *)title imageName:(NSString *)imageName position:(XYInfiniteScrollItemTextPosition)position {
  return [[self alloc] initWithTitle:title imageName:imageName position:position];
}

@end
