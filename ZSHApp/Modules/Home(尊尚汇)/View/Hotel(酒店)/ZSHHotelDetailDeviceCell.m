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
    
    //名字
    NSDictionary *titleLabelDic = @{@"text":@"配备最先进的有氧运动设备"};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:_titleLabel];
    
    if (_shopType == ZSHShipType) {
        return;
    }
    
    //好评
    NSDictionary *topDic = @{@"text":@"4.9",@"font":kPingFangMedium(18),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(15)};
    NSDictionary *bottomDic = @{@"text":@"好评",@"font":kPingFangMedium(11),@"textAlignment":@(NSTextAlignmentCenter),@"height":@(11)};
    _commentBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:topDic bottomDic:bottomDic];
    [self.contentView addSubview:_commentBtn];
    
    //设备
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
        NSDictionary *hotelDeviceBtnDic = @{@"title":dic[@"titleName"],@"font":kPingFangRegular(11),@"tag":@(i+1),@"normalImage":dic[@"imageName"]};
        UIButton *hotelDeviceBtn = [ZSHBaseUIControl  createBtnWithParamDic:hotelDeviceBtnDic target:self action:@selector(hotelDeviceBtnAction:)];
        hotelDeviceBtn.tag = i;
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
    
    if (_shopType == ZSHShipType) {
        return;
    }
    
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
            make.left.mas_equalTo(self.contentView).offset(i*btnWith);
            make.top.mas_equalTo(_commentBtn.mas_bottom).offset(kRealValue(13));
            make.width.mas_equalTo(btnWith);
            make.height.mas_equalTo(kRealValue(22));
        }];
        
        [deviceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2.5, 0, 0)];
        i++;
    }
    
}

#pragma action

- (void)hotelDeviceBtnAction:(UIButton *)hotelDevieBtn{
    
}

- (void)foodDeviceBtnAction:(UIButton *)foodDeviceBtn{
    
}

#pragma action
- (void)updateCellWithParamDic:(NSDictionary *)dic{
    if (_shopType == ZSHShipType) {
        _titleLabel.text = dic[@"YACHTNAMES"];
        return;
    }
    
    //好评
    UILabel *topLabel = [_commentBtn viewWithTag:11];
    NSString *commentStr = @"4.9";
    
    
    switch (_shopType) {
        case ZSHFoodShopType:{//美食详情
            _titleLabel.text = dic[@"SHOPNAMES"];
            commentStr = [NSString stringWithFormat:@"%.1f",[dic[@"SHOPEVALUATE"]floatValue] ];
            break;
        }
            
        case ZSHHotelShopType:{//酒店详情(酒店订单详情)
            _titleLabel.text = dic[@"HOTELNAMES"];
            commentStr = [NSString stringWithFormat:@"%.1f",[dic[@"SHOPEVALUATE"]floatValue] ];
            break;
        }
            
        case ZSHKTVShopType:{//KTV详情
             _titleLabel.text = dic[@"KTVNAMES"];
             commentStr = [NSString stringWithFormat:@"%.1f",[dic[@"KTVEVALUATE"]floatValue] ];
             break;
        }
           
        case ZSHBarShopType:{//酒吧详情（无此字段）
            _titleLabel.text = dic[@"BARNAMES"];
            commentStr = [NSString stringWithFormat:@"%.1f",[dic[@"BarEVALUATE"]floatValue] ];
            break;
        }
       
        default:
            break;
    }
    
    if (_showCellType == ZSHNormalType) {
        _titleLabel.text = @"配备最先进的有氧运动设备";
    }
    
    topLabel.text = commentStr;
    [self createRealBtnArrWith:dic];
}

- (void)createRealBtnArrWith:(NSDictionary *)dic{
    dic[@"SHOPSERVWIFI"]?[_realBtnArr addObject:_allBtnArr[0]]:0;     //wifi
    dic[@"SHOPSERVPAY"]?[_realBtnArr addObject:_allBtnArr[1]]:0;      //移动支付
    dic[@"SHOPSERVFOOD"]?[_realBtnArr addObject:_allBtnArr[2]]:0;     //餐饮
    dic[@"SHOPSERVFITNESS"]?[_realBtnArr addObject:_allBtnArr[3]]:0;  //健身
    dic[@"SHOPSERVSWIM"]?[_realBtnArr addObject:_allBtnArr[4]]:0;     //游泳
    dic[@"SHOPSERVPARK"]?[_realBtnArr addObject:_allBtnArr[5]]:0;     //停车
    
}


@end
