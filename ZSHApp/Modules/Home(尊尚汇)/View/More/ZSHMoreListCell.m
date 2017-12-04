//
//  ZSHMoreListCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMoreListCell.h"

@interface ZSHMoreListCell()

@property (nonatomic, strong) UIImageView               *leftImageView;
@property (nonatomic, strong) UILabel                   *nameLabel;
@property (nonatomic, strong) UILabel                   *addressLabel;
@property (nonatomic, strong) UILabel                   *distanceLabel;

@end

@implementation ZSHMoreListCell

- (void)setup{
    
    //图片
    _leftImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImageView];
    
    //名字
    NSDictionary *nameLabelDic = @{@"text":@"如家-北京霍营地铁站店",@"font": kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    _nameLabel.numberOfLines = 0;
    [_nameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_nameLabel];
    
    //地址
    NSDictionary *addressLabelDic = @{@"text":@"昌平区回龙观镇科星西路47号",@"font": kPingFangRegular(11)};
    _addressLabel = [ZSHBaseUIControl createLabelWithParamDic:addressLabelDic];
    _addressLabel.numberOfLines = 0;
    [self.contentView addSubview:_addressLabel];
    
    //距离
    NSDictionary *distanceLabelDic = @{@"text":@"23公里",@"font": kPingFangRegular(11),@"textAlignment":@(NSTextAlignmentLeft)};
    _distanceLabel = [ZSHBaseUIControl createLabelWithParamDic:distanceLabelDic];
    [self.contentView addSubview:_distanceLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(KLeftMargin);
        make.size.mas_equalTo(CGSizeMake(kRealValue(80), kRealValue(80)));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftImageView);
        make.left.mas_equalTo(_leftImageView.mas_right).offset(kRealValue(10));
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.height.mas_equalTo(kRealValue(14));
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(kRealValue(15));
        make.left.mas_equalTo(_nameLabel);
        make.right.mas_equalTo(self).offset(-kRealValue(80));
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_leftImageView);
        make.left.mas_equalTo(_nameLabel);
        make.height.mas_equalTo(_addressLabel);
        make.right.mas_equalTo(self).offset(-KLeftMargin);
    }];
    
    
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"SHOWIMAGES"]]];
    _distanceLabel.text = [NSString stringWithFormat:@"%.1f公里",[dic[@"distance"]floatValue] ];
    if (_shopType == ZSHHorseType) {//马术列表
        _nameLabel.text = dic[@"HORSENAMES"];
        _addressLabel.text = dic[@"HORSEADDRESS"];
    } else if (_shopType == ZSHShipType) {//游艇列表
        _nameLabel.text = dic[@"YACHTNAMES"];
        _addressLabel.text = dic[@"YACHTADDRESS"];
    }  else if (_shopType == ZSHGolfType) {//高尔夫列表
        _nameLabel.text = dic[@"GOLFNAMES"];
        _addressLabel.text = dic[@"GOLFADDRESS"];
    } else if (_shopType == ZSHLuxcarType) {//豪车
        _nameLabel.text = dic[@"LUXCARNAMES"];
        _addressLabel.text = dic[@"LUXCARADDRESS"];
    }
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    NSString *detailStr = _addressLabel.text;
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:detailStr];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailStr length])];
    [_addressLabel setAttributedText:setString];
}

@end
