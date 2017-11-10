//
//  ZSHLiveDayListViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveDayListViewController.h"
#import "ZSHLiveDayListCell.h"

static NSString *ZSHLiveDayCellID = @"ZSHLiveDayCellID";

@interface ZSHLiveDayListViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation ZSHLiveDayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
   
    [self initViewModel];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHLiveDayListCell class] forCellReuseIdentifier:ZSHLiveDayCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    self.dataArr = @[
                     @{@"imageName":@"list_user_1",@"nickname":@"忘记时间的钟",@"value":@"250689"},
                     @{@"imageName":@"list_user_2",@"nickname":@"智",@"value":@"250689"},
                     @{@"imageName":@"list_user_3",@"nickname":@"行走",@"value":@"250689"},
                     @{@"imageName":@"list_user_4",@"nickname":@"无名",@"value":@"250689"},
                     @{@"imageName":@"list_user_5",@"nickname":@"自由自在",@"value":@"250689"}
                     ];
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHLiveDayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLiveDayCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"imageName":self.dataArr[i][@"imageName"],@"nickname":self.dataArr[i][@"nickname"],@"value":self.dataArr[i][@"value"],@"index":@(i)};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    
    return sectionModel;
}

@end
