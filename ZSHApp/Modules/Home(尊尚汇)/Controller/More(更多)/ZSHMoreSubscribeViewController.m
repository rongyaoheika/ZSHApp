//
//  ZSHMoreSubscribeViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMoreSubscribeViewController.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHAirPlaneViewController.h"
#import "ZSHSubscribeViewController.h"

@interface ZSHMoreSubscribeViewController ()

@property (nonatomic, strong) NSMutableArray  *btnArr;
@property (nonatomic, strong) NSArray         *pushVCsArr;
@property (nonatomic, strong) NSArray         *paramArr;

@end

@implementation ZSHMoreSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑卡特权";
    
    [self loadData];
    [self createUI];
}

- (void)loadData {
    self.pushVCsArr = @[@"ZSHTitleContentViewController",
                        @"ZSHTitleContentViewController",
                        @"ZSHAirPlaneViewController",
                        @"ZSHAirPlaneViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHSubscribeViewController",
                        @"ZSHTailorDetailViewController",
                        @"",
                        @"",
                        @"",
                        @"ZSHMoreSubscribeViewController"];
    self.paramArr = @[
                      @{@"fromClassType":@(FromFoodVCToTitleContentVC)},
                      @{@"fromClassType":@(FromHotelVCToTitleContentVC)},
                      @{@"fromClassType":@(ZSHFromHomeTrainVCToAirPlaneVC),@"title":@"火车票预订"},
                      @{@"fromClassType":@(ZSHHomeAirPlaneVCToAirPlaneVC),@"title":@"机票预订"},
                      @{@"fromClassType":@(FromHorseVCToSubscribeVC),@"title":@"马术"},
                      @{@"fromClassType":@(FromShipVCToSubscribeVC),@"title":@"游艇"},
                      @{@"fromClassType":@(FromCarVCToSubscribeVC),@"title":@"豪车"},
                      @{@"fromClassType":@(FromHelicopterVCToSubscribeVC),@"title":@"飞机"},
                      @{@"fromClassType":@(FromGolfVCToSubscribeVC),@"title":@"高尔夫汇"},
                      @{},
                      @{},
                      @{},
                      @{},
                      @{}];
}

- (void)createUI {
    _btnArr = [[NSMutableArray alloc]init];
    
    NSArray *titleArr = @[@"美食",@"酒店",@"火车票",@"机票",@"马术",@"游艇",@"豪车",@"飞机",@"高尔夫汇",@"私人定制",@"品牌杂志",@"健康养生",@"高端品鉴", @"定制理财"];
    NSArray *imageArr = @[@"home_food",@"home_hotel",@"home_train",@"home_plane",@"home_horse",@"home_ship",@"home_car",@"home_helicopter",@"home_golf",@"home_diamond",@"home_magazine",@"home_healthy",@"home_judge",@"home_investment"];
    
    for (int i = 0; i<titleArr.count; i++) {        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kPingFangLight(14);
        [btn setTitleColor:KZSHColor929292 forState:UIControlStateNormal];
        btn.tag = i+10;
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [_btnArr addObject:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset((i/4) * kRealValue(72+18) + kRealValue(94));
            make.left.mas_equalTo(self.view).offset(((i%4)*(floor(KScreenWidth/4))));
            make.width.mas_equalTo(floor(KScreenWidth/4));
            make.height.mas_equalTo(kRealValue(72));
        }];
        [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleTop imageTitleSpace:kRealValue(6)];

    }
}

- (void)headBtnClick:(UIButton *)sender {
    NSInteger tag = sender.tag-10;
    Class className = NSClassFromString(self.pushVCsArr[tag]);
    RootViewController *vc = [[className alloc]initWithParamDic:self.paramArr[tag]];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
