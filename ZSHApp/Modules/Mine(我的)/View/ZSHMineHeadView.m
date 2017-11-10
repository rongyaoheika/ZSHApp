//
//  ZSHMineHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMineHeadView.h"
#import "ZSHServiceCenterViewController.h"
#import "ZSHEnergyValueViewController.h"

@interface ZSHMineHeadView()

@property (nonatomic, strong) NSArray           *pushVCsArr;
@property (nonatomic, strong) NSArray           *paramArr;
@property (nonatomic, strong) UIImageView       *headImageView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UIButton          *friendBtn;
@property (nonatomic, strong) UIButton          *coinBtn;
@property (nonatomic, strong) UIButton          *energyBtn;

@end

@implementation ZSHMineHeadView

- (void)setup{
    self.pushVCsArr = @[@"ZSHServiceCenterViewController",@"ZSHEnergyValueViewController",@"ZSHEnergyValueViewController"];
    self.paramArr = @[@{@"fromClassType":@(ZSHFromMineFriendVCToServiceCenterVC),@"title":@"好友"},@{},@{}];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weibo_head_image"]];
    headImageView.layer.cornerRadius = kRealValue(50)/2;
    headImageView.clipsToBounds = YES;
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(5));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(50)));
    }];
    self.headImageView = headImageView;
    
    NSDictionary *nameLabelDic = @{@"text":@"刘志坚",@"font":kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom).offset(kRealValue(10));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(14));
    }];
    self.nameLabel = nameLabel;
    
    //黑咖币
    NSDictionary *coinBtnTopDic = @{@"text":@"黑咖币",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    NSDictionary *coinBtnBottomDic = @{@"text":@"99",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    _coinBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:coinBtnTopDic bottomDic:coinBtnBottomDic];
    _coinBtn.tag = 2;
    [_coinBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_coinBtn];
    [_coinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(kRealValue(20));
        make.width.mas_equalTo(KScreenWidth/3);
        make.height.mas_equalTo(kRealValue(kRealValue(40)));
    }];
    
    //好友
    NSDictionary *friendBtnTopDic = @{@"text":@"好友",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    NSDictionary *friendBtnBottomDic = @{@"text":@"99",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    _friendBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:friendBtnTopDic bottomDic:friendBtnBottomDic];
    _friendBtn.tag = 1;
    [_friendBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_friendBtn];
    [_friendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.coinBtn);
        make.width.mas_equalTo(self.coinBtn);
        make.height.mas_equalTo(self.coinBtn);
    }];
    
    //能量值
    NSDictionary *energyBtnTopDic = @{@"text":@"能量值",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    NSDictionary *energyBtnBottomDic = @{@"text":@"99",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    _energyBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:energyBtnTopDic bottomDic:energyBtnBottomDic];
    _energyBtn.tag = 3;
    [_energyBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_energyBtn];
    [_energyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.coinBtn);
        make.width.mas_equalTo(self.coinBtn);
        make.height.mas_equalTo(self.coinBtn);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)btnAction:(UIButton *)btn{
        Class className = NSClassFromString(self.pushVCsArr[btn.tag - 1]);
        RootViewController *vc = [[className alloc]initWithParamDic:self.paramArr[btn.tag - 1]];
        [[kAppDelegate getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

@end
