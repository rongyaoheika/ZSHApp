//
//  ZSHHotelPayViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelPayViewController.h"
#import "ZSHHotelPayHeadCell.h"
#import "ZSHOrderPayCell.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHHotelDetailModel.h"
#import "ZSHHotelDetailModel.h"

@interface ZSHHotelPayViewController ()

@property (nonatomic, strong) ZSHBaseModel       *model;

@end

static NSString *ZSHHotelPayHeadCellID = @"ZSHHotelPayHeadCell";
static NSString *ZSHBasePriceCellID = @"ZSHBasePriceCell";
static NSString *ZSHOrderPayCellID = @"ZSHOrderPayCell";

@implementation ZSHHotelPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
    self.model = self.paramDic[@"model"];
}

- (void)createUI{
    self.title = @"订单支付";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight-KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
    [self.tableView registerClass:[ZSHOrderPayCell class] forCellReuseIdentifier:ZSHOrderPayCellID];
    
    [self.tableView reloadData];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePriceSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePaySection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(150);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelPayHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelPayHeadCellID forIndexPath:indexPath];
        cell.fromClassType = [self.paramDic[@"fromClassType"]integerValue];
        [cell updateCellWithModel:self.model];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}

//价格
- (ZSHBaseTableViewSectionModel*)storePriceSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(40);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHBasePriceCellID];
        cell.textLabel.text = @"订单金额¥999";
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}

//支付方式
- (ZSHBaseTableViewSectionModel*)storePaySection {
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *titleCellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:titleCellModel];
    titleCellModel.height = kRealValue(40);
    titleCellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHBasePriceCellID];
        cell.textLabel.text = @"支付方式";
        return cell;
    };
    
    NSArray *paramArr = @[
                          @{@"payImage":@"pay_wechat",@"title":@"微信支付",@"btnTag":@(1),@"btnNormalImage":@"pay_btn_normal",@"btnPressImage":@"pay_btn_press"},
                          @{@"payImage":@"pay_alipay",@"title":@"支付宝支付",@"btnTag":@(2),@"btnNormalImage":@"pay_btn_normal",@"btnPressImage":@"pay_btn_press"}
                          ];
    for (int i = 0; i<2; i++) {
        ZSHBaseTableViewCellModel *payCellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:payCellModel];
        payCellModel.height = kRealValue(40);
        payCellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHOrderPayCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:paramArr[i]];
            return cell;
        };
    }
    return sectionModel;
}

#pragma action
- (void)payBtnAction{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
