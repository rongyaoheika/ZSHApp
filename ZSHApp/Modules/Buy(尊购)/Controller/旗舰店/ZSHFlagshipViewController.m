//
//  ZSHFlagshipViewController.m
//  ZSHApp
//
//  Created by mac on 11/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHFlagshipViewController.h"
#import "ZSHFlagshipCell.h"

static NSString * ZSHFlagshipCellID = @"ZSHFlagshipCellID";

@interface ZSHFlagshipViewController ()

@end

@implementation ZSHFlagshipViewController

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
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomTabH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHFlagshipCell class] forCellReuseIdentifier:ZSHFlagshipCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *dataArr = @[@"flagship0", @"flagship1", @"flagship2", @"flagship3"];
    for (int i = 0; i<dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(235);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHFlagshipCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHFlagshipCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:dataArr[i]];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}

@end
