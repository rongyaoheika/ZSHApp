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

#define tableViewW  kRealValue(100)

@interface ZSHGoodsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

/* 左边数据 */
@property (nonatomic, strong) NSMutableArray<ZSHClassMainModel *> *titleArr;
/* 右边数据 */
@property (nonatomic, strong) NSMutableArray<ZSHClassSubModel *>  *mainArr;

@property (nonatomic, strong) ZSHBuyLogic                         *buyLogic;
@property (nonatomic, assign) NSInteger                           currentSelectIndex;
@property (nonatomic, strong) LXScollTitleView                    *titleView;
@property (nonatomic, assign) NSInteger                           index;
@property (nonatomic, strong) ZSHPickView                         *pickView;


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
    
    self.collectionView.frame = CGRectMake(tableViewW, KNavigationBarHeight+kRealValue(40),kScreenWidth-tableViewW, kScreenHeight - KNavigationBarHeight-kRealValue(40));
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

//getter
- (LXScollTitleView *)titleView{
    kWeakSelf(self)
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(tableViewW, KNavigationBarHeight, KScreenWidth-tableViewW, kRealValue(40))];
        _titleView.normalTitleFont = kPingFangRegular(15);
        _titleView.selectedTitleFont = kPingFangRegular(16);
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

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 25);
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RLog(@"点击了个第%zd分组第%zd个Item",indexPath.section,indexPath.row);
    ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"PreBrandID":_mainArr[indexPath.row].BRAND_ID,
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
    [logic requestBrandIconListWithBrandID:model.BRAND_ID success:^(id response) {
        _mainArr = [ZSHClassSubModel mj_objectArrayWithKeyValuesArray:response[@"pd"]];
        [weakself.collectionView reloadData];
        [weakself.collectionView.mj_header endRefreshing];
        
    }];
}

- (void)requestConData {
//    kWeakSelf(self);
    switch (_index) {
        case 0:{//推荐
            break;
        }
        case 1:{//精选
            break;
        }
        case 2:{//最热
            NSDictionary *nextParamDic = @{@"type":@(WindowDefault),@"midTitle":@"筛选",@"dataArr":@[@"全部", @"名品", @"名物"]};
            _pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) paramDic:nextParamDic];
            [_pickView show:WindowDefault];
            _pickView.saveChangeBlock = ^(NSString *rowTitle, NSInteger tag) {
            };
            break;
        }
        case 3:{//最新
            break;
        }
        default:
            break;
    }
}

@end
