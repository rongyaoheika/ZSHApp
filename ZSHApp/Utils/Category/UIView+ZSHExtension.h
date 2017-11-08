//
//  UIView+zshExtension.h
//  CDDStoreDemo
//
//  Created by apple on 2017/3/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZSHExtension)


@property (nonatomic , assign) CGFloat zsh_width;
@property (nonatomic , assign) CGFloat zsh_height;
@property (nonatomic , assign) CGSize  zsh_size;
@property (nonatomic , assign) CGFloat zsh_x;
@property (nonatomic , assign) CGFloat zsh_y;
@property (nonatomic , assign) CGPoint zsh_origin;
@property (nonatomic , assign) CGFloat zsh_centerX;
@property (nonatomic , assign) CGFloat zsh_centerY;
@property (nonatomic , assign) CGFloat zsh_right;
@property (nonatomic , assign) CGFloat zsh_bottom;

- (BOOL)intersectWithView:(UIView *)view;

+ (instancetype)zsh_viewFromXib;
- (BOOL)isShowingOnKeyWindow;

@end
