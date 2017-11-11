//
//  ZSHChargeRecViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHChargeRecViewController.h"
#import "ZSHChargeRecCell.h"

static NSString *ZSHLiveChargeCellID = @"ZSHLiveChargeCellID";

@interface ZSHChargeRecViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation ZSHChargeRecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    
    self.title = @"充值记录";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHChargeRecCell class] forCellReuseIdentifier:ZSHLiveChargeCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    self.dataArr = @[
                     @{@"imageName":@"pay_wechat",@"nickname":@"微信支付",@"value":@"-999元",@"date":@"2017年9月9日"},
                     @{@"imageName":@"pay_alipay",@"nickname":@"支付宝支付",@"value":@"-999元",@"date":@"2017年9月9日"},
                     @{@"imageName":@"pay_wechat",@"nickname":@"微信支付",@"value":@"-999元",@"date":@"2017年9月9日"}
                     ];
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHChargeRecCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLiveChargeCellID forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"imageName":self.dataArr[i][@"imageName"],@"nickname":self.dataArr[i][@"nickname"],@"value":self.dataArr[i][@"value"],@"date":self.dataArr[i][@"date"],@"index":@(i)};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    
    return sectionModel;
}
@end
