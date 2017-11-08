//
//  ZSHIntegralBillViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHIntegralBillViewController.h"
#import "ZSHIntegralBillCell.h"
#import "ZSHIntegalModel.h"

@interface ZSHIntegralBillViewController ()

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ZSHIntegralBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.dataArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<4; i++) {
        NSDictionary *dataDic = @{@"imageName":@"good_watch_little",@"descText":@"卡地亚Cartier伦敦SOLO手表 石英男表W6701005",@"bottomText":@"购物送积分",@"dateText":@"10-03",@"integralCount":@"+17"};
        ZSHIntegalModel *orderModel = [ZSHIntegalModel modelWithDictionary:dataDic];
        [self.dataArr addObject:orderModel];
    }
    
    [self initViewModel];
  
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(10);
    
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        kWeakSelf(cellModel);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            static NSString *identifier = @"billCell";
            ZSHIntegralBillCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ZSHIntegralBillCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:identifier];
            }
            ZSHIntegalModel *integralModel = weakself.dataArr[indexPath.row];
            weakcellModel.height = [ZSHIntegralBillCell getCellHeightWithModel:integralModel];
            [cell updateCellWithModel:integralModel];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
