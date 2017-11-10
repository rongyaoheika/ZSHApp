//
//  ZSHExchangeViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHExchangeViewController.h"
#import "ZSHIntegralExchangeCell.h"
#import "ZSHIntegralExchangeCell.h"
#import "ZSHBottomBlurPopView.h"

@interface ZSHExchangeViewController ()

@property (nonatomic, strong) ZSHBottomBlurPopView      *bottomBlurPopView;

@end

static NSString *ZSHIntegralExchangeCellID = @"ZSHIntegralExchangeCell";

@implementation ZSHExchangeViewController

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
    self.title = @"积分兑换";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, 0, 0));
    }];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHIntegralExchangeCell class] forCellReuseIdentifier:ZSHIntegralExchangeCellID];
    [self.tableView reloadData];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(10);
    
    for (int i = 0; i < 3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(127);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHIntegralExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHIntegralExchangeCellID forIndexPath:indexPath];
            cell.exchangeBlock = ^{
                [kAppDelegate.window addSubview:weakself.bottomBlurPopView];
            };
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (ZSHBottomBlurPopView *)bottomBlurPopView{
    //    if (!_bottomBlurPopView) {//无法彻底释放
     NSDictionary *nextParamDic = @{@"fromClassType":@(ZSHFromExchangeVCToBottomBlurPopView)};
    _bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    _bottomBlurPopView.blurRadius = 20;
    _bottomBlurPopView.dynamic = NO;
    _bottomBlurPopView.tintColor = KClearColor;
    //    }
    return _bottomBlurPopView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
