//
//  ZSHBaseTableView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseTableView.h"

@implementation ZSHBaseTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    id view = [super hitTest:point withEvent:event];
    if (![view isKindOfClass:[UITextView class]]) {
        [self endEditing:YES];
    }
    
    return view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    RLog(@"点击空白");
}

@end
