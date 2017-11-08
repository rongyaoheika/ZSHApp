//
//  ZSHChangeInfoViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHChangeInfoViewController.h"

@interface ZSHChangeInfoViewController ()

@end

@implementation ZSHChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self loadData];
//    [self createUI];
}

/*- (void)loadData{
   
    [self initViewModel];
}

- (void)createUI{
    self.title = @"个人资料";
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
    [self.tableViewModel.sectionModelArray addObject:[self storeFirstSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeSecondSection]];
}

//第一组
- (ZSHBaseTableViewSectionModel*)storeFirstSection{
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<[self.titleArr[0] count]; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = (i==0? kRealValue(55):kRealValue(43));
        cellModel.renderBlock = ^ZSHBaseCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            
            NSDictionary *nextParamDic = @{@"leftTitle":weakself.titleArr[0][indexPath.row],@"rightTitle":weakself.detailTitleArr[0][indexPath.row],@"row":@(indexPath.row)};
            ZSHSimpleCellView *cellView = [[ZSHSimpleCellView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(43)) paramDic:nextParamDic];
            [cell.contentView addSubview:cellView];
            [cellView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell);
            }];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            Class className = NSClassFromString(self.pushVCsArr[indexPath.row]);
            RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[indexPath.row]];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
    }
    return sectionModel;
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
