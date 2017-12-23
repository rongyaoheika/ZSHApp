//
//  ZSHTrainTicketDetailViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTrainTicketDetailViewController.h"
#import "ZSHTrainTicketDetailHeadView.h"
#import "ZSHTrainTicketDetailCell.h"
#import "ZSHBottomBlurPopView.h"

static NSString *ZSHTrainTicketDetailCellID = @"ZSHTrainTicketDetailCellID";

@interface ZSHTrainTicketDetailViewController ()

@property (nonatomic, strong) UILabel                *naviDateLabel;
@property (nonatomic, strong) ZSHBottomBlurPopView   *bottomBlurPopView;

@end

@implementation ZSHTrainTicketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
    
}

- (void)createUI{
    
    NSDictionary *titleLabelDic = @{@"text":@"10月10日周二",@"font":kPingFangMedium(17),@"textAlignment":@(NSTextAlignmentCenter)};
    _naviDateLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    _naviDateLabel.frame = CGRectMake(0, 0, KScreenWidth, 44);
    _naviDateLabel.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y);
    [self.navigationItem setTitleView:_naviDateLabel];
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, kScreenHeight -KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHTrainTicketDetailCell class] forCellReuseIdentifier:ZSHTrainTicketDetailCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storTicketDetailSection]];
}

//火车票详情
- (ZSHBaseTableViewSectionModel*)storTicketDetailSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(105);
    sectionModel.headerView = [[ZSHTrainTicketDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(105)) paramDic:nil];
    NSArray *trainType = @[@"二等座", @"一等座", @"商务座"];
    for (int i = 0; i<3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(70);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTrainTicketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHTrainTicketDetailCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:@{@"type":trainType[indexPath.row]}];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBottomBlurPopView *bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromTrainUserInfoVCToBottomBlurPopView];
            [kAppDelegate.window addSubview:bottomBlurPopView];
        };
    }
    return sectionModel;
}

#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bottomBlurPopView setBlurEnabled:NO];
    return bottomBlurPopView;
}

@end
