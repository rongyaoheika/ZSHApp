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
    [_transformBtn addTarget:self action:@selector(transformAction) forControlEvents:UIControlEventTouchUpInside];
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

- (void)transformAction {
    
    UIView *snapshot1 = [self customSnapshotFromView:_beginPlaceBtn];
    UIView *snapshot2 = [self customSnapshotFromView:_endPlaceBtn];
    [self addSubview:snapshot1];
    [self addSubview:snapshot2];
    [self insertSubview:snapshot1 belowSubview:_endPlaceBtn];
    [self insertSubview:snapshot2 belowSubview:_beginPlaceBtn];
    kWeakSelf(self);
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakself.beginPlaceBtn.hidden = true;
        weakself.endPlaceBtn.hidden = true;
        
        snapshot1.center = weakself.endPlaceBtn.center;
        snapshot2.center = weakself.beginPlaceBtn.center;
    } completion:^(BOOL finished) {
        [self insertSubview:snapshot1 belowSubview:weakself.endPlaceBtn];
        [self insertSubview:snapshot2 belowSubview:weakself.beginPlaceBtn];
        
        NSString *temp = weakself.endPlaceBtn.text;
        weakself.endPlaceBtn.text = weakself.beginPlaceBtn.text;
        weakself.beginPlaceBtn.text = temp;
        
        weakself.beginPlaceBtn.hidden = false;
        weakself.endPlaceBtn.hidden = false;
        
        [snapshot1 removeFromSuperview];
        [snapshot2 removeFromSuperview];
    }];
}


/** 返回一个给定view的截图. */
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.center = inputView.center;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
