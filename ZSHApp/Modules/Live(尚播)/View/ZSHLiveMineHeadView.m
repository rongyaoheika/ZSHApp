//
//  ZSHLiveMineHeadView.m
//  ZSHApp
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveMineHeadView.h"
#import "ZSHFollowViewController.h"

@interface ZSHLiveMineHeadView()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIButton    *followBtn;
@property (nonatomic, strong) UIButton    *coinBtn;
@property (nonatomic, strong) UIButton    *followerBtn;

@property (nonatomic, strong) NSArray     *pushVCsArr;
@property (nonatomic, strong) NSArray     *paramArr;

@end

@implementation ZSHLiveMineHeadView

- (void)setup{
    self.pushVCsArr = @[@"ZSHFollowViewController",
                        @"ZSHCoinViewController",
                        @"ZSHFollowViewController"];
    self.paramArr = @[
                      @{KFromClassType:@(FromHorseVCToFollowVC),@"title":@"关注", @"follow":@"0"},
                      @{},
                      @{KFromClassType:@(FromShipVCToFollowVC),@"title":@"粉丝", @"follow":@"1"}];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.layer.cornerRadius = kRealValue(50)/2;
    headImageView.clipsToBounds = YES;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:curUser.PORTRAIT]];
    [self addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(5));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(50)));
    }];
    self.headImageView = headImageView;
    
    NSDictionary *nameLabelDic = @{@"text":@"",@"font":kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    nameLabel.text = curUser.NICKNAME;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom).offset(kRealValue(10));
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(14));
    }];
    self.nameLabel = nameLabel;
    
    //黑卡币
    NSDictionary *coinBtnTopDic = @{@"text":@"黑卡币",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
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
    
    
    //关注
    NSDictionary *followBtnTopDic = @{@"text":@"关注",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    NSDictionary *followBtnBottomDic = @{@"text":@"99",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    _followBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:followBtnTopDic bottomDic:followBtnBottomDic];
    _followBtn.tag = 1;
    [_followBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followBtn];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self.coinBtn);
        make.width.mas_equalTo(self.coinBtn);
        make.height.mas_equalTo(self.coinBtn);
    }];
    
    //粉丝
    NSDictionary *followerBtnTopDic = @{@"text":@"粉丝",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    NSDictionary *followerBtnBottomDic = @{@"text":@"99",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(14)};
    _followerBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:followerBtnTopDic bottomDic:followerBtnBottomDic];
    _followerBtn.tag = 3;
    [_followerBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_followerBtn];
    [_followerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)updateViewWithParamDic:(NSDictionary *)paramDic{

    UILabel *followValueLB = [_followBtn viewWithTag:21];
    followValueLB.text = [paramDic[@"FOCUSCOUNT"]stringValue];
    
    UILabel *coinValueLB = [_coinBtn viewWithTag:21];
    coinValueLB.text = [paramDic[@"BLACKCOIN"]stringValue];
    
    UILabel *followerLB = [_followerBtn viewWithTag:21];
    followerLB.text = [paramDic[@"FANSCOUNT"]stringValue];
}

@end
