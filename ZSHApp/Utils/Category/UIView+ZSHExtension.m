//
//  UIView+zshExtension.m
//  CDDStoreDemo
//
//  Created by apple on 2017/3/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIView+ZSHExtension.h"

@implementation UIView (ZSHExtension)

- (CGFloat)zsh_x
{
    return self.frame.origin.x;
}
- (void)setZsh_x:(CGFloat)zsh_x
{
    CGRect zshFrame = self.frame;
    zshFrame.origin.x = zsh_x;
    self.frame = zshFrame;
}

-(CGFloat)zsh_y
{
    return self.frame.origin.y;
}
-(void)setZsh_y:(CGFloat)zsh_y
{
    CGRect zshFrame = self.frame;
    zshFrame.origin.y = zsh_y;
    self.frame = zshFrame;
}

-(CGPoint)zsh_origin
{
    return self.frame.origin;
}
-(void)setZsh_origin:(CGPoint)zsh_origin
{
    CGRect zshFrame = self.frame;
    zshFrame.origin = zsh_origin;
    self.frame = zshFrame;
}

-(CGFloat)zsh_width
{
    return self.frame.size.width;
}
-(void)setZsh_width:(CGFloat)zsh_width
{
    CGRect zshFrame = self.frame;
    zshFrame.size.width = zsh_width;
    self.frame = zshFrame;
}

-(CGFloat)zsh_height
{
    return self.frame.size.height;
}
-(void)setZsh_height:(CGFloat)zsh_height
{
    CGRect zshFrame = self.frame;
    zshFrame.size.height = zsh_height;
    self.frame = zshFrame;
}

-(CGSize)zsh_size
{
    return self.frame.size;
}
- (void)setZsh_size:(CGSize)zsh_size
{
    CGRect zshFrame = self.frame;
    zshFrame.size = zsh_size;
    self.frame = zshFrame;
}

-(CGFloat)zsh_centerX{
    
    return self.center.x;
}

-(void)setZsh_centerX:(CGFloat)zsh_centerX{
    
    CGPoint zshFrmae = self.center;
    zshFrmae.x = zsh_centerX;
    self.center = zshFrmae;
}

-(CGFloat)zsh_centerY{
    
    return self.center.y;
}

-(void)setZsh_centerY:(CGFloat)zsh_centerY{
    
    CGPoint zshFrame = self.center;
    zshFrame.y = zsh_centerY;
    self.center = zshFrame;
}

- (CGFloat)zsh_right{
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)zsh_bottom{
    
    return CGRectGetMaxY(self.frame);
}

- (void)setZsh_right:(CGFloat)zsh_right{
    
    self.zsh_x = zsh_right - self.zsh_width;
}

- (void)setZsh_bottom:(CGFloat)zsh_bottom{
    
    self.zsh_y = zsh_bottom - self.zsh_height;
}

- (BOOL)intersectWithView:(UIView *)view{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect selfRect = [self convertRect:self.bounds toView:window];
    CGRect viewRect = [view convertRect:view.bounds toView:window];
    return CGRectIntersectsRect(selfRect, viewRect);
}

- (BOOL)isShowingOnKeyWindow {
    // 主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 以主窗口左上角为坐标原点, 计算self的矩形框
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
    CGRect winBounds = keyWindow.bounds;
    
    // 主窗口的bounds 和 self的矩形框 是否有重叠
    BOOL intersects = CGRectIntersectsRect(newFrame, winBounds);
    
    return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && intersects;
}

+(instancetype)zsh_viewFromXib
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}



@end
