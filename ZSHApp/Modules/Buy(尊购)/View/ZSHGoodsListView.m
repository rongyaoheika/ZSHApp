//
//  ZSHGoodsListView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsListView.h"

@interface ZSHGoodsListView()

@property (nonatomic, strong)  NSDictionary     *paramDic;
@property (nonatomic, strong)  UIView           *containImageView;
@property (nonatomic, strong)  UIImageView      *goodsImageView;
@property (nonatomic, strong)  UIView           *detailView;
@property (nonatomic, strong)  UILabel          *nameLabel;
@property (nonatomic, strong)  UIButton         *enterBtn;

@end

@implementation ZSHGoodsListView

- (void)setup{
    //左侧
    _containImageView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_containImageView];

    _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_containImageView addSubview:_goodsImageView];

    //右侧
     _detailView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, self.frame.size.height)];
    [self addSubview:_detailView];

    NSDictionary *nameLabelDic = @{@"text":@"手表专区",@"font":kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
     _nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [_detailView addSubview:_nameLabel];

    NSDictionary *enterBtnParamDic = @{@"title":@"ENTER",@"titleColor":KZSHColor929292,@"font":kPingFangLight(12),@"backgroundColor":KClearColor};
    _enterBtn = [ZSHBaseUIControl createBtnWithParamDic:enterBtnParamDic];
     [ZSHSpeedy zsh_chageControlCircularWith:_enterBtn AndSetCornerRadius:0 SetBorderWidth:0.5 SetBorderColor:KZSHColor979797 canMasksToBounds:YES];
    [_detailView addSubview:_enterBtn];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    //偶数--左侧图片，右边文字
    //奇数--左边文字，右边图片
    [_containImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containImageView);
        make.centerY.mas_equalTo(_containImageView);
        make.width.mas_equalTo(KScreenWidth/2);
        make.height.mas_equalTo(_containImageView);
    }];
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kScreenWidth/2);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_detailView);
        make.width.mas_equalTo(kRealValue(70));
        make.height.mas_equalTo(kRealValue(15));
        make.top.mas_equalTo(_detailView).offset(kRealValue(47));
    }];
    
    [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(kRealValue(14));
        make.width.mas_equalTo(kRealValue(84));
        make.height.mas_equalTo(kRealValue(20));
    }];
    
    if ([self.paramDic[@"row"]integerValue]%2) {//奇数
        [_containImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kScreenWidth/2);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(self);
            make.top.mas_equalTo(self);
        }];
        
        [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(self);
            make.top.mas_equalTo(self);
        }];
    }
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    self.paramDic = dic;
    UIImage *image =  [UIImage imageNamed:dic[@"goodsImageName"]];
    _goodsImageView.image = image;
    _nameLabel.text = dic[@"goodsName"];
    
    [_goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containImageView);
        make.centerY.mas_equalTo(_containImageView);
        make.size.mas_equalTo(image.size);
    }];
    
//    if ([dic[@"row"]integerValue]%2) {//奇数
//        [_containImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self).offset(kScreenWidth/2);
//            make.width.mas_equalTo(kScreenWidth/2);
//            make.height.mas_equalTo(self);
//            make.top.mas_equalTo(self);
//        }];
//        
//        [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self);
//            make.width.mas_equalTo(kScreenWidth/2);
//            make.height.mas_equalTo(self);
//            make.top.mas_equalTo(self);
//        }];
//    }
    
}

@end
