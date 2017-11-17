//
//  ZSHMemberCenterViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMemberCenterViewController.h"
#import "ZSHNoticeViewCell.h"
#import "ZSHMemberCenterHeadView.h"

@interface ZSHMemberCenterViewController ()

@property (nonatomic, strong) ZSHMemberCenterHeadView   *headView;

@end

static NSString *ZSHHeadViewID = @"ZSHHeadView";
static NSString *ZSHNoticeViewCellID = @"ZSHNoticeViewCell";

@implementation ZSHMemberCenterViewController

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
    self.title = @"会员中心";
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHHeadViewID];
    [self.tableView registerClass:[ZSHNoticeViewCell class] forCellReuseIdentifier:ZSHNoticeViewCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeHeadSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeHeadSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(193);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHHeadViewID];
        if (![cell.contentView viewWithTag:2]) {
             [cell.contentView addSubview:self.headView];
        }
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
    };
    return sectionModel;
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(55);
    sectionModel.headerView = [self createHeaderiewWithTitle:@"会员尊享"];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(85);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHNoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHNoticeViewCellID forIndexPath:indexPath];
        NSDictionary *nextParamDic = @{KFromClassType:@(FromMemberCenterVCToNoticeView)};
        [cell updateCellWithParamDic:nextParamDic];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    
    return sectionModel;
}

#pragma getter
- (ZSHMemberCenterHeadView *)headView{
    if (!_headView) {
        _headView = [[ZSHMemberCenterHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(193)) paramDic:nil];
        _headView.tag = 2;
    }
    return _headView;
}

#pragma getter
- (UIView *)createHeaderiewWithTitle:(NSString *)title{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(55))];
    NSDictionary *headLabellDic = @{@"text":title, @"font":kPingFangMedium(15)};
    UILabel *headLabel = [ZSHBaseUIControl createLabelWithParamDic:headLabellDic];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(KLeftMargin);
        make.centerY.mas_equalTo(headView);
        make.width.mas_equalTo(KScreenWidth -2*kRealValue(13));
        make.height.mas_equalTo(kRealValue(15));
    }];
    return headView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
