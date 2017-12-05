//
//  ZSHTicketPlaceCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTicketPlaceCell.h"
#import "ZSHCityViewController.h"

@interface ZSHTicketPlaceCell()

@property (nonatomic, strong) YYLabel          *beginPlaceBtn;
@property (nonatomic, strong) UIButton         *transformBtn;
@property (nonatomic, strong) YYLabel          *endPlaceBtn;


@end

@implementation ZSHTicketPlaceCell

- (void)setup{
    kWeakSelf(self);
    _beginPlaceBtn = [[YYLabel alloc] init];
    _beginPlaceBtn.text = @"北京";
    _beginPlaceBtn.font = kPingFangMedium(17);
    _beginPlaceBtn.textColor = KZSHColor929292;
    _beginPlaceBtn.backgroundColor = KClearColor;
    _beginPlaceBtn.textAlignment = NSTextAlignmentLeft;
    _beginPlaceBtn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _beginPlaceBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakself selectCity:@"0"];
    };
    [self addSubview:_beginPlaceBtn];
    [_beginPlaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.top.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(100));
        make.height.mas_equalTo(self);
    }];
    
    _transformBtn = [[UIButton alloc]init];
    [_transformBtn setBackgroundImage:[UIImage imageNamed:@"ticket_transform"] forState:UIControlStateNormal];
    [self addSubview:_transformBtn];
    [_transformBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(25)));
    }];
    
    _endPlaceBtn = [[YYLabel alloc] init];
    _endPlaceBtn.text = @"上海";
    _endPlaceBtn.font = kPingFangMedium(17);
    _endPlaceBtn.textColor = KZSHColor929292;
    _endPlaceBtn.backgroundColor = KClearColor;
    _endPlaceBtn.textAlignment = NSTextAlignmentRight;
    _endPlaceBtn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _endPlaceBtn.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakself selectCity:@"1"];
    };
    [self addSubview:_endPlaceBtn];
    [_endPlaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-KLeftMargin);
        make.top.mas_equalTo(self);
        make.width.mas_equalTo(_beginPlaceBtn);
        make.height.mas_equalTo(_beginPlaceBtn);
    }];
    
}


- (void)selectCity:(NSString *)tag {
    kWeakSelf(self);
    ZSHCityViewController *cityVC = [[ZSHCityViewController alloc]init];
    cityVC.saveCityBlock = ^(NSString *city) {
        if ([tag isEqualToString:@"0"]) {
            weakself.beginPlaceBtn.text = city;
        } else {
            weakself.endPlaceBtn.text = city;
        }
        if (weakself.saveBlock) {
            weakself.saveBlock(weakself.beginPlaceBtn.text, weakself.endPlaceBtn.text);
        }
    };
    [[kAppDelegate getCurrentUIVC].navigationController pushViewController:cityVC animated:YES];
}

@end
