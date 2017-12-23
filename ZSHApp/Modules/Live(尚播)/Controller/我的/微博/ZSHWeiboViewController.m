//
//  ZSHWeiboViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiboViewController.h"
#import "ZSHWeiBoCell.h"
#import "ZSHWeiBoCellModel.h"
#import "ZSHLiveLogic.h"

@interface ZSHWeiboViewController ()

@property (nonatomic, strong) NSArray           *dataArr;
@property (nonatomic, strong) ZSHLiveLogic      *liveLogic;

@end

@implementation ZSHWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _dataArr = [NSArray array];
    _liveLogic = [[ZSHLiveLogic alloc] init];
    
    [self initViewModel];
    [self requestData];
}

- (void)createUI{
    self.title = @"黑微博";
    
    [self.view addSubview:self.tableView];
    if (kFromClassTypeValue == FromPersonalVCToWeiboVC) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.view);
        }];
    } else if (kFromClassTypeValue == FromTabbarToWeiboVC ||kFromClassTypeValue == FromSelectToWeiboVC) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
        }];
    } else if (kFromClassTypeValue == FromMineVCToWeiboVC) {
        self.title = @"圈子中心";
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHWeiBoCell class] forCellReuseIdentifier:NSStringFromClass([ZSHWeiBoCell class])];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//head
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    kWeakSelf(self);
    for (int i = 0; i<self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        kWeakSelf(cellModel);
        ZSHWeiBoCellModel *model = weakself.dataArr[i];
        weakcellModel.height = [ZSHWeiBoCell getCellHeightWithModel:model];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZSHWeiBoCell class]) forIndexPath:indexPath];
            cell.backgroundColor = KClearColor;
            ZSHWeiBoCellModel *model = weakself.dataArr[indexPath.row];
//            weakcellModel.height = [cell getCellHeightWithModel:model];
            NSDictionary *ndextParamDic = @{KFromClassType:@(ZSHWeiboVCToWeiBoCell)};
            [cell updateCellWithParamDic:ndextParamDic];
            [cell updateCellWithModel:model];
            [cell updateFocusIfNeeded];
            return cell;
        };
    }
    return sectionModel;
}

- (void)requestData {
    kWeakSelf(self);
    [_liveLogic requestCircleList:^(id response) {
        weakself.dataArr = response;
        [weakself initViewModel];
    }];
}

- (void)headerRereshing{
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing{
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
