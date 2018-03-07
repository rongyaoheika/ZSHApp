//
//  ZSHEntertainmentHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentHeadView.h"
#import "ZSHEntertainmentModel.h"
#import "ZSHTogetherLogic.h"

@interface ZSHEntertainmentHeadView()

@property (nonatomic, strong) UIImageView         *avatarImageView;
@property (nonatomic, strong) UIImageView         *genderImageView;
@property (nonatomic, strong) UILabel             *nameLabel;
@property (nonatomic, strong) UILabel             *detailLabel;
@property (nonatomic, strong) UIButton            *addFriendBtn;
@property (nonatomic, strong) ZSHTogetherLogic    *togetherLogic;
@property (nonatomic, copy)   NSString            *HONOURUSER_ID;

@end

@implementation ZSHEntertainmentHeadView

- (void)setup{
    
    _togetherLogic = [[ZSHTogetherLogic alloc] init];
    
    //头像
    self.avatarImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weibo_head_image"]];
    [self.avatarImageView setClipsToBounds:YES];
    self.avatarImageView.layer.cornerRadius = kRealValue(40)/2;
    [self addSubview:self.avatarImageView];
    
    //昵称
    NSDictionary *nameLabelDic = @{@"text":@"完成全部任务",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentLeft)};
    self.nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self addSubview:self.nameLabel];
    
    //性别
    self.genderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gender_male"]];
    [self.genderImageView setClipsToBounds:YES];
    self.genderImageView.layer.cornerRadius = kRealValue(10)/2;
    [self addSubview:self.genderImageView];
    
    //详细信息
    NSDictionary *dateLabelDic = @{@"text":@"1.7km 19岁摩羯座",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    self.detailLabel = [ZSHBaseUIControl createLabelWithParamDic:dateLabelDic];
    [self addSubview:self.detailLabel];
    
    //加好友
    NSDictionary *btnDic = @{@"title":@"加好友",@"font":kPingFangRegular(11)};
    _addFriendBtn = [ZSHBaseUIControl  createBtnWithParamDic:btnDic target:self action:@selector(addFriendAction)];
    _addFriendBtn.layer.cornerRadius = kRealValue(7.0);
    _addFriendBtn.layer.borderColor = KZSHColor929292.CGColor;
    _addFriendBtn.layer.borderWidth = 0.5;
    [self addSubview:_addFriendBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.centerY.mas_equalTo(self);
        make.width.and.height.mas_equalTo(kRealValue(40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(14));
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(kRealValue(10));
        make.height.mas_equalTo(kRealValue(14));

    }];
    
    [self.genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.centerY.mas_equalTo(self.nameLabel);
        make.width.and.height.mas_equalTo(kRealValue(10));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kRealValue(6));
        make.left.mas_equalTo(self.nameLabel);
        make.height.mas_equalTo(kRealValue(11));
        make.right.mas_equalTo(self).offset(-kRealValue(80));
    }];
    
    [self.addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(14));
        make.width.mas_equalTo(kRealValue(44));
    }];
}

- (void)setModel:(ZSHEntertainmentModel *)model{
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.PORTRAIT]];
    _nameLabel.text = model.NICKNAME;
    if ([model.SEX isEqualToString:@"男"]) {
        _genderImageView.image = [UIImage imageNamed:@"gender_male"];
    } else {
        _genderImageView.image = [UIImage imageNamed:@"gender_female"];
    }
    
    _HONOURUSER_ID = model.HONOURUSER_ID;
    _detailLabel.text = [NSString stringWithFormat:@"%@km %@岁",model.distance, model.age];
}

- (void)addFriendAction {
    [_togetherLogic requestAddFriendWithReHonouruserID:_HONOURUSER_ID success:^(id response) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:cancelAction];
        [[kAppDelegate getCurrentUIVC].navigationController presentViewController:ac animated:YES completion:nil];
    }];
}


@end
