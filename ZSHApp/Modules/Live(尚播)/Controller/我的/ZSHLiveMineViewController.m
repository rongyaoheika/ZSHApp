//
//  ZSHLiveMineViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveMineViewController.h"
#import "ZSHLiveMineHeadView.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHNotificationViewController.h"
static NSString *headCellIdentifier     = @"LiveHeadCell";
static NSString *bottomCellIdentifier   = @"LiveListCell";

@interface ZSHLiveMineViewController ()

@property (nonatomic, strong) NSArray   *titleArr;
@property (nonatomic, strong) NSArray   *imageArr;
@property (nonatomic, strong) NSArray   *pushVCS;
@property (nonatomic, strong) NSArray   *paramArr;

@end

@implementation ZSHLiveMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"贡献榜",@"等级",@"任务中心",@"签到",@"设置"];
    self.imageArr = @[@"live_mine_icon_1",@"live_mine_icon_2",@"live_mine_icon_3",@"live_mine_icon_4",@"live_mine_icon_5"];
    self.pushVCS = @[@"ZSHTitleContentViewController",@"ZSHTitleContentViewController",@"ZSHLiveTaskCenterViewController",@"",@"ZSHNotificationViewController"];
  
    self.paramArr = @[
                      @{KFromClassType:@(FromContributionListVCToTitleContentVC), @"title":@"贡献榜"},
                      @{KFromClassType:@(FromMineLevelVCToTitleContentVC), @"title":@"我的等级"},
                      @{},
                      @{KFromClassType:@(FromLiveMineVCToNotificationVC),@"title":@"设置"}];
    
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
        
        ZSHLiveMineHeadView *cellView = [[ZSHLiveMineHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, cellHeight) paramDic:nil];
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

@end
