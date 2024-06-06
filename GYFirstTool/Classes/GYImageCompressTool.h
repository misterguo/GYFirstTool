//
//  GYImageCompressTool.h
//
//  Created by   on 2023/8/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GYImageCompressTool : NSObject

+ (NSData *)CompressImage:(UIImage *)tfimage imageKB:(CGFloat)tfImageKB;
+ (UIImage *)sortSizeWithImage:(UIImage *)image;
+ (BOOL)ImageIsBigWithImage:(UIImage *)image;

@end

