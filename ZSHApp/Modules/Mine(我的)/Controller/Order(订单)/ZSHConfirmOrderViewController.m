//
//  ZSHConfirmOrderViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHConfirmOrderViewController.h"
#import "ZSHGoodModel.h"
#import "ZSHOrderUserInfoCell.h"
#import "ZSHGoodsDetailCell.h"
#import "ZSHOrderPayCell.h"
#import "JSNummberCount.h"

@interface ZSHConfirmOrderViewController ()

@end

static NSString *ZSHOrderUserInfoCellID = @"ZSHOrderUserInfoCell";
static NSString *ZSHGoodsDetailCellID = @"ZSHGoodsDetailCell";
static NSString *ZSHGoodsCouponCellID = @"ZSHGoodsCouponCell";
static NSString *ZSHOrderPayCellID = @"ZSHOrderPayCell";
@implementation ZSHConfirmOrderViewController

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
    self.title = @"确认订单";
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight - KBottomNavH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView setSeparatorColor:KZSHColor1D1D1D];
    
    [self.tableView registerClass:[ZSHOrderUserInfoCell class] forCellReuseIdentifier:ZSHOrderUserInfoCellID];
    [self.tableView registerClass:[ZSHGoodsDetailCell class] forCellReuseIdentifier:ZSHGoodsDetailCellID];
    [self.tableView registerClass:[ZSHOrderPayCell class] forCellReuseIdentifier:ZSHOrderPayCellID];
    
    [self.tableView reloadData];
    
    [self.view addSubview:self.bottomBtn];
    [self.bottomBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.bottomBtn addTarget:self action:@selector(placeOrderBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeUserInfoSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeGoodsDetailSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeCountSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storeCouponSection]];
     [self.tableViewModel.sectionModelArray addObject:[self storePriceSection]];
    [self.tableViewModel.sectionModelArray addObject:[self storePaySection]];
}

//第一组：个人信息
- (ZSHBaseTableViewSectionModel*)storeUserInfoSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(75);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHOrderUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHOrderUserInfoCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            cell.fromClassType = ZSHFromConfirmOrderVCToGoodsDetailCell;
            [cell updateCellWithModel:self.goodsModel];
            return cell;
        };

        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {

        };
    return sectionModel;
}

//购买数量
- (ZSHBaseTableViewSectionModel*)storeCountSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(40);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZSHGoodsCouponCellID];
        cell.textLabel.text = @"购买数量";
        JSNummberCount *countBtn = [[JSNummberCount alloc]initWithFrame:CGRectZero];
        [cell.contentView addSubview:countBtn];
        [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell).offset(-KLeftMargin);
            make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(15)));
            make.centerY.mas_equalTo(cell);
        }];
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

//优惠券
- (ZSHBaseTableViewSectionModel*)storeCouponSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(40);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHGoodsCouponCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"优惠券";
        cell.detailTextLabel.text = @"无可用";
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

//总金额
- (ZSHBaseTableViewSectionModel*)storePriceSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(40);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHGoodsCouponCellID];
        cell.textLabel.text = @"总金额";
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"¥ %.1f",[_goodsModel.price floatValue]];
        cell.detailTextLabel.font = kPingFangMedium(17);
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

//支付方式
- (ZSHBaseTableViewSectionModel*)storePaySection {
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *titleCellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:titleCellModel];
    titleCellModel.height = kRealValue(40);
    titleCellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ZSHGoodsCouponCellID];
        cell.textLabel.text = @"支付方式";
         [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
        return cell;
    };
    
    
    NSArray *paramArr = @[
      @{@"payImage":@"pay_wechat",@"title":@"微信支付",@"btnTag":@(1),@"btnNormalImage":@"pay_btn_normal",@"btnPressImage":@"pay_btn_press"},
     @{@"payImage":@"pay_alipay",@"title":@"支付宝支付",@"btnTag":@(2),@"btnNormalImage":@"pay_btn_normal",@"btnPressImage":@"pay_btn_press"}];
    for (int i = 0; i<2; i++) {
        ZSHBaseTableViewCellModel *payCellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:payCellModel];
        payCellModel.height = kRealValue(40);
        payCellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHOrderPayCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHOrderPayCellID forIndexPath:indexPath];
            [cell updateCellWithParamDic:paramArr[i]];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
            return cell;
        };
    }
    
    return sectionModel;
}

- (void)placeOrderBtnAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
