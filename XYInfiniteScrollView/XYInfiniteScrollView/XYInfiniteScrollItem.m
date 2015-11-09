//
//  XYInfiniteScrollItem.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYInfiniteScrollItem.h"

@implementation XYInfiniteScrollItem
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
  if (self = [super init]) {
    self.title = [title copy];
    self.imageName = [imageName copy];
  }
  return self;
}

+ (instancetype)infiniteScrollItemWithTitle:(NSString *)title imageName:(NSString *)imageName {
  return [[self alloc] initWithTitle:title imageName:imageName];
}

- (instancetype)initWithTitle:(NSString *)title imageURL:(NSString *)imageURL {
  if (self = [super init]) {
    self.title = [title copy];
    self.imageURL = [imageURL copy];
  }
  return self;
}

+ (instancetype)infiniteScrollItemWithTitle:(NSString *)title imageURL:(NSString *)imageURL {
  return [[self alloc] initWithTitle:title imageURL:imageURL];
}

@end
