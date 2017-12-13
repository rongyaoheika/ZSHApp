//
//  ZSHFootPlayMusicView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFootPlayMusicView.h"

@implementation ZSHFootPlayMusicView

- (void)setup{
    
    self.backgroundColor = KZSHColor0B0B0B;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerViewClick:)]];
    
    UIImageView *authorIV = [[UIImageView alloc]init];
    authorIV.tag = 2;
    authorIV.image = [UIImage imageNamed:@"music_image_1"];
    [self addSubview:authorIV];
    [authorIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
    }];
    
    NSDictionary *songLabelDic = @{@"text":@"后来",@"font":kPingFangRegular(12)};
    UILabel *songLabel = [ZSHBaseUIControl createLabelWithParamDic:songLabelDic];
    songLabel.tag = 3;
    [self addSubview:songLabel];
    [songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(authorIV.mas_right).offset(kRealValue(10));
        make.height.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(100));
    }];
    
    UIButton *startBtn = [[UIButton alloc]init];
    startBtn.tag = 4;
    [startBtn setBackgroundImage:[UIImage imageNamed:@"music_stop"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"music_start"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(25)));
    }];
    
    UISlider *slider = [[UISlider alloc]init];
    slider.tag = 5;
    slider.value = 0.0f;
    slider.minimumTrackTintColor = KZSHColorA61CE7;
    slider.maximumTrackTintColor = KClearColor;
    CGSize s=CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(s, 0, [UIScreen mainScreen].scale);
    UIRectFill(CGRectMake(0, 0, 1, 1));
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [slider setThumbImage:img forState:UIControlStateNormal];
    [self addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(2);
    }];
}

- (void)footerViewClick:(UITapGestureRecognizer*)gesture{
    if (self.footerViewAction) {
        self.footerViewAction();
    }
}

- (void)playBtnAction:(UIButton *)playBtn{
    if (self.btnClickBlock) {
        self.btnClickBlock(playBtn);
    }
}

@end
