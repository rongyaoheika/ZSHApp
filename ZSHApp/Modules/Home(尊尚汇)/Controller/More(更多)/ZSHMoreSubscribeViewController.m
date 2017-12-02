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

@property (nonatomic, strong) NSMutableArray                 *btnArr;
@property (nonatomic, strong) NSArray                        *pushVCsArr;
@property (nonatomic, strong) NSArray                        *paramArr;
@property (nonatomic, strong) ZSHHomeLogic                   *homeLogic;
@property (nonatomic, strong) NSArray<ZSHPrivlegeModel *>    *privlegeModelArr;

@property (nonatomic, strong) NSArray                        *titleArr;
@property (nonatomic, strong) NSMutableArray                 *mContentVCS;
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
    self.pushVCsArr = @[@"ZSHTitleContentViewController",  //美食
                        @"ZSHTitleContentViewController",  //酒店
                        @"ZSHTitleContentViewController",  //酒吧
                        @"ZSHTitleContentViewController",  //KTV
                        @"ZSHAirPlaneViewController",      //火车票
                        @"ZSHAirPlaneViewController",      //飞机票
                        
                        @"ZSHTitleContentViewController",     //马术
                        @"ZSHTitleContentViewController",     //游艇
                        @"ZSHTitleContentViewController",     //豪车
                        @"ZSHSubscribeViewController",        //飞机
                        @"ZSHTitleContentViewController",     //高尔夫汇

                        @"ZSHPersonalTailorViewController",   //私人定制
                        @"ZSHSubscribeViewController",//品牌杂志
                        @"ZSHSubscribeViewController",//健康养生
                        @"ZSHSubscribeViewController",//高端品鉴
//                        @"ZSHMoreSubscribeViewController"
                        @"ZSHSubscribeViewController" //定制理财
                        ];
    self.paramArr = @[
                      @{KFromClassType:@(FromFoodVCToTitleContentVC)},
                      @{KFromClassType:@(FromHotelVCToTitleContentVC)},
                      @{KFromClassType:@(FromHotelVCToTitleContentVC)},
                      @{KFromClassType:@(FromKTVVCToTitleContentVC)},
                      @{KFromClassType:@(ZSHFromHomeTrainVCToAirPlaneVC),@"title":@"火车票预订"},
                      @{KFromClassType:@(ZSHHomeAirPlaneVCToAirPlaneVC),@"title":@"机票预订"},
                      @{KFromClassType:@(FromHorseVCToTitleContentVC)},
                      @{KFromClassType:@(FromShipVCToTitleContentVC)},
                      @{KFromClassType:@(FromLuxcarVCToTitleContentVC)},
                      @{KFromClassType:@(ZSHPlaneType),@"title":@"飞机"},
                      @{KFromClassType:@(FromGolfVCToTitleContentVC)},
                      @{@"title":@"私人定制"},
                      @{KFromClassType:@(ZSHShipType),@"title":@"品牌杂志"},
                      @{KFromClassType:@(ZSHShipType),@"title":@"健康养生"},
                      @{KFromClassType:@(ZSHShipType),@"title":@"高端品鉴"},
                      @{KFromClassType:@(ZSHShipType),@"title":@"定制理财"},
                       ];
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
    NSString *privilegeID = _privlegeModelArr[tag].PRIVILEGE_ID;
    
    NSArray *privilegeIDs = @[@"383387957278539776", @"383557677113933824", @"385379959020978176", @"385380016873013248", @"383557751072096256", @"383557820093562880", @"383557868474859520", @"383557942164586496", @"383557992391376896", @"383558270297571328", @"383558332801089536", @"383558377935994880", @"383558448089923584", @"383558527584567296", @"383558605036584960", @"383558664083996672"];
    
    if ([privilegeIDs containsObject:privilegeID]) {
        NSInteger index = [privilegeIDs indexOfObject:privilegeID];
        Class className = NSClassFromString(self.pushVCsArr[index]);
        RootViewController *vc = [[className alloc]initWithParamDic:self.paramArr[index]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
