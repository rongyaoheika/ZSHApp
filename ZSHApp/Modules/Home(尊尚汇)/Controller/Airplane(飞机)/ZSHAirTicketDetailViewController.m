//
//  ZSHAirTicketDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHAirTicketDetailViewController.h"
#import "ZSHAirTicketDetailCell.h"
#import "ZSHAirTicketDetailHeadView.h"
#import "ZSHBottomBlurPopView.h"
@interface ZSHAirTicketDetailViewController ()

@property (nonatomic,strong)UILabel  *naviDateLabel;


@end

static NSString *ZSHAirTicketDetailCellID = @"ZSHAirTicketDetailCell";

@implementation ZSHAirTicketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    [self.tableView registerClass:[ZSHAirTicketDetailCell class] forCellReuseIdentifier:ZSHAirTicketDetailCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storTicketDetailSection]];
}

//机票详情
- (ZSHBaseTableViewSectionModel*)storTicketDetailSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(105);
    sectionModel.headerView = [[ZSHAirTicketDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(105)) paramDic:nil];
    for (int i = 0; i<5; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(70);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHAirTicketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHAirTicketDetailCellID forIndexPath:indexPath];
            return cell;
        };
    
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBottomBlurPopView *bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromAirplaneUserInfoVCToBottomBlurPopView];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
