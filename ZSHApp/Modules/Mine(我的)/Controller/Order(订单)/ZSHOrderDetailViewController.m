//
//  ZSHOrderDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHOrderDetailViewController.h"
#import "ZSHOrderUserInfoCell.h"
#import "ZSHGoodsDetailCell.h"

@interface ZSHOrderDetailViewController ()

@end

@implementation ZSHOrderDetailViewController

static NSString *ZSHOrderUserInfoCellID = @"ZSHOrderUserInfoCell";
static NSString *ZSHGoodsDetailCellID = @"ZSHGoodsDetailCell";
static NSString *ZSHGoodsGreetCellID = @"ZSHGoodsGreetCell";

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
    self.title = @"订单详情";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight - KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    
    [self.tableView registerClass:[ZSHOrderUserInfoCell class] forCellReuseIdentifier:ZSHOrderUserInfoCellID];
    [self.tableView registerClass:[ZSHGoodsDetailCell class] forCellReuseIdentifier:ZSHGoodsDetailCellID];
    
    [self.tableView reloadData];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(serviceBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeGreetSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeUserInfoSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeGoodsDetailSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeOrderDetailSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePriceSection]];
}

//欢迎
- (ZSHBaseTableViewSectionModel*)storeGreetSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(44);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHGoodsGreetCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"order_distribute"];
        cell.textLabel.text = @"感谢您在尊尚汇购物，欢迎您再次光临";
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}


//个人信息
- (ZSHBaseTableViewSectionModel*)storeUserInfoSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(75);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHOrderUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHOrderUserInfoCellID forIndexPath:indexPath];
        NSDictionary *paramDic = @{@"userName":@"蒋小宝",@"phoneNum":@"13719103456",@"userAddress":@"北京市朝阳区西大望路甲23号SOHO现代城A座1720"};
        [cell updateCellWithParamDic:paramDic];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

//商品详情
- (ZSHBaseTableViewSectionModel*)storeGoodsDetailSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(100);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHGoodsDetailCellID forIndexPath:indexPath];
        cell.fromClassType = ZSHFromOrderDetailVCToGoodsDetailCell;
//        [cell updateCellWithModel:nil];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

//订单信息
- (ZSHBaseTableViewSectionModel*)storeOrderDetailSection {
    NSArray *titleArr = @[@"订单编号：6783202399892",@"下单时间：2017-10-15 22:12:40",@"配送方式：顺丰快递"];
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i<titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(28);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHGoodsGreetCellID];
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


//总金额
- (ZSHBaseTableViewSectionModel*)storePriceSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(40);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHGoodsGreetCellID];
        cell.textLabel.text = @"总金额";
        cell.detailTextLabel.text = @"¥999";
        cell.detailTextLabel.font = kPingFangMedium(17);
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}


- (void)serviceBtnAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
