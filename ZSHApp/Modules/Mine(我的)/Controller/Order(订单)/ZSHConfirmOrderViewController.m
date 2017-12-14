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
#import "ZSHPayView.h"
#import "JSNummberCount.h"
#import "ZSHMineLogic.h"
#import "ZSHManageAddressListViewController.h"

@interface ZSHConfirmOrderViewController ()

@property (nonatomic, strong) ZSHPayView         *payView;
@property (nonatomic, strong) ZSHMineLogic       *mineLogic;
@property (nonatomic, assign) NSInteger          currentAddrIndex;

@end

static NSString *ZSHOrderUserInfoCellID = @"ZSHOrderUserInfoCell";
static NSString *ZSHGoodsDetailCellID = @"ZSHGoodsDetailCell";
static NSString *ZSHGoodsCouponCellID = @"ZSHGoodsCouponCell";
static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation ZSHConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self initViewModel];
    _mineLogic = [[ZSHMineLogic alloc] init];
    _mineLogic.buyOrderModel = [[ZSHBuyOrderModel alloc] init];
    _currentAddrIndex = 0;
    [self requestAddr];
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
     [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHGoodsCouponCellID];
    
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
    
    kWeakSelf(self);
    NSDictionary *nextParamDic = @{@"title":@"支付方式"};
     _payView = [[ZSHPayView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(40)) paramDic:nextParamDic];
    [self.tableViewModel.sectionModelArray addObject:[_payView storePaySection]];
    _payView.rightBtnBlcok = ^(UIButton *btn) {
        [weakself rightBtnAction:btn];
    };
    [self.tableView reloadData];
}

//第一组：个人信息
- (ZSHBaseTableViewSectionModel*)storeUserInfoSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
    [sectionModel.cellModelArray addObject:cellModel];
    cellModel.height = kRealValue(75);
    kWeakSelf(self);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHOrderUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHOrderUserInfoCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (_mineLogic.addrModelArr.count) {
            [cell updateCellWithModel:_mineLogic.addrModelArr[weakself.currentAddrIndex]];
        }
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        [weakself pushAddAddr];
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
    kWeakSelf(self);
    cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.textLabel.text = @"购买数量";
        if (![cell.contentView viewWithTag:2]) {
            JSNummberCount *countBtn = [[JSNummberCount alloc]initWithFrame:CGRectZero];
            countBtn.tag = 2;
            countBtn.currentCountNumber = [weakself.goodsModel.count integerValue];
            countBtn.numberTT.text = weakself.goodsModel.count;
            countBtn.NumberChangeBlock = ^(NSInteger count) {
                weakself.goodsModel.count = NSStringFormat(@"%zd", count);
                [weakself initViewModel];
            };
            [cell.contentView addSubview:countBtn];
            [countBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell).offset(-KLeftMargin);
                make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(15)));
                make.centerY.mas_equalTo(cell);
            }];
        }
        
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
        ZSHBaseCell *cell = [[ZSHBaseCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
        cell.textLabel.text = @"总金额";
        cell.detailTextLabel.text =  [NSString stringWithFormat:@"¥ %.1f",[_goodsModel.PROPRICE floatValue]*[_goodsModel.count floatValue]];
        cell.detailTextLabel.font = kPingFangMedium(17);
        return cell;
    };
    
    cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
        
    };
    return sectionModel;
}

#pragma  action
- (void)requestAddr {
    kWeakSelf(self);
    [_mineLogic requestShipAdr:HONOURUSER_IDValue success:^(id response) {
        if (weakself.mineLogic.addrModelArr.count) {
            [weakself initViewModel];
        } else {
            [weakself pushAddAddr];
        }
    }];
}

- (void)pushAddAddr {
    kWeakSelf(self);
    ZSHManageAddressListViewController *addAddr = [[ZSHManageAddressListViewController alloc] init];
    addAddr.getIndex = ^(NSInteger index) {
        weakself.currentAddrIndex = index;
        [weakself requestAddr];
    };
    [self.navigationController pushViewController:addAddr animated:true];
}


- (void)placeOrderBtnAction{
    if ([SafeStr(_mineLogic.buyOrderModel.ORDERADDRESS) isEqualToString:@""] ||
        [SafeStr(_mineLogic.buyOrderModel.ORDERMONEY) isEqualToString:@""] ||
        [SafeStr(_mineLogic.buyOrderModel.ORDERDELIVERY) isEqualToString:@""] ||
        [SafeStr(_mineLogic.buyOrderModel.HONOURUSER_ID)  isEqualToString:@""] ||
        [SafeStr(_mineLogic.buyOrderModel.PRODUCT_ID)  isEqualToString:@""] ||
        [SafeStr(_mineLogic.buyOrderModel.PRODUCTCOUNT)  isEqualToString:@""]) {
//        return;
    }
    kWeakSelf(self);
    _mineLogic.buyOrderModel.ORDERADDRESS = _mineLogic.addrModelArr[_currentAddrIndex].ADDRESS_ID;
    _mineLogic.buyOrderModel.ORDERMONEY = NSStringFormat(@"%f", [_goodsModel.PROPRICE doubleValue] *[_goodsModel.count floatValue]);
    _mineLogic.buyOrderModel.ORDERDELIVERY = @"顺丰";
    _mineLogic.buyOrderModel.HONOURUSER_ID = HONOURUSER_IDValue;
    _mineLogic.buyOrderModel.PRODUCT_ID = _goodsModel.PRODUCT_ID;
    _mineLogic.buyOrderModel.PRODUCTCOUNT = _goodsModel.count;
    [_mineLogic requestShipOrderWithModel:_mineLogic.buyOrderModel success:^(id response) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakself.navigationController popViewControllerAnimated:true];
        }];
        [ac addAction:cancelAction];
        [weakself presentViewController:ac animated:YES completion:nil];
    }];
    
}

- (void)rightBtnAction:(UIButton *)rightBtn{
    ZSHBaseCell *cell = (ZSHBaseCell *)[[rightBtn superview] superview];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    // 记录下当前的IndexPath.row
    _payView.selectedCellRow = path.row;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:path.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


@end
