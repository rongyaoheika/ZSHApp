//
//  NSString+time.h
//  AudioPlayer
//
//  Created by ClaudeLi on 16/4/12.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (time)

// 播放器_时间转换
+ (NSString *)convertTime:(CGFloat)second;

/**
 *  获取格式化字符串所对应的秒数
 *
 *  @param formatTime 时间格式化字符串 00:00.89
 *
 *  @return 秒数
 */
+ (NSTimeInterval)getTimeInterval:(NSString *)formatTime;

@end
