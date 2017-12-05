 //
//  ZSHOrderSubViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHOrderSubViewController.h"
#import "ZSHOrderCell.h"
#import "ZSHOrderModel.h"
#import "ZSHOrderDetailViewController.h"
#import "ZSHMineLogic.h"

static NSString *cellIdentifier = @"listCell";

@interface ZSHOrderSubViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZSHMineLogic   *mineLogic;
@property (nonatomic, strong) UIImageView    *emptyView;
@property (nonatomic, strong) UILabel        *emptyNotice;

@end

@implementation ZSHOrderSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self createUI];
}

- (void)loadData{
    _dataArr = [[NSMutableArray alloc] init];
    _mineLogic = [[ZSHMineLogic alloc] init];
    
    [self initViewModel];
    [self requestData];
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    
    _emptyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_empty"]];
    _emptyView.hidden  = false;
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(69);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(170, 165));
    }];
    
    _emptyNotice = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"没有找到你想要的～",@"font":kPingFangMedium(12),@"textColor":KZSHColor929292}];
    _emptyNotice.hidden = true;
    [self.view addSubview:_emptyNotice];
    [_emptyNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(323);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 17));
    }];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
    
    if (_dataArr.count) {
        _emptyView.hidden = true;
        _emptyNotice.hidden = true;
    } else {
        _emptyView.hidden = false;
        _emptyNotice.hidden = false;
    }
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < _dataArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
//        kWeakSelf(cellModel);
        cellModel.height = kRealValue(90);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            //无需注册，需要判空
            ZSHOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[ZSHOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            //            weakcellModel.height = [ZSHOrderCell getCellHeightWithModel:orderModel];
            ZSHBaseModel *orderModel = weakself.dataArr[indexPath.row];
            
            if ([self.paramDic[@"tag"] integerValue] == 0) {// 尊购
                [cell updateCellWithModel:orderModel];
            } else if ([self.paramDic[@"tag"] integerValue] == 3) {// 酒店订单
                [cell updateCellWithHotel:(ZSHHotelOrderModel *)orderModel];
            } else if ([self.paramDic[@"tag"] integerValue] == 4) {// KTV订单
                [cell updateCellWithKtv:(ZSHKtvOrderModel *)orderModel];
            } else if ([self.paramDic[@"tag"] integerValue] == 5) {// 美食订单
                [cell updateCellWithFood:(ZSHFoodOrderModel *)orderModel];
            } else if ([self.paramDic[@"tag"] integerValue] == 6) {// 酒吧订单
                [cell updateCellWithBarorder:(ZSHBarorderOrderModel *)orderModel];
            }
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHOrderDetailViewController *orderDetailVC = [[ZSHOrderDetailViewController alloc]init];
            [weakself.navigationController pushViewController:orderDetailVC animated:YES];
        };
    }
    
    return sectionModel;
}


- (void)requestData {
    kWeakSelf(self);
    NSArray *urls = @[@"", @"", @"", kUrlHotelOrderAllList, kUrlKtvOrderAllList, kUrlFoodOrderAllList, kUrlBarorderAllList, @""];
    if ([self.paramDic[@"tag"] integerValue] == 0) {
         if ([self.paramDic[@"ORDERSTATUS"] isEqualToString:@""]) {// 带条件查询
             [_mineLogic requestOrderAllList:^(id response) {
                 weakself.dataArr = response;
                 [weakself initViewModel];
             }];
         } else {
             [_mineLogic requestOrderConListWithOrderStatus:self.paramDic[@"ORDERSTATUS"] success:^(id response) {
                 weakself.dataArr = response;
                 [weakself initViewModel];
             }];
         }
    } else {
        [_mineLogic requestOrderWithURL:urls[[self.paramDic[@"tag"] integerValue]] orderStatus:self.paramDic[@"ORDERSTATUS"] success:^(id response) {
            weakself.dataArr = response;
            [weakself initViewModel];
        }];
    }
}

@end
