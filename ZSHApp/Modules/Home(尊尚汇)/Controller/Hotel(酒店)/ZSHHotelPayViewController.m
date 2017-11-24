//
//  ZSHHotelPayViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelPayViewController.h"
#import "ZSHHotelPayHeadCell.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHHotelModel.h"
#import "ZSHHotelModel.h"
#import "ZSHPayView.h"
@interface ZSHHotelPayViewController ()

@property (nonatomic, strong) ZSHPayView         *payView;
@property (nonatomic, strong) ZSHBaseModel       *model;
@property (nonatomic, assign) NSInteger          selectedCellRow;
@property (nonatomic, strong) NSArray            *cellParamArr;

@end

static NSString *ZSHHotelPayHeadCellID = @"ZSHHotelPayHeadCell";
static NSString *ZSHBasePriceCellID = @"ZSHBasePriceCell";

@implementation ZSHHotelPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
     self.model = self.paramDic[@"model"];
     [self initViewModel];
}

- (void)createUI{
    self.title = @"订单支付";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight-KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHHotelPayHeadCell class] forCellReuseIdentifier:ZSHHotelPayHeadCellID];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBasePriceCellID];
    [self.tableView reloadData];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePriceSection]];
    
    kWeakSelf(self);
    NSDictionary *nextParamDic = @{@"title":@"支付方式"};
    _payView = [[ZSHPayView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(40)) paramDic:nextParamDic];
    [self.tableViewModel.sectionModelArray addObject:[_payView storePaySection]];
    _payView.rightBtnBlcok = ^(UIButton *btn) {
        [weakself rightBtnAction:btn];
    };
}

//head
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(150);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHHotelPayHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHotelPayHeadCellID forIndexPath:indexPath];
        cell.fromClassType = [self.paramDic[KFromClassType]integerValue];
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

#pragma action
- (void)payBtnAction{
}

- (void)rightBtnAction:(UIButton *)rightBtn{
    ZSHBaseCell * cell = (ZSHBaseCell *)[[rightBtn superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    
    // 记录下当前的IndexPath.row
    _payView.selectedCellRow = path.row;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:path.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
