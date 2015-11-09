//
//  XYImageDownloader.h
//  XYInfiniteScrollView
//
//  Created by LZhenHong on 15/11/3.
//  Copyright © 2015年 LZhenHong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XYImageDownloaderCompletion)(UIImage *image, NSError *error);

@interface XYImageDownloader : NSObject
+ (instancetype)sharedImageDownloader;

- (void)downloadImageWithURLString:(NSString *)urlString completion:(XYImageDownloaderCompletion)completion;
@end
