//
//  ZSHManageAddressListViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHManageAddressListViewController.h"
#import "ZSHAddressListCell.h"
#import "ZSHMineLogic.h"
#import "ZSHManageAddressViewController.h"

static NSString *cellIdentifier = @"listCell";
@interface ZSHManageAddressListViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZSHMineLogic   *mineLogic;

@end

@implementation ZSHManageAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)loadData{
    [self initViewModel];
    
    _mineLogic = [[ZSHMineLogic alloc] init];
}

- (void)createUI{
    self.title = @"收货地址管理";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight-KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;

    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(addAdressBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < _mineLogic.addrModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(125);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //无需注册，需要判空
            ZSHAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ZSHAddressListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell.defaultBtn addTapBlock:^(UIButton *btn) {
                btn.selected = !btn.selected;
            }];
            [cell.editBtn addTapBlock:^(UIButton *btn) {
                [weakself editAdressBtnAction:weakself.mineLogic.addrModelArr[indexPath.row]];
            }];
            [cell.deleteBtn addTapBlock:^(UIButton *btn) {
                [weakself delAddressBtnAction:indexPath.row];
            }];
            ZSHAddrModel *addressModel = weakself.mineLogic.addrModelArr[indexPath.row];
            [cell updateCellWithModel:addressModel];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (weakself.getIndex) {
                weakself.getIndex(indexPath.row);
                [weakself.navigationController popViewControllerAnimated:true];
            }
        };
    }
    return sectionModel;
}


#pragma action

- (void)headrefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)requestData {
    kWeakSelf(self);
    [_mineLogic requestShipAdr:HONOURUSER_IDValue success:^(id response) {
        [weakself initViewModel];
    }];
}

- (void)delAddressBtnAction:(NSInteger)index {
    kWeakSelf(self);
    [_mineLogic requestUserDelShipAdrWithModel:_mineLogic.addrModelArr[index] success:^(id response) {
        if ([response[@"result"] isEqualToString:@"01"]) {
            [_mineLogic.addrModelArr removeObjectAtIndex:index];
            [weakself initViewModel];
        }
    }];
}

- (void)editAdressBtnAction:(ZSHAddrModel *)model {
    ZSHManageAddressViewController *manageAddressVC = [[ZSHManageAddressViewController alloc]initWithParamDic:@{@"AddrModel":model}];
    [self.navigationController pushViewController:manageAddressVC animated:YES];
}

- (void)addAdressBtnAction {
    ZSHManageAddressViewController *manageAddressVC = [[ZSHManageAddressViewController alloc]init];
    [self.navigationController pushViewController:manageAddressVC animated:YES];
}


@end
