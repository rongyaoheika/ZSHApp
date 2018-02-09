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
@property (nonatomic, strong) NSArray               *dataArr;

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
    [self requestData];
}

- (void)createUI{
    
//    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavigationBarHeight - KBottomTabH);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    
    [self.tableView registerClass:[ZSHGoodsListView class] forCellReuseIdentifier:Identify_listLeftImageCell];
    [self.tableView registerClass:[ZSHGoodsListView class] forCellReuseIdentifier:Identify_listRightImageCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomTabH, 0));
    }];
    
    self.tableView.tableHeaderView = self.guideView;
    
    [self endTabViewRefresh];
    
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
    
    for (int i = 0; i < _dataArr.count; i++) {
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
            NSMutableDictionary *mutaDic = [NSMutableDictionary dictionaryWithDictionary:weakself.dataArr[indexPath.row]];
            [mutaDic setObject:@(indexPath.row) forKey:@"row"];
            [cell updateCellWithParamDic:mutaDic];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"PreBrandID":weakself.dataArr[indexPath.row][@"BRAND_ID"],
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

- (void)requestData {
    kWeakSelf(self);
    [_buyLogic requestGetFectureList:@{} success:^(id response) {
        weakself.dataArr = response[@"pd"];
        [weakself initViewModel];
    }];
}

@end
