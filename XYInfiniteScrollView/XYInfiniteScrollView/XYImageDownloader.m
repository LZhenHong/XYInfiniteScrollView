//
//  XYImageDownloader.m
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/11/3.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import "XYImageDownloader.h"

@interface XYImageDownloader ()

@property (nonatomic, copy) NSString *lastURLKey;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation XYImageDownloader

+ (instancetype)sharedImageDownloader {
  static XYImageDownloader *imageDownloader = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    imageDownloader = [[self alloc] init];
  });
  return imageDownloader;
}

- (void)downloadImageWithURLString:(NSString *)urlString completion:(XYImageDownloaderCompletion)completion {
  
//  NSAssert(urlString != nil, @"Invalid URL String!");
  
  NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        !completion ? : completion(nil, error);
      });
    } else {
      UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
      dispatch_async(dispatch_get_main_queue(), ^{
        !completion ? : completion(image, nil);
      });
    }
  }];
  
  [downloadTask resume];
}

- (NSURLSession *)session {
  
  if (!_session) {
    _session = [NSURLSession sharedSession];
  }
  
  return _session;
}

@end
