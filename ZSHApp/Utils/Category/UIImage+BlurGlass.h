//
//  UIImage+BlurGlass.h
//  VoteWhere
//
//  Created by WJ02047 mini on 14-12-9.
//  Copyright (c) 2014年 Touna Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurGlass)

/**
 * @param alpha  透明度 0~1
 * @param radius  半径 值越大越模糊，值越小越清楚
 * @param saturation  色彩饱和度因子，0：黑白灰，9：浓彩色，1：原色，默认1.8
 * 将无彩色的黑白灰定为0，最鲜艳定为9，这样大致分成十阶段，让数值和人的感官直觉一致
 * @return UIImage 毛玻璃图片
 */
-(UIImage*) blurWithAlpha:(CGFloat)alpha radius:(CGFloat)radius saturation:(CGFloat)saturation;
+(UIImage*) imageWithColor:(UIColor*)color AndSize:(CGSize)size;

@end