//
//  ZSHMineCouponViewController.m
//  ZSHApp
//
//  Created by mac on 08/02/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHMineCouponViewController.h"
#import "ZSHMineLogic.h"

@interface ZSHMineCouponViewController ()
@property (nonatomic, strong) ZSHMineLogic            *mineLogic;
@property (nonatomic, strong) NSArray                 *couponArr;
@end

@implementation ZSHMineCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(10);
    
    for (int i = 0; i < 5; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(180);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            static NSString *identifier = @"exchangeCell";
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ZSHBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            if (![cell viewWithTag:11]) {
                UIImageView *centerIV = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 10, kRealValue(320), 180)];
                centerIV.tag = 11;
                [cell addSubview:centerIV];
            }
            UIImageView *centerIV = [cell viewWithTag:11];
            centerIV.image =  [UIImage imageNamed:NSStringFormat(@"coupon%d",i)];
            
            if (![cell viewWithTag:12]) {
                UIImageView *identifierIV = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 10, 20, 20)];
                identifierIV.tag = 12;
                [cell addSubview:identifierIV];
            }
            
            UIImageView *identifierIV = [cell viewWithTag:12];
            identifierIV.image = [UIImage imageNamed:@"offical"];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (void)requestData {
//    kWeakSelf(self);
//    [_mineLogic requestCouponList:@{@"BUSINESS_ID":@"system"} success:^(id response) {
//        weakself.couponArr = response[@"pd"];
//        [weakself initViewModel];
//    }];
}


@end
