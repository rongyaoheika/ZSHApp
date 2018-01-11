//
//  ZSHCabinetViewController.m
//  ZSHApp
//
//  Created by mac on 11/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHCabinetViewController.h"
#import "ZSHCabinetViewController.h"
#import "ZSHCabinetReusableView.h"
#import "ZSHCabinetCollectionCell.h"
#import "ZSHCabinetHeadReusableView.h"

static NSString * ZSHCabinetCellID = @"ZSHCabinetCellID";
static NSString * ZSHCabinetReusableHeadID = @"ZSHCabinetReusableHeadID";
static NSString * ZSHCabinetHeadReusableViewID = @"ZSHCabinetHeadReusableView";

@interface ZSHCabinetViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property(nonatomic, strong) NSArray<NSArray *> *mainArr;

@end

@implementation ZSHCabinetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData {

    NSArray *contents = @[@[@"三亚新光天地店", @"昆明金格汇都店", @"苏州美罗店", @"重庆万象城店"],
                        @[@"北京东方新天地店", @"重庆时代广场店", @"成都IFS店", @"深圳益田店"]
                        ];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<contents.count; i++) {
        NSArray *subContents = contents[i];
        NSMutableArray *subarr = [NSMutableArray array];
        for (int j = 0; j<subContents.count; j++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:subContents[j] forKey:@"title"];
            [dic setValue:NSStringFormat(@"Cabinet%d%d", i,j) forKey:@"image"];
            [subarr addObject:dic];
        }
        [arr addObject:subarr];
    }
    _mainArr = arr.mutableCopy;
    [self.collectionView reloadData];
}

- (void)createUI {
    
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavigationBarHeight-kRealValue(35                                                                                                                                                                              )-KBottomTabH);
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[ZSHCabinetCollectionCell class] forCellWithReuseIdentifier:ZSHCabinetCellID];
    [self.collectionView registerClass:[ZSHCabinetReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHCabinetReusableHeadID];
    [self.collectionView registerClass:[ZSHCabinetHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHCabinetHeadReusableViewID];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _mainArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mainArr[section].count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSHCabinetCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHCabinetCellID forIndexPath:indexPath];
    [cell updateCellWithParamDic:_mainArr[indexPath.section][indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            ZSHCabinetHeadReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHCabinetHeadReusableViewID forIndexPath:indexPath];
            reusableview = headerView;
        } else {
            ZSHCabinetReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHCabinetReusableHeadID forIndexPath:indexPath];
            NSArray *titles = @[@"GUCCI旗舰店", @"BURBERRY旗舰店"];
            headerView.headLabel.text = titles[indexPath.section];
            reusableview = headerView;
        }
        
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/2-8, kRealValue(224));
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 57+259);
    } else
        return CGSizeMake(kScreenWidth, 57);
}


#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RLog(@"点击了个第%zd分组第%zd个Item",indexPath.section,indexPath.row);
}



- (void)collectionHeaderRereshing {
    [self.collectionView.mj_header endRefreshing];
}

- (void)collectionFooterRereshing {
    [self.collectionView.mj_footer endRefreshing];
}

@end
