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
#import "ZSHHomeLogic.h"
#import "UIButton+WebCache.h"
#import "ZSHButtonView.h"
@interface ZSHMoreSubscribeViewController ()

@property (nonatomic, strong) NSMutableArray  *btnArr;
@property (nonatomic, strong) NSArray         *pushVCsArr;
@property (nonatomic, strong) NSArray         *paramArr;
@property (nonatomic, strong) ZSHHomeLogic    *homeLogic;
@property (nonatomic, strong) NSArray         *privlegeModelArr;

@end

@implementation ZSHMoreSubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"黑卡特权";
    
    [self loadData];
    [self createUI];
}

- (void)loadData {
    [self requestData];
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
                      @{KFromClassType:@(FromFoodVCToTitleContentVC)},
                      @{KFromClassType:@(FromHotelVCToTitleContentVC)},
                      @{KFromClassType:@(ZSHFromHomeTrainVCToAirPlaneVC),@"title":@"火车票预订"},
                      @{KFromClassType:@(ZSHHomeAirPlaneVCToAirPlaneVC),@"title":@"机票预订"},
                      @{KFromClassType:@(FromHorseVCToSubscribeVC),@"title":@"马术"},
                      @{KFromClassType:@(FromShipVCToSubscribeVC),@"title":@"游艇"},
                      @{KFromClassType:@(FromCarVCToSubscribeVC),@"title":@"豪车"},
                      @{KFromClassType:@(FromHelicopterVCToSubscribeVC),@"title":@"飞机"},
                      @{KFromClassType:@(FromGolfVCToSubscribeVC),@"title":@"高尔夫汇"},
                      @{},
                      @{},
                      @{},
                      @{},
                      @{}];
}

- (void)requestData{
    kWeakSelf(self);
    _homeLogic = [[ZSHHomeLogic alloc]init];
    [_homeLogic loadMorePrivilege];
    _homeLogic.requestDataCompleted = ^(NSArray *privlegeModelArr){
        weakself.privlegeModelArr = privlegeModelArr;
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself createUI];
    };
}

- (void)createUI {
    
    for (int i = 0; i<_privlegeModelArr.count; i++) {
        ZSHPrivlegeModel *privlegeModel = _privlegeModelArr[i];
        NSDictionary *labelParamDic = @{@"text":@"美食",@"font":kPingFangRegular(14),@"textAlignment":@(NSTextAlignmentCenter)};
        ZSHButtonView *btnView = [[ZSHButtonView alloc]initWithFrame:CGRectZero paramDic:labelParamDic];
        btnView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnView.label.text = privlegeModel.PRIVILEGENAME;
        [btnView.imageView sd_setImageWithURL:[NSURL URLWithString:privlegeModel.PRIVILEGEIMGS]];
        [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headBtnClick:)]];
        btnView.tag = i+10;
        [self.view addSubview:btnView];
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset((i/4) * kRealValue(72 + 18) + kRealValue(74));
            make.left.mas_equalTo(self.view).offset(((i%4)*(floor(KScreenWidth/4))));
            make.width.mas_equalTo(floor(KScreenWidth/4));
            make.height.mas_equalTo(kRealValue(72));
        }];
    }
}

- (void)headBtnClick:(UITapGestureRecognizer *)gesture {
    NSInteger tag = gesture.view.tag - 10;
//    NSInteger tag = sender.tag-10;
    Class className = NSClassFromString(self.pushVCsArr[tag]);
    RootViewController *vc = [[className alloc]initWithParamDic:self.paramArr[tag]];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
