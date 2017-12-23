//
//  ZSHTrainPassengerController.m
//  ZSHApp
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTrainPassengerController.h"
#import "ZSHTrainPassengerCell.h"

static NSString *ZSHTrainPassengerCellID = @"ZSHTrainPassengerCellID";

@interface ZSHTrainPassengerController ()

@end

@implementation ZSHTrainPassengerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    
    self.title = @"常用乘客";
    
    
    [self addNavigationItemWithTitles:@[@"保存"] isLeft:NO target:self action:@selector(saveAction) tags:@[@(1)]];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHTrainPassengerCell class] forCellReuseIdentifier:ZSHTrainPassengerCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    NSArray *nameArr = @[@"姜小白", @"姜小白"];
    NSArray *typeArr = @[@"（成人票）", @"（成人票）"];
    NSArray *IDValueArr = @[@"130626198008107888", @"130626198008107888"];
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i < nameArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(60);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHTrainPassengerCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHTrainPassengerCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"name":nameArr[i],@"type":typeArr[i],@"IDValue":IDValueArr[i],@"index":@(i)};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    
    return sectionModel;
}


- (void)saveAction {
    
}

@end
