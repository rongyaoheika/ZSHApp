//
//  ZSHTogetherView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTogetherView.h"
#import "ZSHTogetherModel.h"
#import "ZSHPersonalModel.h"

@interface ZSHTogetherView()

@property (nonatomic, strong)UIImageView    *activityImage;
@property (nonatomic, strong)UILabel        *chineseNameLabel;
@property (nonatomic, strong)UILabel        *englishNameLabel;
@property (nonatomic, strong)UIButton       *moreBtn;
//@property (nonatomic, strong)NSDictionary   *paramDic; //父类中已经定义CGH

@end

@implementation ZSHTogetherView

- (void)setup {
    UIImageView *activityImage = [[UIImageView alloc]init];
    activityImage.layer.cornerRadius = 10.0;
    [self addSubview:activityImage];
    self.activityImage = activityImage;

    NSDictionary *chineseNameLabelDic = @{@"text":@"吃喝玩乐区",@"font":kPingFangRegular(15),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *chineseNameLabel = [ZSHBaseUIControl createLabelWithParamDic:chineseNameLabelDic];
    [self addSubview:chineseNameLabel];
    self.chineseNameLabel = chineseNameLabel;
    
    NSDictionary *englishNameLabelDic = @{@"text":@"Entertainment",@"font":kPingFangRegular(15),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *englishNameLabel = [ZSHBaseUIControl createLabelWithParamDic:englishNameLabelDic];
    [self addSubview:englishNameLabel];
    self.englishNameLabel = englishNameLabel;
    
    NSDictionary *moreBtnDic = @{@"title":@"查看更多",@"titleColor":KWhiteColor,@"font":kPingFangRegular(12)};
    UIButton *moreBtn = [ZSHBaseUIControl  createBtnWithParamDic:moreBtnDic target:self action:nil];
    moreBtn.layer.borderColor = KWhiteColor.CGColor;
    moreBtn.layer.borderWidth = 0.5;
    moreBtn.hidden = YES;
    [self addSubview:moreBtn];
    self.moreBtn = moreBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([self.paramDic[KFromClassType]integerValue] == ZSHFromTogetherVCToTogetherView) {
        self.moreBtn.hidden = YES;
        [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.height.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
        }];
        
        [self.chineseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.activityImage).offset(kRealValue(65));
            make.height.mas_equalTo(kRealValue(15));
            make.width.mas_equalTo(self);
        }];
        
        [self.englishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.chineseNameLabel.mas_bottom).offset(kRealValue(5));
            make.height.mas_equalTo(kRealValue(15));
            make.width.mas_equalTo(self);
        }];
    } else if ([self.paramDic[KFromClassType]integerValue] == ZSHFromPersonalTailorVCToTogetherView){
        
        [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.height.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(self);
        }];
        
        [self.chineseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.activityImage).offset(kRealValue(62.5));
            make.height.mas_equalTo(kRealValue(17));
            make.width.mas_equalTo(self);
        }];
        
        [self.englishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.chineseNameLabel.mas_bottom).offset(kRealValue(10));
            make.height.mas_equalTo(kRealValue(12));
            make.width.mas_equalTo(self);
        }];
        
        self.moreBtn.hidden = NO;
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.englishNameLabel.mas_bottom).offset(kRealValue(10));
            make.width.mas_equalTo(kRealValue(80));
            make.height.mas_equalTo(kRealValue(20));
            make.centerX.mas_equalTo(self);
        }];
    }
    
}

- (void)updateCellWithModel:(ZSHBaseModel *)model {
    
    if ([model isKindOfClass:[ZSHTogetherModel class]]) {
        ZSHTogetherModel *togetherModel = (ZSHTogetherModel *)model;
        [self.activityImage sd_setImageWithURL:[NSURL URLWithString:togetherModel.CONVERGEIMG]];
        self.chineseNameLabel.text = togetherModel.IMGCNCHAR;
        self.englishNameLabel.text = togetherModel.IMGENCHAR;
    } else if ([model isKindOfClass:[ZSHPersonalModel class]]) {
        ZSHPersonalModel *personalModel = (ZSHPersonalModel *)model;
        [self.activityImage sd_setImageWithURL:[NSURL URLWithString:personalModel.PERSONALIMGS]];
        self.chineseNameLabel.text = personalModel.IMGSCNCHAR;
        self.englishNameLabel.text = personalModel.IMGENCHAR;
    }
    
    [self layoutIfNeeded];
}


@end
