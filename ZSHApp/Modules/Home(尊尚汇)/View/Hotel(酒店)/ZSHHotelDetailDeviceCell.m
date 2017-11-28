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
#import "ZSHHotelModel.h"
#import "ZSHKTVModel.h"


@interface ZSHHotelDetailDeviceCell ()

@property (nonatomic, strong) UILabel            *titleLabel;
@property (nonatomic, strong) UIButton           *commentBtn;

@property (nonatomic, strong) NSMutableArray     *realBtnArr;

@property (nonatomic, strong) NSMutableArray     *allBtnArr;
@property (nonatomic, strong) NSArray            *deviceArr;

@property (nonatomic, strong) NSMutableArray     *foodBtnArr;
@property (nonatomic, strong) NSArray            *foodDeviceArr;
@property (nonatomic, strong) NSMutableArray     *KTVBtnArr;
@property (nonatomic, strong) NSArray            *KTVDeviceArr;

@property (nonatomic, strong) NSMutableArray     *btnArr;

@end

@implementation ZSHHotelDetailDeviceCell

- (void)setup{
    _realBtnArr = [[NSMutableArray alloc]init];
    _allBtnArr = [[NSMutableArray alloc]init];
    
    NSDictionary *titleLabelDic = @{@"text":@"配备最先进的有氧运动设备"};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:_titleLabel];
    
    NSDictionary *topDic = @{@"text":@"4.9",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    NSDictionary *bottomDic = @{@"text":@"好评",@"font":kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(11)};
    _commentBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:topDic bottomDic:bottomDic];
    [self.contentView addSubview:_commentBtn];
    
    _deviceArr = @[
                        @{@"imageName":@"hotel_wifi",@"titleName":@"WIFI"},
                        @{@"imageName":@"food_pay",@"titleName":@"移动支付"},
                        @{@"imageName":@"hotel_fork",@"titleName":@"餐饮"},
                        @{@"imageName":@"hotel_gym",@"titleName":@"健身"},
                        @{@"imageName":@"hotel_swimming",@"titleName":@"游泳"},
                        @{@"imageName":@"hotel_parking",@"titleName":@"停车"}
                        ];
    
    int i = 0;
    for (NSDictionary *dic in _deviceArr) {
        NSDictionary *hotelDeviceBtnDic = @{@"title":dic[@"titleName"],@"font":kPingFangRegular(11),@"tag":@(i+1),@"withImage":@(YES),@"normalImage":dic[@"imageName"]};
        UIButton *hotelDeviceBtn = [ZSHBaseUIControl createBtnWithParamDic:hotelDeviceBtnDic];
        hotelDeviceBtn.tag = i;
        [hotelDeviceBtn addTarget:self action:@selector(hotelDeviceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:hotelDeviceBtn];
        [_allBtnArr addObject:hotelDeviceBtn];
        i++;
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
    for (UIButton *deviceBtn in self.realBtnArr) {
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

- (void)updateCellWithModel:(id)model{
   if (self.fromClassType == ZSHFromFoodVCToHotelDetailVC) {
        ZSHFoodDetailModel *foodDetailModel = (ZSHFoodDetailModel *)model;
       //好评分数
       UILabel *topLabel = [_commentBtn viewWithTag:1];
       topLabel.text = [NSString stringWithFormat:@"%.1f",foodDetailModel.SHOPEVALUATE];
       
       
   } else if (self.fromClassType == ZSHFromHotelPayVCToHotelDetailVC) {
       ZSHHotelModel *hotelModel = (ZSHHotelModel *)model;
       _titleLabel.text = hotelModel.hotelName;

   } else if (self.fromClassType == ZSHFromHotelVCToHotelDetailVC) {// 酒店详情
       
       ZSHHotelDetailModel *hotelDetailModel = (ZSHHotelDetailModel *)model;
       UILabel *topLabel = [_commentBtn viewWithTag:1];
       topLabel.text = [NSString stringWithFormat:@"%.1f",hotelDetailModel.HOTELEVALUATE];
       [self createRealBtnArrWith:@{@"model":hotelDetailModel}];
       
       
    } else if (self.fromClassType == ZSHFromHomeKTVVCToHotelDetailVC) {
        ZSHKTVModel *KTVModel = (ZSHKTVModel *)model;
        _titleLabel.text = KTVModel.KTVName;
    }
    
    [self layoutIfNeeded];
}

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    //好评
    UILabel *topLabel = [_commentBtn viewWithTag:1];
    NSString *commentStr = @"4.9";
    if (self.fromClassType == ZSHFromFoodVCToHotelDetailVC) {//美食详情
        commentStr = [NSString stringWithFormat:@"%%@f",dic[@"SHOPEVALUATE"]];
        
    } else if (self.fromClassType == ZSHFromHotelPayVCToHotelDetailVC) {
        
        
    } else if (self.fromClassType == ZSHFromHotelVCToHotelDetailVC) {// 酒店详情
        
    } else if (self.fromClassType == ZSHFromHomeKTVVCToHotelDetailVC) {
    }
}

- (void)hotelDeviceBtnAction:(UIButton *)hotelDevieBtn{
    
}

- (void)foodDeviceBtnAction:(UIButton *)foodDeviceBtn{
    
}

- (void)createRealBtnArrWith:(id)model{
    
    if (self.fromClassType == ZSHFromHotelVCToHotelDetailVC) {
       ZSHHotelDetailModel *newModel = (ZSHHotelDetailModel *)model;
        newModel.SHOPSERVWIFI?[_realBtnArr addObject:_allBtnArr[0]]: 0;
        if (newModel.SHOPSERVWIFI) {//wifi
            [_realBtnArr addObject:_allBtnArr[0]];
        }
        
        if (newModel.SHOPSERVPAY) {//移动支付
            [_realBtnArr addObject:_allBtnArr[1]];
        }
        
        if (newModel.SHOPSERVFOOD) {//餐饮
            [_realBtnArr addObject:_allBtnArr[2]];
        }
        
        if (newModel.SHOPSERVFITNESS) {//健身
            [_realBtnArr addObject:_allBtnArr[3]];
        }
        
        if (newModel.SHOPSERVSWIM) {//游泳
            [_realBtnArr addObject:_allBtnArr[4]];
        }
        
        if (newModel.SHOPSERVPARK) {//停车
            [_realBtnArr addObject:_allBtnArr[5]];
        }
    }
    
}

@end
