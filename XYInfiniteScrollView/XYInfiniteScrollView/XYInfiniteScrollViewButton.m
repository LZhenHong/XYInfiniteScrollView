//
//  XYInfiniteScrollViewButton.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/20.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYInfiniteScrollViewButton.h"
#import "XYInfiniteScrollItem.h"

@implementation XYInfiniteScrollViewButton {
  CGFloat _pageControlCenterY;
}

static CGFloat margin = 10.0;

- (instancetype)init {
  if (self = [super init]) {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

- (CGFloat)pageControlCenterY {
  return _pageControlCenterY;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
  return self.bounds;
}

- (NSDictionary *)titleAttributes {
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  attributes[NSFontAttributeName] = self.titleLabel.font;
  return [attributes copy];
}

- (CGSize)maxSize {
  if (!CGSizeEqualToSize(self.item.maxTitleSize, CGSizeZero)) {
    return self.item.maxTitleSize;
  } else {
    return CGSizeMake(self.item.maxTitleWidth, MAXFLOAT);
  }
}

- (CGSize)sizeForTitle {
  return [self.item.title boundingRectWithSize:[self maxSize]
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:[self titleAttributes]
                                       context:nil].size;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
  CGRect rect = CGRectZero;
  if (self.item.position == XYInfiniteScrollItemTextPositionHidden) {
    _pageControlCenterY = self.bounds.size.height - margin;
    return rect;
  }
  
  CGSize size = [self sizeForTitle];
  if (self.item.position == XYInfiniteScrollItemTextPositionTop) {
    rect = CGRectMake(margin, 0, size.width, size.height);
    _pageControlCenterY = self.bounds.size.height - margin;
  } else if (self.item.position == XYInfiniteScrollItemTextPositionBottom) {
    rect = CGRectMake(margin, self.bounds.size.height - size.height, size.width, size.height);
    _pageControlCenterY = self.bounds.size.height - size.height - margin;
  }
  
  return rect;
}

- (void)setItem:(XYInfiniteScrollItem *)item {
  _item = item;
  
  UIImage *image = [UIImage imageNamed:item.imageName];
  [self setImage:image forState:UIControlStateNormal];
  [self setTitleColor:self.item.titleColor forState:UIControlStateNormal];
  [self setTitle:item.title forState:UIControlStateNormal];
  self.titleLabel.font = self.item.titleFont;
  self.titleLabel.backgroundColor = self.item.titleBackgroundColor;
}

- (void)btnClicked {
  __weak typeof(self.item) weakItem = self.item;
  if (self.item.operation != nil) {
    self.item.operation(weakItem);
  }
}

@end
