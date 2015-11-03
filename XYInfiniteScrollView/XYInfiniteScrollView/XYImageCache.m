//
//  XYImageCache.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/31.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYImageCache.h"
#import <CommonCrypto/CommonDigest.h>


@interface NSString (MD5)
- (NSString *)MD5String;
@end

@implementation NSString (MD5)
- (NSString *)MD5String {
  const char *string = self.UTF8String;
  int length = (int)strlen(string);
  unsigned char bytes[CC_MD5_DIGEST_LENGTH];
  CC_MD5(string, length, bytes);
  return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length {
  NSMutableString *mutableString = @"".mutableCopy;
  for (int i = 0; i < length; i++) {
    [mutableString appendFormat:@"%02x", bytes[i]];
  }
  return [NSString stringWithString:mutableString];
}
@end

// Inspired by SDWebImage https://github.com/rs/SDWebImage/blob/master/SDWebImage/SDImageCache.m#L15
#pragma mark - AutoPurgeCache
@interface AutoPurgeCache : NSCache
@end

@implementation AutoPurgeCache

- (instancetype)init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllObjects)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIApplicationDidReceiveMemoryWarningNotification
                                                object:nil];
}

@end


#pragma mark - XYImageCache
@interface XYImageCache ()

@property (nonatomic, strong) AutoPurgeCache *memoryCache;
@property (nonatomic, copy) NSString *folderCachePath;
// 后台缓存数据
@property (nonatomic, strong) NSOperation *cacheOperation;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation XYImageCache

+ (instancetype)sharedImageCache {
  static dispatch_once_t onceToken;
  static XYImageCache *imageCache = nil;
  dispatch_once(&onceToken, ^{
    imageCache = [[self alloc] init];
  });
  return imageCache;
}

- (void)queryImageFromCacheWithKey:(NSString *)key completion:(XYQueryImageCompletion)completion {
  NSString *cacheKey = [key MD5String];
  id image = [self.memoryCache objectForKey:cacheKey];
  
  if (image) { // 内存缓存有
    
  // } else if () { // disk 查找
    
  // } else { // 发送网络请求
  
  }
}

- (NSString *)fullImageCachePathWithKey:(NSString *)cacheKey {
  NSString *imagePath = [self.folderCachePath stringByAppendingPathComponent:cacheKey];
  return imagePath;
}

- (NSString *)folderCachePath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *folderPath = [[paths firstObject] stringByAppendingPathComponent:@"Default"];
  return folderPath;
}

- (AutoPurgeCache *)memoryCache {
  if (!_memoryCache) {
    _memoryCache = [[AutoPurgeCache alloc] init];
  }
  return _memoryCache;
}
@end
