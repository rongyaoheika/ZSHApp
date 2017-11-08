//
//  ZSHGoodsSubViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsSubViewController.h"
#import "ZSHGoodsChartCell.h"
@interface ZSHGoodsSubViewController ()

@end

static NSString *ZSHGoodsChartCellID = @"ZSHGoodsChartCell";
@implementation ZSHGoodsSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [self.tableView registerClass:[ZSHGoodsChartCell class] forCellReuseIdentifier:ZSHGoodsChartCellID];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView reloadData];
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    NSArray *paramArr = @[
  @{@"leftTitle":@"材质",@"rightTitle":@"牛皮"},
  @{@"leftTitle":@"箱包硬度",@"rightTitle":@"软"},
  @{@"leftTitle":@"颜色",@"rightTitle":@"黑"},
  @{@"leftTitle":@"图案",@"rightTitle":@"纯色"},
  @{@"leftTitle":@"大小",@"rightTitle":@"中"}
  ];
    for (int i = 0; i<5; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(40);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHGoodsChartCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHGoodsChartCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:paramArr[i]];
            
            return cell;
        };
    }
    return sectionModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
