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
//手机号判断
+ (BOOL) validateMobile:(NSString *)mobile;
//身份证号判断
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//键盘设置
+ (void)initKeyboard;
//获取当地时间
+ (NSString *)getCurrentTime;
//将字符串转成NSDate类型
+ (NSDate *)dateFromString:(NSString *)dateString;
//传入今天的时间，返回明天的时间
+ (NSString *)GetTomorrowDay:(NSDate *)aDate;
//计算日期间隔天数
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

@end
