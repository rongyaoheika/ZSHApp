//
//  ZSHNumberCount.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHNumberCount.h"

@interface ZSHNumberCount()

@property (nonatomic, strong)  UIImageView  *leftAddImageView;
@property (nonatomic, strong)  UILabel      *midLabel;
@property (nonatomic, strong)  UIImageView  *rightAddImageView;

@end
static CGFloat const Wd = 15;
@implementation ZSHNumberCount

- (void)setup{
    
    _leftAddImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"good_sub"]];
    [self addSubview:_leftAddImageView];
    _leftAddImageView.frame = CGRectMake(0, 0, Wd, Wd);
    
     NSDictionary *midLabelDic = @{@"text":@"1",@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    _midLabel = [ZSHBaseUIControl createLabelWithParamDic:midLabelDic];
    _midLabel.frame = CGRectMake(CGRectGetMaxX(_leftAddImageView.frame), 0, Wd*1.5, _leftAddImageView.frame.size.height);
    [self addSubview:_midLabel];
    
    _rightAddImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goods_add"]];
    _rightAddImageView.frame = CGRectMake(CGRectGetMaxX(_midLabel.frame), 0, Wd,Wd);
    [self addSubview:_rightAddImageView];
    
}


@end
