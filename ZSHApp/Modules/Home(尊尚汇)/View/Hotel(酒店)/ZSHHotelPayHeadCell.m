//
//  ZSHHotelPayHeadCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelPayHeadCell.h"
#import "ZSHKTVModel.h"

@interface ZSHHotelPayHeadCell()

@property (nonatomic, strong) UIImageView            *hotelmageView;
@property (nonatomic, strong) UILabel                *hotelNameLabel;
@property (nonatomic, strong) UILabel                *hotelTypeLabel;
@property (nonatomic, strong) UILabel                *sizeInfoLabel;
@property (nonatomic, strong) UILabel                *hotelLiveInfoLabel;
@property (nonatomic, strong) UILabel                *discountLabel;
@property (nonatomic, strong) UILabel                *priceLabel;

@property (nonatomic, copy)   NSString               *liveInfo; //中间居住信息（pop：8-8入住，8-9离开，共1天，payVC：豪华贵宾房）
@property (nonatomic, strong) NSDictionary           *deviceDic;
@property (nonatomic, strong) NSDictionary           *listDic;

@end

@implementation ZSHHotelPayHeadCell

- (void)setup{
    
    //酒店图片
    _hotelmageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_hotelmageView];
    
    //酒店名字
    NSDictionary *hotelNameLabelDic = @{@"text":@"三亚大中华希尔顿酒店",@"font": kPingFangMedium(17)};
    _hotelNameLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelNameLabelDic];
    _hotelNameLabel.numberOfLines = 0;
    [_hotelNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_hotelNameLabel];
    
    //酒店型号名字
    NSDictionary *hotelTypeLabelDic = @{@"text":@"豪华贵宾房",@"font": kPingFangRegular(11)};
    _hotelTypeLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelTypeLabelDic];
    [self.contentView addSubview:_hotelTypeLabel];
    
    //酒店底部（距离，型号，大小）
    NSDictionary *liveInfoLabelDic = @{@"text":@"60㎡   大床  1.8m",@"font": kPingFangRegular(11)};
    _sizeInfoLabel = [ZSHBaseUIControl createLabelWithParamDic:liveInfoLabelDic];
    _sizeInfoLabel.numberOfLines = 0;
    [_sizeInfoLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_sizeInfoLabel];
    
    //酒店底部（入住信息）
    NSDictionary *hotelLiveInfoLabelDic = @{@"text":@"6月8日入住，6月9日离开，1天",@"font": kPingFangRegular(11)};
    _hotelLiveInfoLabel = [ZSHBaseUIControl createLabelWithParamDic:hotelLiveInfoLabelDic];
    _hotelLiveInfoLabel.numberOfLines = 0;
    [_hotelLiveInfoLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.contentView addSubview:_hotelLiveInfoLabel];
    
    //酒店价格
    NSDictionary *priceLabelDic = @{@"text":@"¥999",@"font": kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentRight)};
    _priceLabel = [ZSHBaseUIControl createLabelWithParamDic:priceLabelDic];
    [self.contentView addSubview:_priceLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_showCellType == ZSHNormalType){//订单支付页面
        [_hotelmageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin);
            make.top.mas_equalTo(self).offset(kRealValue(20));
            make.size.mas_equalTo(CGSizeMake(kRealValue(90), kRealValue(110)));
        }];
        
        [_hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hotelmageView.mas_right).offset(KLeftMargin);
            make.right.mas_equalTo(self).offset(-KLeftMargin);
            make.top.mas_equalTo(_hotelmageView).offset(kRealValue(15));
            make.height.mas_equalTo(kRealValue(18));
        }];
        
        [_hotelTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hotelNameLabel);
            make.right.mas_equalTo(_hotelNameLabel);
            make.top.mas_equalTo(_hotelNameLabel.mas_bottom).offset(kRealValue(18));
            make.height.mas_equalTo(kRealValue(11));
        }];
        
        [_hotelLiveInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hotelTypeLabel.mas_bottom).offset(kRealValue(18));
            make.left.mas_equalTo(_hotelNameLabel);
            make.right.mas_equalTo(_hotelNameLabel);
            make.height.mas_equalTo(kRealValue(11));
        }];
    } else {//底部弹窗
        [_hotelmageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(KLeftMargin);
            make.top.mas_equalTo(self).offset(kRealValue(10));
            make.size.mas_equalTo(CGSizeMake(kRealValue(55), kRealValue(55)));
        }];
        
        [_hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hotelmageView.mas_right).offset(kRealValue(10));
            make.right.mas_equalTo(self).offset(-KLeftMargin);
            make.top.mas_equalTo(_hotelmageView);
            make.height.mas_equalTo(kRealValue(15));
        }];
        
        [_hotelLiveInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hotelNameLabel.mas_bottom).offset(kRealValue(7));
            make.left.mas_equalTo(_hotelNameLabel);
            make.right.mas_equalTo(_hotelNameLabel);
            make.height.mas_equalTo(kRealValue(11));
        }];
        
        [_sizeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hotelLiveInfoLabel.mas_bottom).offset(kRealValue(7));
            make.left.and.right.mas_equalTo(_hotelNameLabel);
            make.height.mas_equalTo(kRealValue(11));
        }];
        
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self).offset(-KLeftMargin);
            make.height.mas_equalTo(kRealValue(17));
            make.width.mas_equalTo(kRealValue(50));
        }];
    }
}

- (void)setShopType:(ZSHShopType)shopType{
    _shopType = shopType;
    [self layoutIfNeeded];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
    self.deviceDic = dic[@"deviceDic"];  //详情页上半部分数据
    self.listDic = dic[@"listDic"];      //详情页下半部分列表数据
    self.liveInfo = dic[@"liveInfoStr"]; //酒店居住时间信息
    
    switch (_shopType) {
        case ZSHHotelShopType:{//酒店
            [_hotelmageView sd_setImageWithURL:[NSURL URLWithString:self.listDic[@"HOTELDETIMGS"]]];
            _hotelLiveInfoLabel.text = self.liveInfo;
           
            if (_showCellType == ZSHNormalType) {//订单支付页面
                _hotelNameLabel.text = self.deviceDic[@"HOTELNAMES"];
                _hotelTypeLabel.text = self.listDic[@"HOTELDETNAME"];
              
            } else if (_showCellType == ZSHPopType){
                _hotelNameLabel.text = self.listDic[@"HOTELDETNAME"];
                _sizeInfoLabel.text = [NSString stringWithFormat:@"%@㎡   %@", self.listDic[@"HOTELDETROOMSIZE"], self.listDic[@"HOTELDETBEDTYPE"] ];
                _priceLabel.text = [NSString stringWithFormat:@"¥%.0f",[self.listDic[@"HOTELDETPRICE"]floatValue] ];
            }
            
             break;
        }
        case ZSHFoodShopType:{//美食
            [_hotelmageView sd_setImageWithURL:[NSURL URLWithString:self.listDic[@"FOODDETIMGS"]]];
            _hotelLiveInfoLabel.text = self.listDic[@"FOODDETREMARK"];
            if (_showCellType == ZSHNormalType) {//订单支付页面
                _hotelNameLabel.text = self.deviceDic[@"SHOPNAMES"];
                _hotelTypeLabel.text = self.listDic[@"FOODDETNAME"];
        
            } else if (_showCellType == ZSHPopType){
                _hotelNameLabel.text = self.listDic[@"FOODDETNAME"];
                _sizeInfoLabel.text = @"会员专享价";
                _priceLabel.text = [NSString stringWithFormat:@"¥%.0f",[self.listDic[@"FOODDETPRICE"]floatValue] ];
            }
            
            break;
        }
            
        case ZSHBarShopType:{//酒吧
            [_hotelmageView sd_setImageWithURL:[NSURL URLWithString:self.listDic[@"BARDETIMG"]]];
            
            if (_showCellType == ZSHNormalType) {//订单支付页面
                _hotelNameLabel.text = self.deviceDic[@"BARNAMES"];
                _hotelTypeLabel.text = self.listDic[@"BARDETTITLE"];
                _hotelLiveInfoLabel.text = [NSString stringWithFormat:@"%@-%@",self.listDic[@"BARDETBEGIN"],self.listDic[@"BARDETEND"]];;
                
            } else if (_showCellType == ZSHPopType){
                _hotelNameLabel.text = self.listDic[@"BARDETTITLE"];
                _sizeInfoLabel.text = [NSString stringWithFormat:@"%@-%@",self.listDic[@"BARDETBEGIN"],self.listDic[@"BARDETEND"]];
                _priceLabel.text = [NSString stringWithFormat:@"¥%.0f",[self.listDic[@"BARDETPRICE"]floatValue] ];
                _hotelLiveInfoLabel.text = @"";
            }
            break;
        }
            
        case ZSHKTVShopType:{//KTV
            [_hotelmageView sd_setImageWithURL:[NSURL URLWithString:self.listDic[@"KTVDETIMG"]]];
            
            if (_showCellType == ZSHNormalType) {//订单支付页面
                _hotelNameLabel.text = self.deviceDic[@"KTVNAMES"];
                _hotelTypeLabel.text = self.listDic[@"KTVDETTYPE"];
                _hotelLiveInfoLabel.text = [NSString stringWithFormat:@"%@-%@",self.listDic[@"KTVDETBEGIN"],self.listDic[@"KTVDETEND"]];;
            } else if (_showCellType == ZSHPopType) {
                _hotelNameLabel.text = self.listDic[@"KTVDETTITLE"];
                _hotelLiveInfoLabel.text = self.listDic[@"KTVDETTYPE"];
                _sizeInfoLabel.text = [NSString stringWithFormat:@"%@-%@",self.listDic[@"KTVDETBEGIN"],self.listDic[@"KTVDETEND"]];
                _priceLabel.text = [NSString stringWithFormat:@"¥%.0f",[self.listDic[@"KTVDETPRICE"]floatValue] ];
            }
            break;
        }
            
        default:
            break;
    }
}

@end
