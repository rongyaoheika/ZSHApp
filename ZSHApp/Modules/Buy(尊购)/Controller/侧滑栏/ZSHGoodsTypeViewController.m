//
//  ZSHGoodsTypeViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsTypeViewController.h"
#import "ZSHGoodModel.h"
#import "ZSHGoodsCell.h"
#import "ZSHGoodsDetailViewController.h"
#import "ZSHBuyLogic.h"


@interface ZSHGoodsTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/* 推荐商品属性 */
@property (strong, nonatomic) NSMutableArray <ZSHGoodModel *> *goodModelArr;
@property (nonatomic, strong) ZSHBuyLogic                     *buyLogic;

@end

static NSString * cellIdentifier = @"ZSHGoodsCell";
static NSString * ZSHBottomListCellID = @"ZSHBottomListCell";

@implementation ZSHGoodsTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
   _cellType = [self.paramDic[@"cellType"] integerValue];
//   _goodModelArr = [ZSHGoodModel mj_objectArrayWithFilename:@"YouLikeGoods.plist"];
    if (self.cellType == ZSHTableViewCellType) {
        [self initViewModel];
    }
    
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [self requestData];
}

- (void)createUI{
    if (self.cellType == ZSHTableViewCellType) {
        self.collectionView.hidden = YES;
        self.tableView.hidden = NO;
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        self.tableView.delegate = self.tableViewModel;
        self.tableView.dataSource = self.tableViewModel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView setSeparatorColor:KZSHColor1D1D1D];
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(kRealValue(185), kRealValue(270));
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
}

#pragma collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _goodModelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (![cell.contentView viewWithTag:2]) {
        ZSHGoodsCell *cellView = [[ZSHGoodsCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(270)) paramDic:nil];
        cellView.tag = 2;
        cellView.goodModel = _goodModelArr[indexPath.row];
        cellView.cellType = ZSHCollectionViewCellType;
        [cell.contentView addSubview:cellView];
    }
   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZSHGoodsDetailViewController *goodsDetailVC = [[ZSHGoodsDetailViewController alloc]init];
    goodsDetailVC.goodModel = _goodModelArr[indexPath.row];
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

//tableview
- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.tableView registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBottomListCellID];
}

- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < _goodModelArr.count; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.height = kRealValue(100);
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBottomListCellID forIndexPath:indexPath];
            if (![cell.contentView viewWithTag:3]) {
                ZSHGoodsCell *cellView = [[ZSHGoodsCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealValue(100)) paramDic:nil];
                cellView.tag = 3;
                cellView.goodModel = _goodModelArr[indexPath.row];
                cellView.cellType = ZSHTableViewCellType;
                [cell.contentView addSubview:cellView];
            }
            
            return cell;
        };
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHGoodsDetailViewController *goodsDetailVC = [[ZSHGoodsDetailViewController alloc]init];
            goodsDetailVC.goodModel = _goodModelArr[indexPath.row];
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        };
    }
    return sectionModel;
}

- (void)reloadUIWithCellType:(ZSHCellType)cellType{
    self.cellType = cellType;
    if (cellType == ZSHTableViewCellType) {
        [self initViewModel];
    }
    [self createUI];
}

- (void)requestData {
    kWeakSelf(self);
    
    if (kFromClassTypeValue == 2) {
        return;
    }
    
    [_buyLogic requestShipPrefectureWithBrandID:self.paramDic[@"PreBrandID"] success:^(id response) {
        _goodModelArr = [ZSHGoodModel mj_objectArrayWithKeyValuesArray:response[@"pd"]];
        if (weakself.cellType == ZSHTableViewCellType) {
            [weakself initViewModel];
        } else {
            [weakself.collectionView reloadData];
        }
        
    }];
}

@end
