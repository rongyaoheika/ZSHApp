//
//  ZSHHotelDetailDeviceCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHHotelDetailHeadCell.h"
#import "ZSHHotelDetailDeviceCell.h"
#import "ZSHFoodModel.h"
#import "ZSHHotelDetailModel.h"
#import "ZSHKTVModel.h"

@interface ZSHHotelDetailDeviceCell ()

@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) UIButton           *commentBtn;
@property (nonatomic, strong) NSMutableArray     *hotelBtnArr;
@property (nonatomic, strong) NSArray            *hotelDeviceArr;

@property (nonatomic, strong) NSMutableArray     *foodBtnArr;
@property (nonatomic, strong) NSArray            *foodDeviceArr;
@property (nonatomic, strong) NSMutableArray     *KTVBtnArr;
@property (nonatomic, strong) NSArray            *KTVDeviceArr;

@property (nonatomic, strong) NSMutableArray     *btnArr;

@end

@implementation ZSHHotelDetailDeviceCell

- (void)setup{
    _hotelBtnArr = [[NSMutableArray alloc]init];
    _foodBtnArr = [[NSMutableArray alloc]init];
    _KTVBtnArr = [[NSMutableArray alloc]init];
    _btnArr = [[NSMutableArray alloc]init];
    
    NSDictionary *titleLabelDic = @{@"text":@"配备最先进的有氧运动设备"};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:_titleLabel];
    
    NSDictionary *topDic = @{@"text":@"4.9",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    NSDictionary *bottomDic = @{@"text":@"好评",@"font":kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(11)};
    _commentBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:topDic bottomDic:bottomDic];
    [self.contentView addSubview:_commentBtn];
    
    _hotelDeviceArr = @[
                        @{@"imageName":@"hotel_wifi",@"titleName":@"WIFI"},
                        @{@"imageName":@"hotel_fork",@"titleName":@"餐饮"},
                        @{@"imageName":@"hotel_gym",@"titleName":@"健身"},
                        @{@"imageName":@"hotel_swimming",@"titleName":@"游泳"},
                        @{@"imageName":@"hotel_parking",@"titleName":@"停车"}
                        ];
    
    int i = 0;
    [_btnArr removeAllObjects];
    for (NSDictionary *dic in _hotelDeviceArr) {
        NSDictionary *hotelDeviceBtnDic = @{@"title":dic[@"titleName"],@"font":kPingFangRegular(11),@"tag":@(i+1),@"withImage":@(YES),@"normalImage":dic[@"imageName"]};
        UIButton *hotelDeviceBtn = [ZSHBaseUIControl createBtnWithParamDic:hotelDeviceBtnDic];
        [hotelDeviceBtn addTarget:self action:@selector(hotelDeviceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:hotelDeviceBtn];
        [_hotelBtnArr addObject:hotelDeviceBtn];
        i++;
    }
    
    _foodDeviceArr = @[
                       @{@"imageName":@"hotel_wifi",@"titleName":@"WIFI"},
                       @{@"imageName":@"food_pay",@"titleName":@"移动支付"},
                       @{@"imageName":@"hotel_parking",@"titleName":@"停车"},
                       ];
    int j = 0;
    for (NSDictionary *dic in _foodDeviceArr) {
        NSDictionary *foodDeviceBtnDic = @{@"title":dic[@"titleName"],@"font":kPingFangRegular(11),@"tag":@(j+10),@"withImage":@(YES),@"normalImage":dic[@"imageName"]};
        UIButton *foodDeviceBtn = [ZSHBaseUIControl createBtnWithParamDic:foodDeviceBtnDic];
        [foodDeviceBtn addTarget:self action:@selector(foodDeviceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foodDeviceBtn];
        [_foodBtnArr addObject:foodDeviceBtn];
        j++;
    }
    
    _KTVDeviceArr = @[
                       @{@"imageName":@"hotel_wifi",@"titleName":@"WIFI"},
                       @{@"imageName":@"hotel_parking",@"titleName":@"停车"},
                       ];
    int k = 0;
    for (NSDictionary *dic in _KTVDeviceArr) {
        NSDictionary *foodDeviceBtnDic = @{@"title":dic[@"titleName"],@"font":kPingFangRegular(11),@"tag":@(k+20),@"withImage":@(YES),@"normalImage":dic[@"imageName"]};
        UIButton *foodDeviceBtn = [ZSHBaseUIControl createBtnWithParamDic:foodDeviceBtnDic];
        [foodDeviceBtn addTarget:self action:@selector(foodDeviceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:foodDeviceBtn];
        [_KTVBtnArr addObject:foodDeviceBtn];
        k++;
    }
}

#pragma action

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self).offset(kRealValue(15));
        make.height.mas_equalTo(kRealValue(15));
        make.width.mas_equalTo(KScreenWidth*0.65);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kRealValue(22));
        make.top.mas_equalTo(_titleLabel);
        make.width.mas_equalTo(kRealValue(40));
        make.height.mas_equalTo(kRealValue(30));
    }];
    
    CGFloat btnWith = KScreenWidth/5;
    int i = 0;
    for (UIButton *deviceBtn in self.btnArr) {
        [deviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(i*btnWith);
            make.top.mas_equalTo(_commentBtn.mas_bottom).offset(kRealValue(13));
            make.width.mas_equalTo(btnWith);
            make.height.mas_equalTo(kRealValue(22));
        }];
        
        [deviceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, 0)];
        i++;
    }
}

#pragma action
- (void)setFromClassType:(ZSHFromVCToHotelDetailVC)fromClassType{
    [_btnArr removeAllObjects];
    _fromClassType = fromClassType;
    if (fromClassType == ZSHFromHotelVCToHotelDetailVC||fromClassType == ZSHFromHotelPayVCToHotelDetailVC) {
        _btnArr = _hotelBtnArr;
    } else if (fromClassType == ZSHFromFoodVCToHotelDetailVC) {
        _btnArr = _foodBtnArr;
    } else if (fromClassType == ZSHFromHomeKTVVCToHotelDetailVC) {
        _btnArr = _KTVBtnArr;
    }
    [self layoutIfNeeded];
}

- (void)updateCellWithModel:(ZSHBaseModel *)model{
    if (self.fromClassType == ZSHFromHotelPayVCToHotelDetailVC) {
        ZSHHotelDetailModel *hotelModel = (ZSHHotelDetailModel *)model;
        _titleLabel.text = hotelModel.hotelName;
    } else if (self.fromClassType == ZSHFromHomeKTVVCToHotelDetailVC) {
        ZSHKTVModel *KTVModel = (ZSHKTVModel *)model;
        _titleLabel.text = KTVModel.KTVName;
    }
}

- (void)hotelDeviceBtnAction:(UIButton *)hotelDevieBtn{
    
}

- (void)foodDeviceBtnAction:(UIButton *)foodDeviceBtn{
    
}

@end
