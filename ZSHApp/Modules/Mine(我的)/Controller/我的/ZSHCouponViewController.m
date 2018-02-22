//
//  ZSHCouponViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCouponViewController.h"
#import "ZSHIntegralExchangeCell.h"
#import "ZSHMineLogic.h"

@interface ZSHCouponViewController ()

@property (nonatomic, strong) ZSHMineLogic            *mineLogic;
@property (nonatomic, strong) NSArray                 *couponArr;

@end

@implementation ZSHCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _mineLogic = [[ZSHMineLogic alloc] init];
    
    [self initViewModel];
    [self requestData];
}

- (void)createUI{
    self.title = @"优惠券";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(10);
    
    for (int i = 0; i < _couponArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(127);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            static NSString *identifier = @"exchangeCell";
            ZSHIntegralExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ZSHIntegralExchangeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:identifier];
            }
//            NSDictionary *nextParamDic= @{KFromClassType:@(FromCouponVCToIntegralExchangeCell)};
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:weakself.couponArr[indexPath.row]];
            [mutDic setObject:@(FromCouponVCToIntegralExchangeCell) forKey:KFromClassType];
            [cell updateCellWithParamDic:mutDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (void)requestData {
    kWeakSelf(self);
    [_mineLogic requestCouponList:@{@"BUSINESS_ID":@"system"} success:^(id response) {
        weakself.couponArr = response[@"pd"];
        [weakself initViewModel];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
