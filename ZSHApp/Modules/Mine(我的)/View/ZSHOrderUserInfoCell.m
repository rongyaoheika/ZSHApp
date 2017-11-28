//
//  ZSHOrderUserInfoCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHOrderUserInfoCell.h"
#import "ZSHAddrModel.h"

@interface ZSHOrderUserInfoCell()

@property (nonatomic, strong) UIImageView    *locateImageView;
@property (nonatomic, strong) UILabel        *nameLabel;
@property (nonatomic, strong) UILabel        *phoneLabel;
@property (nonatomic, strong) UILabel        *addressLabel;

@end


@implementation ZSHOrderUserInfoCell

- (void)setup{
    _locateImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _locateImageView.image =[UIImage imageNamed:@"order_locate"];
    _locateImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_locateImageView];
    
    NSDictionary *nameLabelDic = @{@"text":@"",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.contentView addSubview:_nameLabel];
    
    NSDictionary *phoneLabelDic = @{@"text":@"",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _phoneLabel = [ZSHBaseUIControl createLabelWithParamDic:phoneLabelDic];
    [self.contentView addSubview:_phoneLabel];
    
    NSDictionary *addressDic = @{@"text":@"",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _addressLabel = [ZSHBaseUIControl createLabelWithParamDic:addressDic];
    [self.contentView addSubview:_addressLabel];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_locateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(20), kRealValue(20)));
        make.top.mas_equalTo(self).offset(kRealValue(12));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_locateImageView.mas_right).offset(kRealValue(10));
        make.width.mas_equalTo(kRealValue(60));
        make.top.mas_equalTo(self).offset(kRealValue(15));
        make.height.mas_equalTo(kRealValue(14));
    }];
    
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right);
        make.right.mas_equalTo(self).offset(-kRealValue(30));
        make.top.mas_equalTo(_nameLabel);
        make.height.mas_equalTo(_nameLabel);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.right.mas_equalTo(self).offset(-kRealValue(30));
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(kRealValue(12));
    }];
}

- (void)updateCellWithModel:(ZSHAddrModel *)model {
    _nameLabel.text = model.CONSIGNEE;
    _phoneLabel.text =  [model.ADRPHONE stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    _addressLabel.text = NSStringFormat(@"%@%@",model.PROVINCE,model.ADDRESS);
}

@end
