//
//  ZSHLivePersonInfoView.m
//  ZSHApp
//
//  Created by apple on 2017/11/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLivePersonInfoView.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHPersonalCenterViewController.h"

@implementation ZSHLivePersonInfoView

- (void)setup {
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
}


- (void)drawRect:(CGRect)rect {
    
    //
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_image_2"]];
    imageView.tag= 10;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
   
    
    NSDictionary *headTapBtnDic = @{@"backgroundColor":KClearColor};
    UIButton *headTapBtn = [ZSHBaseUIControl createBtnWithParamDic:headTapBtnDic];
    [headTapBtn addTarget:self action:@selector(headTapBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headTapBtn];
    [headTapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(260), kRealValue(183)));
    }];
    
    //
    NSDictionary *followNumLabelDic = @{@"text":@"36",@"font":kPingFangRegular(20),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *followNumLabel = [ZSHBaseUIControl createLabelWithParamDic:followNumLabelDic];
     ;
    [self addSubview:followNumLabel];
    [followNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(195.5));
        make.left.mas_equalTo(self).offset(kRealValue(42));
        make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(29)));
    }];
    
    //
    NSDictionary *followLabelDic = @{@"text":@"关注",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *followLabel = [ZSHBaseUIControl createLabelWithParamDic:followLabelDic];
    [self addSubview:followLabel];
    [followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(followNumLabel);
        make.centerY.mas_equalTo(followNumLabel).offset(23);
        make.size.mas_equalTo(CGSizeMake(kRealValue(23), kRealValue(12)));
    }];
    
    //
    NSDictionary *followerNumLabelDic = @{@"text":@"7690",@"font":kPingFangRegular(20),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *followerNumLabel = [ZSHBaseUIControl createLabelWithParamDic:followerNumLabelDic];
    [self addSubview:followerNumLabel];
    [followerNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(followNumLabel);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(80), kRealValue(29)));
    }];
    
    //
    NSDictionary *followerLabelDic = @{@"text":@"粉丝",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *followerLabel = [ZSHBaseUIControl createLabelWithParamDic:followerLabelDic];
    [self addSubview:followerLabel];
    [followerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(followLabel);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(23), kRealValue(12)));
    }];
    
    //
    NSDictionary *recentNumLabelDic = @{@"text":@"52",@"font":kPingFangRegular(20),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *recentNumLabel = [ZSHBaseUIControl createLabelWithParamDic:recentNumLabelDic];
    [self addSubview:recentNumLabel];
    [recentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(followerNumLabel);
        make.right.mas_equalTo(self).offset(-kRealValue(42));
        make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(28)));
    }];
    
    
    //
    NSDictionary *recentLabelDic = @{@"text":@"动态",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *recentLabel = [ZSHBaseUIControl createLabelWithParamDic:recentLabelDic];
    [self addSubview:recentLabel];
    [recentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(followerLabel);
        make.centerX.mas_equalTo(recentNumLabel);
        make.size.mas_equalTo(CGSizeMake(kRealValue(23), kRealValue(12)));
    }];
    
    
    //
    NSDictionary *addFriendBtnDic = @{@"title":@"",@"titleColor":KZSHColorFF2068,@"font":kPingFangMedium(17),@"backgroundColor":KZSHColorFF2068};
    UIButton *addFriendBtn = [ZSHBaseUIControl createBtnWithParamDic:addFriendBtnDic];
    addFriendBtn.layer.cornerRadius = 15.0;
    addFriendBtn.layer.masksToBounds = true;
    [addFriendBtn setImage:[UIImage imageNamed:@"room_unfollow"] forState:UIControlStateNormal];
    [addFriendBtn setImage:[UIImage imageNamed:@"room_follow"] forState:UIControlStateSelected];
    [addFriendBtn addTarget:self action:@selector(addFriendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addFriendBtn];
    self.addFriendBtn = addFriendBtn;
    [addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(kRealValue(-20));
        make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(32)));
    }];
}

- (void)headTapBtnAction {
    [ZSHBaseUIControl setAnimationWithHidden:YES view:self.superview completedBlock:^{
        ZSHPersonalCenterViewController *vc = [[ZSHPersonalCenterViewController alloc] init];
        [[kAppDelegate getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }];
}


- (void)addFriendAction:(UIButton *)btn {
    
    kWeakSelf(self);
    if (_addFriendBtn.selected) {
        [_togetherLogic requestDelFriendWithReHonouruserID:@"382890302907613184" success:^(id response) {
            weakself.addFriendBtn.selected = false;
        }];
    } else {
        [_togetherLogic requestAddFriendWithReHonouruserID:@"382890302907613184" success:^(id response) {
            weakself.addFriendBtn.selected = true;
        }];
    }
    
}


@end
