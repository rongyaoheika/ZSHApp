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
#import "ZSHClassCategoryCell.h"
#import "ZSHGoodsSortCell.h"
#import "ZSHBrandSortCell.h"
#import "ZSHBrandsSortHeadView.h"
#import "ZSHGoodsTitleContentViewController.h"

#define tableViewW  kRealValue(100)

@interface ZSHGoodsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate>

/* 左边数据 */
@property (nonatomic, strong)NSMutableArray<ZSHClassGoodsModel *> *titleArr;
/* 右边数据 */
@property (nonatomic, strong)NSMutableArray<ZSHClassMainModel *>  *mainArr;

@end

static NSString *const ZSHClassCategoryCellID = @"ZSHClassCategoryCell";
static NSString *const ZSHBrandsSortHeadViewID = @"ZSHBrandsSortHeadView";
static NSString *const ZSHGoodsSortCellID = @"ZSHGoodsSortCell";
static NSString *const ZSHBrandSortCellID = @"ZSHBrandSortCell";

@implementation ZSHGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    _titleArr = [ZSHClassGoodsModel mj_objectArrayWithFilename:@"ClassifyTitles.plist"];
    _mainArr = [ZSHClassMainModel mj_objectArrayWithFilename:@"ClassiftyGoods01.plist"];
    
    
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
    //默认选择第一行（注意一定要在加载完数据之后）
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 5;          //Y
    layout.minimumInteritemSpacing = 3;     //X
    
    self.collectionView.frame = CGRectMake(tableViewW, KNavigationBarHeight,kScreenWidth-tableViewW, kScreenHeight - KNavigationBarHeight);
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerClass:[ZSHGoodsSortCell class] forCellWithReuseIdentifier:ZSHGoodsSortCellID];
    [self.collectionView registerClass:[ZSHBrandSortCell class] forCellWithReuseIdentifier:ZSHBrandSortCellID];
    
    //注册Header
    [self.collectionView registerClass:[ZSHBrandsSortHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHBrandsSortHeadViewID];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
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
            cell.titleItem = _titleArr[indexPath.row];
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            kStrongSelf(self);
            _mainArr = [ZSHClassMainModel mj_objectArrayWithFilename:_titleArr[indexPath.row].fileName];
            [self.collectionView reloadData];
        };
    }
    return sectionModel;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mainArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mainArr[section].goods.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if ([_mainArr[_mainArr.count - 1].title isEqualToString:@"热门品牌"]) {
        if (indexPath.section == _mainArr.count - 1) {//品牌
            ZSHBrandSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHBrandSortCellID forIndexPath:indexPath];
            cell.subItem = _mainArr[indexPath.section].goods[indexPath.row];
            gridcell = cell;
        } else {//商品
            ZSHGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsSortCellID forIndexPath:indexPath];
            cell.subItem = _mainArr[indexPath.section].goods[indexPath.row];
            gridcell = cell;
        }
    } else {//商品
        ZSHGoodsSortCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsSortCellID forIndexPath:indexPath];
        cell.subItem = _mainArr[indexPath.section].goods[indexPath.row];
        gridcell = cell;
    }
    
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        ZSHBrandsSortHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHBrandsSortHeadViewID forIndexPath:indexPath];
        headerView.headTitle = _mainArr[indexPath.section];
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_mainArr[_mainArr.count - 1].title isEqualToString:@"热门品牌"]) {
        if (indexPath.section == _mainArr.count - 1) {//品牌
            return CGSizeMake((kScreenWidth - tableViewW - 6)/3, 60);
        }else{//商品
            return CGSizeMake((kScreenWidth - tableViewW - 6)/3, (kScreenWidth - tableViewW - 6)/3 + 20);
        }
    }else{
        return CGSizeMake((kScreenWidth - tableViewW - 6)/3, (kScreenWidth - tableViewW - 6)/3 + 20);
    }
    return CGSizeZero;
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
    ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]init];
    [self.navigationController pushViewController:goodContentVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
