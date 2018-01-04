//
//  UIImage+String.m
//  ZSHApp
//
//  Created by mac on 29/12/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "UIImage+String.h"

@implementation UIImage (String)
//把文字绘制到图片上
+ (UIImage *)imageToAddText:(UIImage *)img withText:(NSString *)text
{
    //1.获取上下文
    UIGraphicsBeginImageContext(img.size);
    //2.绘制图片
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //3.绘制文字
    CGRect rect = CGRectMake(0,(img.size.height-30)/2-2, img.size.width, img.size.height);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:30],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor whiteColor]};
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    //4.获取绘制到得图片
    UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    
    return watermarkImg;
}

+ (UIImage *)getImage:(NSString *)name
{
    UIColor *color = [UIColor orangeColor];  //获取颜色
    CGRect rect = CGRectMake(0.0f, 0.0f, 60, 60);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *headerimg = [self imageToAddText:img withText:name];
    return headerimg;
}


@end
