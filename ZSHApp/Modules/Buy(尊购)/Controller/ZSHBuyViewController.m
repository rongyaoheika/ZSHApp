//
//  ZSHBuyViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
// cgh rebase

#import "ZSHBuyViewController.h"
#import "ZSHCycleScrollView.h"
#import "ZSHGoodsListView.h"
#import "ZSHLeftContentViewController.h"
#import "RXLSideSlipViewController.h"
#import "ZSHGoodsListView.h"
#import "ZSHGoodsTitleContentViewController.h"
#import "ZSHBuyLogic.h"
#import "ZSHGuideView.h"

static NSString *Identify_headCell = @"headCell";
static NSString *Identify_listLeftImageCell = @"listLeftImageCell";
static NSString *Identify_listRightImageCell = @"listRightImageCell";
static NSString *ZSHGoodsListViewID = @"ZSHGoodsListView";

@interface ZSHBuyViewController ()

@property (nonatomic, strong) ZSHBuyLogic           *buyLogic;
@property (nonatomic, strong) ZSHGuideView          *guideView;

@end

@implementation ZSHBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self createUI];
}

- (void)loadData{
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [self initViewModel];
    [self requestCarouselFigure];
}

- (void)createUI{
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHGoodsListView class] forCellReuseIdentifier:Identify_listLeftImageCell];
    [self.tableView registerClass:[ZSHGoodsListView class] forCellReuseIdentifier:Identify_listRightImageCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomTabH, 0));
    }];
    self.tableView.tableHeaderView = self.guideView;
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
    
    NSArray *imageArr = @[@"buy_watch",@"buy_bag",@"buy_bracelet",@"buy_car",@"buy_goft",@"buy_plane",@"buy_camera"];
    NSArray *titleArr = @[@"手表专区",@"包袋专区",@"首饰专区",@"豪车世界",@"高尔夫汇",@"飞机游艇",@"家电数码"];
    NSArray *brandIDArr = @[@"1b4ed4c57ef04933b97e8def48fc423a",
                            @"a34d1f14a4b7481e8284ad4ba97a496b",
                            @"2df2c7e628b14341be1e2932cb377c82",
                            @"c387f598e5c64a1ea275a7ca3e77518c",
                            @"",
                            @"668b21fc68a44080899cfd840107af22",
                            @"a1d59672053f45e1a5499fb1d5850144"
                            ];
    for (int i = 0; i < imageArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(140);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            static NSString *identifier;
            if (indexPath.row%2) {
                identifier = Identify_listLeftImageCell;
            } else {
                identifier = Identify_listRightImageCell;
            }
            ZSHGoodsListView *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            NSDictionary *nextParamDic = @{@"goodsImageName":imageArr[i],@"goodsName":titleArr[i],@"row":@(indexPath.row)};
            [cell updateCellWithParamDic:nextParamDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"PreBrandID":brandIDArr[indexPath.row],
                                  KFromClassType:@(FromBuyVCToGoodsTitleVC)
                                   }];
            [weakself.navigationController pushViewController:goodContentVC animated:YES];
        };
    }
    
    return sectionModel;
}

- (ZSHGuideView *)guideView {
    if(!_guideView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(kRealValue(175)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
        _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(175)) paramDic:nextParamDic];
    }
    return _guideView;
}

- (void)requestCarouselFigure {
    kWeakSelf(self);
   [_buyLogic requestScarouselfigure:^(id response) {
       NSArray *imageArr = response[@"pd"][@"SHOWIMAGES"];
       if (imageArr.count) {
           [weakself.guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
       }
   }];
}

@end
