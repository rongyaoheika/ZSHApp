//
//  ZSHMagazineListViewController.m
//  ZSHApp
//
//  Created by mac on 10/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHMagazineListViewController.h"
#import "ZSHMagazineListCell.h"
#import "ZSHMagazineViewController.h"
#import "ZSHMagazineReusableView.h"

static NSString * ZSHMagazineCellID = @"ZSHMagazineCellID";
static NSString * ZSHMagazineReusableHeadID = @"ZSHMagazineReusableHeadID";

@interface ZSHMagazineListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSArray *mainArr;

@end

@implementation ZSHMagazineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData {
    NSArray *titles = @[@"国家地理", @"时尚芭莎", @"瑞丽", @"时代周刊", @"中国烹饪", @"环球人物", @"商界", @"财经"];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<titles.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:titles[i] forKey:@"title"];
        [dic setValue:NSStringFormat(@"magazine%d", i) forKey:@"image"];
        [arr addObject:dic];
    }
    _mainArr = arr.mutableCopy;
    [self.collectionView reloadData];
}

- (void)createUI {
    
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KNavigationBarHeight-kRealValue(35                                                                                                                                                                              ));
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerClass:[ZSHMagazineListCell class] forCellWithReuseIdentifier:ZSHMagazineCellID];
    [self.collectionView registerClass:[ZSHMagazineReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHMagazineReusableHeadID];
    
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mainArr.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSHMagazineListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHMagazineCellID forIndexPath:indexPath];
    [cell updateCellWithParamDic:_mainArr[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        ZSHMagazineReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHMagazineReusableHeadID forIndexPath:indexPath];
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/2-8, kRealValue(274));
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 300);
}



#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RLog(@"点击了个第%zd分组第%zd个Item",indexPath.section,indexPath.row);
    NSDictionary *dic = @{@"MAGAZINE_ID":@"398896682013556736", @"MAGAZINETYPE":@"1"};
    ZSHMagazineViewController *magazineVC = [[ZSHMagazineViewController alloc] initWithParamDic:@{@"magazine":dic}];
    [self.navigationController pushViewController:magazineVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
