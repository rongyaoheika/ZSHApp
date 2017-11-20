//
//  ZSHCardPayCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardPayCell.h"
#import "LXScollTitleView.h"
@interface ZSHCardPayCell ()

@property (nonatomic, strong) LXScollTitleView      *titleView;
@property (nonatomic, strong) UILabel               *promptLabel;


@end

@implementation ZSHCardPayCell

- (void)setup{
    NSArray *btnTitleArr = @[@"微信",@"支付宝"];
    [self.contentView addSubview:self.titleView];
    [self.titleView reloadViewWithTitles:btnTitleArr];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(20));
        make.left.mas_equalTo(self).offset((kScreenWidth-kRealValue(200))/2);
        make.width.mas_equalTo(kRealValue(200));
        make.height.mas_equalTo(kRealValue(30));
    }];
    
    int i = 0;
    NSArray *imageArr = @[@"pay_wechat",@"pay_alipay"];
    for (UIButton *btn in _titleView.titleButtons) {
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(10)];
         i++;
    }
}

#pragma getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, (kScreenWidth-kRealValue(200))/2, kRealValue(200), kRealValue(30))];
        _titleView.selectedBgImage = [UIImage imageNamed:@"card_press"];
        _titleView.normalTitleFont = kPingFangRegular(11);
        _titleView.selectedTitleFont = kPingFangRegular(11);
        _titleView.selectedColor = KZSHColorF29E19;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
//        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
//            __weak typeof(self) strongSelf = weakSelf;

        };
        _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seg_two_bg"] ];
        _titleView.titleWidth = kRealValue(100);
    }
    return _titleView;
}

@end
