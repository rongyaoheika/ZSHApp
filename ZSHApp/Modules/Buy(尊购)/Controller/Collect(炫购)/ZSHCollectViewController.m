//
//  ZSHCollectViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCollectViewController.h"
#import "ZSHCollectCell.h"
#import "ZSHBuyLogic.h"

static NSString *CollectCellIdentifier = @"CollectCellIdentifier";

@interface ZSHCollectViewController ()

@property (nonatomic, strong) ZSHBuyLogic  *buyLogic;

@end

@implementation ZSHCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [self initViewModel];
    [self requstData];
}

- (void)createUI{
    self.title = @"炫购收藏";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHCollectCell class] forCellReuseIdentifier:CollectCellIdentifier];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<_buyLogic.collectModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(100);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectCellIdentifier forIndexPath:indexPath];
            [cell updateCellWithModel:_buyLogic.collectModelArr[indexPath.row]];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}


- (void)requstData {
    kWeakSelf(self);
    [_buyLogic requestShipCollectWithUserID:@"d6a3779de8204dfd9359403f54f7d27c" success:^(id response) {
        [weakself initViewModel];
    }];
}

@end
