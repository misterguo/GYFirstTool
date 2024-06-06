//
//  GYImageCompressTool.m
//
//  Created by   on 2023/8/12.
//

#import "GYImageCompressTool.h"

static CGFloat imageMax = 2000;
static CGFloat imageMin = 120;

@implementation GYImageCompressTool

+ (NSData *)CompressImage:(UIImage *)tfimage imageKB:(CGFloat)tfImageKB {
    CGFloat compression = 1;
    CGSize imageSize = tfimage.size;
    NSLog(@"Image Size: %@", NSStringFromCGSize(imageSize));
    UIImage * smallImage;
    if ([self ImageIsBigWithImage: tfimage] == YES) {
        smallImage = [self sortSizeWithImage:tfimage];
    } else {
        smallImage = tfimage;
    }
    NSData *imageData = UIImageJPEGRepresentation(smallImage, compression);
    NSUInteger fImageBytes = tfImageKB * 1000;
    if (imageData.length <= fImageBytes){
        return imageData;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    
    compression = pow(2, -6);
    imageData = UIImageJPEGRepresentation(smallImage, compression);
    if (imageData.length < fImageBytes) {
        
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            imageData = UIImageJPEGRepresentation(smallImage, compression);
            
            if (imageData.length < fImageBytes * 0.9) {
                min = compression;
            } else if (imageData.length > fImageBytes) {
                max = compression;
            } else {
                break;
            }
        }
        return imageData;
    }
  
    UIImage *resultImage = [UIImage imageWithData:imageData];
    while (imageData.length > fImageBytes) {
        @autoreleasepool {
            CGFloat ratio = (CGFloat)fImageBytes / imageData.length;
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            resultImage = [self createImageForData:imageData maxPixelSize:MAX(size.width, size.height)];
            imageData = UIImageJPEGRepresentation(resultImage, compression);
        }
    }
    return imageData;
}

+ (BOOL)ImageIsBigWithImage:(UIImage *)image {
    if (image.size.width > imageMax || image.size.height > imageMax) {
        return YES;
    } else {
        return NO;
    }
}

+ (UIImage *)sortSizeWithImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGSize resultSize;
    if (imageWidth > imageHeight) {
        CGFloat c = imageWidth/imageMax;
        resultSize = CGSizeMake(imageMax, imageHeight/c);
    } else {
        CGFloat c = imageHeight/imageMax;
        resultSize = CGSizeMake(imageWidth/c, imageMax);
    }
    UIGraphicsBeginImageContextWithOptions(resultSize, NO, 0);
    [image drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImage;
}

+ (UIImage *)createImageForData:(NSData *)data maxPixelSize:(NSUInteger)size {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(size),
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    if (!imageRef) {
        return nil;
    }
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return toReturn;
}


@end
