//
//  ZSHBaseFunction.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSHBaseFunction : NSObject

/**
 * MD5 字符串
 */
+ (NSString *)md5StringFromString:(NSString *)string;
+ (NSString *)getFKEYWithCommand:(NSString *)cmd;
+ (void)showPopView:(UIView *)customView frameY:(CGFloat)frameY;
+ (void)dismissPopView:(UIView *)customView block:(void(^)())completion;

@end
