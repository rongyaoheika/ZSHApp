//
//  ZSHOrderSubViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHOrderSubViewController.h"
#import "ZSHOrderCell.h"
#import "ZSHOrderModel.h"
#import "ZSHOrderDetailViewController.h"
#import "ZSHMineLogic.h"

static NSString *cellIdentifier = @"listCell";

@interface ZSHOrderSubViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZSHMineLogic   *mineLogic;


@end

@implementation ZSHOrderSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.dataArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<5; i++) {
        NSDictionary *dataDic = @{@"imageName":@"good_watch_little",@"descText":@"卡地亚Cartier伦敦SOLO手表 石英男表W6701005",@"bottomText":@"共1件商品 实付款¥49200",@"result":@"已发货"};
        ZSHOrderModel *orderModel = [ZSHOrderModel modelWithDictionary:dataDic];
        [self.dataArr addObject:orderModel];
    }
    [self initViewModel];
    _mineLogic = [[ZSHMineLogic alloc] init];
    [self requestData];
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
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
    for (int i = 0; i < _mineLogic.goodOrderModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        kWeakSelf(cellModel);
        cellModel.height = kRealValue(90);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //无需注册，需要判空
            ZSHOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ZSHOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            ZSHGoodOrderModel *orderModel = weakself.mineLogic.goodOrderModelArr[indexPath.row];
//            weakcellModel.height = [ZSHOrderCell getCellHeightWithModel:orderModel];
            [cell updateCellWithModel:orderModel];

            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHOrderDetailViewController *orderDetailVC = [[ZSHOrderDetailViewController alloc]init];
            [weakself.navigationController pushViewController:orderDetailVC animated:YES];
        };
    }
    
    return sectionModel;
}


- (void)requestData {
    kWeakSelf(self);
    if (self.paramDic[@"ORDERSTATUS"]) {
        [_mineLogic requestOrderConListWithOrderStatus:self.paramDic[@"ORDERSTATUS"] success:^(id response) {
            [weakself initViewModel];
        }];
    } else {
        [_mineLogic requestOrderAllList:^(id response) {
            [weakself initViewModel];
        }];
    }
  
}

@end
