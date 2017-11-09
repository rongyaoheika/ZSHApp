//
//  ZSHEntertainmentDisViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentDisViewController.h"
#import "ZSHDetailDemandViewController.h"

@interface ZSHEntertainmentDisViewController ()

@property (nonatomic, strong) NSArray            *pushVCsArr;
@property (nonatomic, strong) NSArray            *paramArr;
@property (nonatomic, strong) NSArray            *titleArr;
@property (nonatomic, strong) NSArray            *detailTitleArr;

@end
static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHEntertainmentDisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"开始时间",@"结束时间",@"期望价格",@"方式",@"人数要求",@"性别要求",@"年龄要求",@"详细要求"];
    self.detailTitleArr = @[@"2017-10-1",@"2017-10-7",@"0-1000",@"AA互动趴",@"一对一",@"不限",@"18-30岁",@" "];
    [self initViewModel];
}

- (void)createUI{
    self.title = @"吃喝玩乐";
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight);
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

- (ZSHBaseTableViewSectionModel*)storeListSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<self.titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(40);
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
             ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHBaseCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = weakself.titleArr[i];
            cell.textLabel.font = kPingFangRegular(14);
            cell.detailTextLabel.text = weakself.detailTitleArr[i];
            cell.detailTextLabel.font = kPingFangRegular(14);
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            if (indexPath.row == 7) {
                ZSHDetailDemandViewController *hotelDetailVC = [[ZSHDetailDemandViewController alloc] init];
                [weakself.navigationController pushViewController:hotelDetailVC animated:YES];
            }
        };
    }
    return sectionModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
