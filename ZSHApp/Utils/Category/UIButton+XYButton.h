//
//  UIButton+XYButton.h
//  MiAiApp
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, XYButtonEdgeInsetsStyle) {
    XYButtonEdgeInsetsStyleTop,     // image在上，label在下
    XYButtonEdgeInsetsStyleLeft,    // image在左，label在右
    XYButtonEdgeInsetsStyleBottom,  // image在下，label在上
    XYButtonEdgeInsetsStyleRight    // image在右，label在左
};

@interface UIButton (XYButton)

@property(nonatomic ,copy)void(^block)(UIButton*);

-(void)addTapBlock:(void(^)(UIButton*btn))block;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(XYButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
