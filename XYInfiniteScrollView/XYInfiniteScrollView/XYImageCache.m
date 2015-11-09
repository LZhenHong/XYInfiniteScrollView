//
//  XYImageCache.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/10/31.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYImageCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "XYImageDownloader.h"


#pragma mark  A category of NSString
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
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy) NSString *folderCachePath;

@end

@implementation XYImageCache {
  dispatch_queue_t _cacheQueue;
}

+ (instancetype)sharedImageCache {
  static dispatch_once_t onceToken;
  static XYImageCache *imageCache = nil;
  dispatch_once(&onceToken, ^{
    imageCache = [[self alloc] init];
  });
  return imageCache;
}

- (instancetype)init {
  if (self = [super init]) {
    _cacheQueue = dispatch_queue_create("cacheImageToDiskQueue", DISPATCH_QUEUE_SERIAL);
    self.diskStored = YES;
  }
  return self;
}

- (void)queryImageFromCacheWithKey:(NSString *)key completion:(XYQueryImageCompletion)completion {
  if (!key) {
    completion(nil, XYImageSourceTypeNone);
    return;
  }
  
  UIImage *image = [self.memoryCache objectForKey:key];
  if (image) { // 内存缓存有
    // 对图片闪烁的暂时解决方法
//    dispatch_async(dispatch_get_main_queue(), ^{
      completion(image, XYImageSourceTypeMemory);
//    });
    return;
   }
  
  image = [self diskCachedImageWithKey:key];
  if (image) { // disk 查找
//    dispatch_async(dispatch_get_main_queue(), ^{
      completion(image, XYImageSourceTypeDisk);
//    });
    return;
  }
  
  // download from Internet
  [[XYImageDownloader sharedImageDownloader] downloadImageWithURLString:key completion:^(UIImage *image, NSError *error) {
    if (error || image == nil) {
      completion(nil, XYImageSourceTypeNone);
    } else {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(image, XYImageSourceTypeWeb);
      });
      [self cacheImageWithKey:key image:image completion:nil];
    }
  }];
}

- (void)cacheImageWithKey:(NSString *)key image:(UIImage *)image completion:(XYCacheImageCompletion)completion {
  if (!key) {
    return;
  }
  
  [self cacheImageOnlyInMemoryWithKey:key image:image];
  
  // 异步缓存到 disk
  if (self.isDiskStored) {
    dispatch_async(_cacheQueue, ^{
      if (![self.fileManager fileExistsAtPath:self.folderCachePath]) {
        [self.fileManager createDirectoryAtPath:self.folderCachePath withIntermediateDirectories:YES attributes:nil error:nil];
      }
      
      // disk 中已经存在
      if ([self.fileManager fileExistsAtPath:[self fullImageCachePathWithKey:key]]) {
        return;
      }
      
      NSData *imageData = UIImagePNGRepresentation(image);
      if (!imageData) {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
      }
      
      if (imageData) {
        NSString *cachePath = [self fullImageCachePathWithKey:key];
        [self.fileManager createFileAtPath:cachePath contents:imageData attributes:nil];
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        completion();
      });
        
    });
  }
}

- (void)cacheImageOnlyInMemoryWithKey:(NSString *)key image:(UIImage *)image {
  if ([self.memoryCache objectForKey:key] != nil) {
    return;
  }
  [self.memoryCache setObject:image forKey:key];
}

- (void)clearMemroyCache {
  [self.memoryCache removeAllObjects];
}

- (void)clearDiskCache {
  if (self.isDiskStored) {
    dispatch_async(_cacheQueue, ^{
      [self.fileManager removeItemAtPath:self.folderCachePath error:nil];
      [self.fileManager createDirectoryAtPath:self.folderCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    });
  }
}

- (void)removeImageForKey:(NSString *)key {
  if (!key) {
    return;
  }
  
  [self.memoryCache removeObjectForKey:key];
  
  if (self.isDiskStored) {
    NSString *imageCachePath = [self fullImageCachePathWithKey:key];
    BOOL existed = [self.fileManager fileExistsAtPath:imageCachePath];
    if (existed) {
      dispatch_async(_cacheQueue, ^{
        [self.fileManager removeItemAtPath:imageCachePath error:nil];
      });
    }
  }
  
}

#pragma mark  Helper methods
- (UIImage *)diskCachedImageWithKey:(NSString *)key {
  NSString *fullCachePath = [self fullImageCachePathWithKey:key];
  BOOL exists = [self.fileManager fileExistsAtPath:fullCachePath];
  if (exists) {
    NSData *imageData = [NSData dataWithContentsOfFile:fullCachePath];
    UIImage *image = [UIImage imageWithData:imageData];
    [self.memoryCache setObject:image forKey:key];
    return image;
  }
  return nil;
}


- (NSString *)fullImageCachePathWithKey:(NSString *)cacheKey {
  NSString *MD5CacheKey = [cacheKey MD5String];
  NSString *imagePath = [self.folderCachePath stringByAppendingPathComponent:MD5CacheKey];
  return imagePath;
}

#pragma mark  getter
- (AutoPurgeCache *)memoryCache {
  if (!_memoryCache) {
    _memoryCache = [[AutoPurgeCache alloc] init];
  }
  return _memoryCache;
}

- (NSString *)folderCachePath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *folderPath = [[paths firstObject] stringByAppendingPathComponent:@"Default"];
  return folderPath;
}

- (NSFileManager *)fileManager {
  if (!_fileManager) {
    _fileManager = [[NSFileManager alloc] init];
  }
  return _fileManager;
}

#pragma mark  setter
- (void)setMaxMemoryCacheNumber:(NSUInteger)maxMemoryCacheNumber {
    _maxMemoryCacheNumber = maxMemoryCacheNumber;
    self.memoryCache.countLimit = maxMemoryCacheNumber;
}

@end
