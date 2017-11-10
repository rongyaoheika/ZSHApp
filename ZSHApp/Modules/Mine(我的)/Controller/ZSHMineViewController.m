//
//  ZSHMineViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMineViewController.h"
#import "ZSHMineHeadView.h"
#import "ZSHGoodsMineViewController.h"
#import "ZSHLogisticsDetailViewController.h"
#import "ZSHMemberCenterViewController.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHServiceCenterViewController.h"

static NSString *headCellIdentifier     = @"headCell";
static NSString *bottomCellIdentifier   = @"listCell";

@interface ZSHMineViewController ()

@property (nonatomic, strong) NSArray   *titleArr;
@property (nonatomic, strong) NSArray   *imageArr;
@property (nonatomic, strong) NSArray   *pushVCS;
@property (nonatomic, strong) NSArray   *paramArr;

@end

@implementation ZSHMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"会员中心",@"管家中心",@"圈子中心",
                      @"活动中心",@"购物中心",@"客服中心",
                      @"钱包中心",@"游戏中心",@"订单中心",@"设置"];
    self.imageArr = @[@"mine_icon_1",@"mine_icon_2",@"mine_icon_3",@"mine_icon_4",@"mine_icon_5",@"mine_icon_6",@"mine_icon_7",@"mine_icon_8",@"mine_icon_10",@"mine_icon_9"];
    self.pushVCS = @[
  @"ZSHMemberCenterViewController",@"",@"",
  @"ZSHTitleContentViewController",@"",@"ZSHServiceCenterViewController",
  @"ZSHWalletCenterViewController",@"ZSHGameCenterViewController", @"ZSHGoodsMineViewController",@"ZSHSettingViewController"];
    self.paramArr = @[
                      @{},@{},@{},@{@"fromClassType":@(FromActivityCenterVCToTitleContentVC),@"title":@"活动中心"},@{},@{@"fromClassType":@(ZSHFromMineServiceVCToServiceCenterVC),@"title":@"客服中心"},@{},@{},@{},@{}];
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"我的";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight-KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:headCellIdentifier];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:bottomCellIdentifier];
    
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
    cellModel.height = kRealValue(137);
    __block  CGFloat cellHeight = cellModel.height;
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:headCellIdentifier forIndexPath:indexPath];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        
        ZSHMineHeadView *cellView = [[ZSHMineHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, cellHeight) paramDic:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:cellView];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(17.5);
    sectionModel.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(17.5))];
    for (int i = 0; i < [self.imageArr count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(43);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:weakself.imageArr[indexPath.row]];
            cell.textLabel.text = weakself.titleArr[indexPath.row];
            cell.textLabel.font = kPingFangRegular(15);
            cell.textLabel.textColor = KZSHColor929292;
        
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            Class className = NSClassFromString(self.pushVCS[indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[indexPath.row]];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
