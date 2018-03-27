//
//  ZSHShareView.m
//  ZSHApp
//
//  Created by apple on 2017/11/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHShareView.h"
#import "ShareManager.h"
@implementation ZSHShareView

- (void)setup{
    CGFloat btnW = CGRectGetWidth(self.frame)/4.0;
    CGFloat btnH = CGRectGetHeight(self.frame)/2.0;
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArr = @[@"微信朋友圈", @"微信好友", @"QQ好友", @"QQ空间", @"新浪微博", @"复制链接"];
    
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
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.tag = i+1;
        [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(i%4*btnW);
            make.top.mas_equalTo(self).offset(i/4*btnH);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
    }
}

- (void)shareBtnAction:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter]postNotificationName:KShareInfo object:@{@"btn":btn}];
    
    
}


@end
