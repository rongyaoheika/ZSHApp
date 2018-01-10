//
//  ZSHGoodsViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsViewController.h"
#import "ZSHClassGoodsModel.h"
#import "ZSHClassMainModel.h"
#import "ZSHClassSubModel.h"
#import "ZSHClassCategoryCell.h"
#import "ZSHGoodsSortCell.h"
#import "ZSHBrandSortCell.h"
#import "ZSHBrandsSortHeadView.h"
#import "ZSHGoodsTitleContentViewController.h"
#import "ZSHBuyLogic.h"
#import "LXScollTitleView.h"
#import "ZSHGoodsCollectionViewCell.h"
#import "ZSHPickView.h"
#import "ZSHGuideView.h"
#import "ZSHBottomBlurPopView.h"

#define tableViewW  kRealValue(100)

@interface ZSHGoodsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

/* 左边数据 */
@property (nonatomic, strong) NSMutableArray<ZSHClassMainModel *> *titleArr;
/* 右边数据 */
@property (nonatomic, strong) NSMutableArray                      *mainArr;

@property (nonatomic, strong) ZSHBuyLogic                         *buyLogic;
@property (nonatomic, assign) NSInteger                           currentSelectIndex;
@property (nonatomic, strong) LXScollTitleView                    *titleView;
@property (nonatomic, assign) NSInteger                           index;
@property (nonatomic, strong) ZSHPickView                         *pickView;
@property (nonatomic, strong) ZSHGuideView                        *guideView;
@property (nonatomic, strong) NSArray                             *filters;

@end

static NSString *const ZSHClassCategoryCellID = @"ZSHClassCategoryCell";
static NSString *const ZSHBrandsSortHeadViewID = @"ZSHBrandsSortHeadView";
static NSString *const ZSHGoodsSortCellID = @"ZSHGoodsSortCell";
static NSString *const ZSHBrandSortCellID = @"ZSHBrandSortCell";

@implementation ZSHGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _currentSelectIndex = 0;
    if ([self.paramDic[@"currentSelectIndex"] integerValue]) {
        _currentSelectIndex = [self.paramDic[@"currentSelectIndex"] integerValue];
    }
    
    [self requestData];
    [self initViewModel];
}

- (void)createUI{
    [self.navigationItem setTitleView:self.searchView];
    self.searchView.searchBar.delegate = self;
    
    self.tableView.frame = CGRectMake(0, KNavigationBarHeight,tableViewW, kScreenHeight - KNavigationBarHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.tableViewModel;
    self.tableView.dataSource = self.tableViewModel;
    [self.tableView registerClass:[ZSHClassCategoryCell class] forCellReuseIdentifier:ZSHClassCategoryCellID];
    [self.tableView reloadData];

    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 5;          //Y
    layout.minimumInteritemSpacing = 3;     //X
    
    
    [self.view addSubview:self.titleView];
    NSArray *_titleArr = @[@"综合排序", @"销量优先", @"筛选"];
    _titleView.titleWidth = (KScreenWidth-tableViewW) /_titleArr.count;
    [self.titleView reloadViewWithTitles:_titleArr];
    
    UIButton *btn = [_titleView.titleButtons lastObject];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel_btn"]];
    imageView.frame = CGRectMake((_titleView.titleWidth+btn.titleLabel.width)/2, 0, 8, 7);
    imageView.centerY = btn.centerY;
    [btn addSubview:imageView];
    
    
    [self.view addSubview:self.guideView];
    
    
    self.collectionView.frame = CGRectMake(tableViewW, KNavigationBarHeight+kRealValue(155),kScreenWidth-tableViewW, kScreenHeight - KNavigationBarHeight-kRealValue(155));
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    
//    [self.collectionView registerClass:[ZSHGoodsSortCell class] forCellWithReuseIdentifier:ZSHGoodsSortCellID];
//    [self.collectionView registerClass:[ZSHBrandSortCell class] forCellWithReuseIdentifier:ZSHBrandSortCellID];
    [self.collectionView registerClass:[ZSHGoodsCollectionViewCell class] forCellWithReuseIdentifier:ZSHGoodsSortCellID];
    
    //注册Header
    [self.collectionView registerClass:[ZSHBrandsSortHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHBrandsSortHeadViewID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView reloadData];
}

- (ZSHGuideView *)guideView {
    if(!_guideView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(kRealValue(75)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false), @"dataArr":@[@"hotel_image", @"hotel_image"]};
        _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(tableViewW, KNavigationBarHeight+kRealValue(70), kRealValue(275), kRealValue(75)) paramDic:nextParamDic];
    }
    return _guideView;
}


//getter
- (LXScollTitleView *)titleView{
    kWeakSelf(self)
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(tableViewW, KNavigationBarHeight, KScreenWidth-tableViewW, kRealValue(70))];
        _titleView.normalTitleFont = kPingFangRegular(12);
        _titleView.selectedTitleFont = kPingFangRegular(14);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        _index = _titleView.selectedIndex;
        _titleView.selectedBlock = ^(NSInteger index){
            _index = index;
            [weakself requestConData];
        };
        
    }
    return _titleView;
}

#pragma mark - <UITableViewDelegate>
- (ZSHBaseTableViewSectionModel*)storeListSection {
    kWeakSelf(self);
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    sectionModel.headerHeight = kRealValue(10);
    for (int i = 0; i < _titleArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(45);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHClassCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHClassCategoryCellID forIndexPath:indexPath];
            cell.titleLabel.text = _titleArr[indexPath.row].BRANDBANE;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            kStrongSelf(self);
            _currentSelectIndex = indexPath.row;
            [weakself requestBrandIconListWithBrandID:_titleArr[indexPath.row]];
            [self.collectionView reloadData];
        };
    }
    return sectionModel;
}

#pragma mark - <UITableViewDataSource>
//- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return _mainArr.count;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mainArr.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSHGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsSortCellID forIndexPath:indexPath];
    [cell updateCellWithParamDic:_mainArr[indexPath.row]];
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    
//    UICollectionReusableView *reusableview = nil;
//    if (kind == UICollectionElementKindSectionHeader){
//        
//        ZSHBrandsSortHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHBrandsSortHeadViewID forIndexPath:indexPath];
//        headerView.headTitle = _mainArr[indexPath.section];
//        reusableview = headerView;
//    }
//    return reusableview;
//}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth-tableViewW, kRealValue(130));
}

//#pragma mark - head宽高
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(kScreenWidth, 25);
//}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RLog(@"点击了个第%zd分组第%zd个Item",indexPath.section,indexPath.row);
    ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"PreBrandID":_mainArr[indexPath.row][@"BUSINESS_ID"],
                                KFromClassType:@(FromGoodsVCToGoodsTitleVC),
                                @"cellType":@(ZSHCollectionViewCellType)
                                }];
    [self.navigationController pushViewController:goodContentVC animated:YES];
}

- (void)headerRereshing {
    [self requestData];
}
- (void)collectionHeaderRereshing {
    [self requestBrandIconListWithBrandID:_titleArr[_currentSelectIndex]];
}

- (void)collectionFooterRereshing {
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.collectionView.mj_footer endRefreshing];
    });
}

- (void)requestData {
    kWeakSelf(self);
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [_buyLogic requestShipBrandList:^(id response) {
        _titleArr = [ZSHClassMainModel mj_objectArrayWithKeyValuesArray:response[@"pd"]];
        [weakself initViewModel];
        //第一次加载默认选择第一行（注意一定要在加载完数据之后）
        [weakself.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentSelectIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [weakself requestBrandIconListWithBrandID:_titleArr[_currentSelectIndex]];
        [weakself.tableView.mj_header endRefreshing];
    }];
    
}

- (void)requestBrandIconListWithBrandID:(ZSHClassMainModel *)model {
    kWeakSelf(self);
    ZSHBuyLogic *logic = [[ZSHBuyLogic alloc] init];
    
    [logic requestBrandIconListWithDic:@{@"BRAND_ID":model.BRAND_ID} success:^(id response) {
        _mainArr = response[@"pd"];
        [weakself updateAd:response[@"adList"]];
        [weakself updateFilter:response[@"brandIconList"]];
        [weakself.collectionView reloadData];
        [weakself.collectionView.mj_header endRefreshing];
    }];
}

- (void)refreshBrandIconListWithBrandID:(NSString *)brandID {
    kWeakSelf(self);
    ZSHClassMainModel *model = _titleArr[_currentSelectIndex];
    [_buyLogic requestBrandIconListWithDic:@{@"BRAND_ID":model.BRAND_ID,@"BRANDICON_ID":brandID} success:^(id response) {
        _mainArr = response[@"pd"];
        [weakself.collectionView reloadData];
        [weakself.collectionView.mj_header endRefreshing];
    }];
}
- (void)requestConData {
    kWeakSelf(self);
    switch (_index) {
        case 0:{ // 综合排序
            [self requestBrandIconListWithBrandID:_titleArr[_currentSelectIndex]];
            break;
        }
        case 1:{ //
            break;
        }
        case 2:{ // 筛选
            NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromGoodsVCToBottomBlurPopView), @"filters":_filters};
            ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
            bottomBlurPopView.blurRadius = 20;
            bottomBlurPopView.dynamic = NO;
            bottomBlurPopView.tintColor = KClearColor;
            bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
            [bottomBlurPopView setBlurEnabled:NO];
            [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
            bottomBlurPopView.dissmissViewBlock = ^(UIView *blurView, NSIndexPath *indexpath) {
                [ZSHBaseUIControl setAnimationWithHidden:YES view:blurView completedBlock:^{
                    if (indexpath) {//跳转到对应控制器
                        
                        [weakself refreshBrandIconListWithBrandID:weakself.filters[indexpath.row][@"BRANDICON_ID"]];
                    }
                    return;
                }];
            };
            break;
        }
        default:
            break;
    }
}

- (void)updateAd:(NSArray *)arr {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *dic  in arr) {
        [dataArr addObject:dic[@"SHOWIMG"]];
    }
    [_guideView updateViewWithParamDic:@{@"dataArr":dataArr}];
}

- (void)updateFilter:(NSArray *)arr {
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSDictionary *dic  in arr) {
        [dataArr addObject:@{@"BRANDICON_ID":dic[@"BRANDICON_ID"], @"BRANDNAME":dic[@"BRANDNAME"]}];
    }
    _filters = dataArr.mutableCopy;
}

@end
