//
//  ZSHLiveDayListViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveDayListViewController.h"
#import "ZSHLiveDayListCell.h"
#import "ZSHLiveLogic.h"
static NSString *ZSHLiveDayCellID = @"ZSHLiveDayCellID";

@interface ZSHLiveDayListViewController ()

@property (nonatomic, strong)ZSHLiveLogic   *liveLogic;
@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation ZSHLiveDayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadData];
}

- (void)loadData{
    _liveLogic = [[ZSHLiveLogic alloc]init];
    
    [self initViewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHLiveDayListCell class] forCellReuseIdentifier:ZSHLiveDayCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHLiveDayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLiveDayCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = _dataArr[indexPath.row];
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    
    return sectionModel;
}

- (void)requestData{
    kWeakSelf(self);
    NSDictionary *paramDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue,@"TYPE":self.paramDic[@"TYPE"]};
    [_liveLogic requestRankWithDic:paramDic success:^(id response) {
        weakself.dataArr = response[@"pd"];
        [weakself initViewModel];
    }];
}

@end
