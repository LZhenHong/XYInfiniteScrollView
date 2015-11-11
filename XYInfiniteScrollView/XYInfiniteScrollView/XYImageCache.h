//
//  XYImageCache.h
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/31.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XYImageSourceType) {
  XYImageSourceTypeNone,
  XYImageSourceTypeWeb,
  XYImageSourceTypeMemory,
  XYImageSourceTypeDisk
};

typedef void(^XYQueryImageCompletion)(UIImage *image, XYImageSourceType source);
typedef void(^XYCacheImageCompletion)(BOOL isSucceeded);

@interface XYImageCache : NSObject

/**
 *  是否缓存到磁盘中
 */
@property (nonatomic, assign, getter=isDiskStored) BOOL diskStored;

/**
 *  内存中最多缓存多少张图片
 */
@property (nonatomic, assign) NSUInteger maxMemoryCacheNumber;


- (void)queryImageFromCacheWithKey:(NSString *)key completion:(XYQueryImageCompletion)completion;
- (void)cacheImageWithKey:(NSString *)key image:(UIImage *)image completion:(XYCacheImageCompletion)completion;
- (void)cacheImageOnlyInMemoryWithKey:(NSString *)key image:(UIImage *)image;
- (void)removeImageForKey:(NSString *)key;
- (void)clearMemroyCache;
- (void)clearDiskCache;

+ (instancetype)sharedImageCache;
@end
