//
//  ZSHBuySearchViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBuySearchResultViewController.h"
#import "ZSHBuyLogic.h"

@interface ZSHBuySearchResultViewController ()
@property (nonatomic, strong) ZSHBuyLogic           *buyLogic;
@end

@implementation ZSHBuySearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
    
}

- (void)createUI{
    self.title = @"结果";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:@"searchResult"];

}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(10);
    
    for (int i = 0; i < 3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(127);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            static NSString *identifier = @"exchangeCell";
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResult"];
//            NSDictionary *nextParamDic= @{KFromClassType:@(FromCouponVCToIntegralExchangeCell)};
//            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}


- (void)requestData {
    [_buyLogic requestShipDimQueryWithKeywords:self.paramDic[@"searchText"] success:^(id response) {

    }];
}

@end
