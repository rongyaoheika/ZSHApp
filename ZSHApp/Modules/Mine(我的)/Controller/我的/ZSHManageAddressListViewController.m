//
//  ZSHManageAddressListViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHManageAddressListViewController.h"
#import "ZSHAddressModel.h"
#import "ZSHAddressListCell.h"

static NSString *cellIdentifier = @"listCell";
@interface ZSHManageAddressListViewController ()

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ZSHManageAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.dataArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<3; i++) {
        NSDictionary *dataDic = @{@"name":@"王晶",@"telephone":@"13718139876",@"address":@"北京市朝阳区西大望路甲23号soho现代城"};
        ZSHAddressModel *addressModel = [ZSHAddressModel modelWithDictionary:dataDic];
        [self.dataArr addObject:addressModel];
    }
    [self initViewModel];
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
    [self.tableView reloadData];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(addAdressBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < self.dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(125);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //无需注册，需要判空
            ZSHAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ZSHAddressListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            ZSHAddressModel *addressModel = weakself.dataArr[indexPath.row];
            [cell updateCellWithModel:addressModel];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
            
        };
    }
    
    return sectionModel;
}

#pragma action
- (void)addAdressBtnAction {
    RLog(@"点击了添加新地址按钮");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
