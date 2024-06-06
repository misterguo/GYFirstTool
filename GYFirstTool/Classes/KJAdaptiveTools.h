//
//  KJAdaptiveTools.h
//  Winpower
//
//  Created by on 2019/9/29.
//  Copyright © 2019 cq. All rights reserved.
//
/*
 - (void)awakeFromNib{
 [super awakeFromNib];
 /// xib
 [KJAdaptiveTools viewLayoutWithXib:self];
 }
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface KJAdaptiveTools : NSObject
#pragma mark - 
+ (void)kj_adaptiveViewLayoutWithViewXib:(UIView*)xibView;
@end


