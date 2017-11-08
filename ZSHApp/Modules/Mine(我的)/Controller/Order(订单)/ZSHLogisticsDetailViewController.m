//
//  ZSHLogisticsDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLogisticsDetailViewController.h"
#import "ZSHLogisticsDetailCell.h"
#import "ZSHLogisticsDetailModel.h"

@interface ZSHLogisticsDetailViewController ()

@property (nonatomic, strong) NSArray    *headTitleArr;
@property (nonatomic, strong) NSArray    *dataArr;
@property (nonatomic, strong) UIView     *headView;
@property (nonatomic, strong) UILabel    *numLabel;
@property (nonatomic, strong) UILabel    *dateLabel;

@end

static NSString *ZSHLogisticsDetailHeadCellID = @"ZSHLogisticsDetailHeadCell";
static NSString *ZSHLogisticsDetailCellID = @"ZSHLogisticsDetailCell";
static NSString *ZSHBaseCellID = @"ZSHBaseCell";

@implementation ZSHLogisticsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.headTitleArr = @[@"6783202399892",@"2017-10-16"];
    NSArray *baseDataArr = @[@{@"detailText":@"已签收，感谢您在尊尚汇购物，欢迎您再次光临",@"timeText":@"2017-10-12 20:29:30"},
                     @{@"detailText":@"配送员【姜小白】已经出发，联系电话【13333333333】",@"timeText":@"2017-10-12 20:29:30"},
                     @{@"detailText":@"您的订单已进去北京40号仓准备出库",@"timeText":@"2017-10-12 20:29:30"},
                     @{@"detailText":@"您提交了订单，请等待系统确认",@"timeText":@"2017-10-12 20:29:30"}
                     ];
    self.dataArr = [ZSHLogisticsDetailModel mj_objectArrayWithKeyValuesArray:baseDataArr];
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"物流详情";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHLogisticsDetailCell class] forCellReuseIdentifier:ZSHLogisticsDetailCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeOrderDetailSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//head
- (ZSHBaseTableViewSectionModel*)storeOrderDetailSection {
    NSArray *titleArr = @[@"订单编号：6783202399892",@"预计送达：2017-10-16"];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(28);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHBaseCellID];
            cell.textLabel.text = titleArr[indexPath.row];
            cell.textLabel.font = kPingFangRegular(10);
            if (i != titleArr.count-1) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            }
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}


//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(75);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHLogisticsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHLogisticsDetailCellID forIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
            ZSHLogisticsDetailModel *model = self.dataArr[indexPath.row];
            cell.row = indexPath.row;
            [cell updateCellWithModel:model];
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
