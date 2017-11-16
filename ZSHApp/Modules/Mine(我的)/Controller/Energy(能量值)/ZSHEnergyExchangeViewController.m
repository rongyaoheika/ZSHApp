
//
//  ZSHEnergyExchangeViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEnergyExchangeViewController.h"

static NSString *ZSHEnergyExchangeCellID = @"ZSHEnergyExchangeCellID";

@interface ZSHEnergyExchangeViewController ()


@end

@implementation ZSHEnergyExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    
    self.title = @"积分兑换好礼";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHEnergyExchangeCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    NSArray *titleArr = @[@"年度优礼品--价值1万元礼品包", @"季度杂志【专刊一版】价值6万专访", @"生日特定大礼包--价值3000元礼品包",@"年度【黑咖之夜】--价值1万元礼品包",@"黑咖企业推广一次--价值20万元广告包"];
    NSArray *valueArr = @[@"5000积分", @"30000积分", @"00000积分", @"500000积分", @"1000000积分"];
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    
    for (int i = 0; i < titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(59);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ZSHEnergyExchangeCellID];
            cell.imageView.image = [UIImage imageNamed:@"energy_image_1"];
            cell.textLabel.text = titleArr[indexPath.row];
            cell.detailTextLabel.text = valueArr[indexPath.row];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        };
    }
    
    return sectionModel;
}
@end
