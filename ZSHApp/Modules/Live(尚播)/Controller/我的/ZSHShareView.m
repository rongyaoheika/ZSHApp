//
//  ZSHShareView.m
//  ZSHApp
//
//  Created by apple on 2017/11/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHShareView.h"

@implementation ZSHShareView

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArr = @[@"微信朋友去", @"微信好友", @"QQ好友", @"QQ空间", @"新浪微博", @"复制链接"];
    
    for (int i = 0; i <  titleArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_image_%d",i+1]]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(kRealValue(20 + i/4*81));
            make.left.mas_equalTo(self).offset(kRealValue(37.5 + i%4*85));
        }];
        
        UILabel *label = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":titleArr[i],@"font":kPingFangRegular(12),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)}];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(kRealValue(69 + i/4*81));
            make.centerX.mas_equalTo(imageView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(70), kRealValue(17)));
        }];
    }
}

@end
