//
//  ZSHPrivilegeController.m
//  ZSHApp
//
//  Created by mac on 12/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHPrivilegeController.h"
#import "ZSHTogetherView.h"
#import "ZSHBuyLogic.h"

static NSString *ZSHPrivilegeCellID = @"ZSHPrivilegeCellID";

@interface ZSHPrivilegeController ()

@property (nonatomic, strong) ZSHBuyLogic  *buyLogic;
@end

@implementation ZSHPrivilegeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [self requestData];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomTabH, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHTogetherView class] forCellReuseIdentifier:ZSHPrivilegeCellID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.buyLogic.personModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(185);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //需要注册，无需判空
            ZSHTogetherView *cell = [tableView dequeueReusableCellWithIdentifier:ZSHPrivilegeCellID forIndexPath:indexPath];
            [cell setParamDic:@{KFromClassType:@(ZSHFromPersonalTailorVCToTogetherView)}];
            [cell updateCellWithModel:weakself.buyLogic.personModelArr[indexPath.row]];
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    return sectionModel;
}

- (void)requestData {
    kWeakSelf(self);
    [_buyLogic requestPersonLists:^(id response) {
        [weakself initViewModel];
    }];
}

@end
