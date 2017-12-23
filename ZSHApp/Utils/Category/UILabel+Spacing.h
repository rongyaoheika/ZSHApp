//
//  UILabel+Spacing.h
//  ZSHApp
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Spacing)

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;
/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;

@end
