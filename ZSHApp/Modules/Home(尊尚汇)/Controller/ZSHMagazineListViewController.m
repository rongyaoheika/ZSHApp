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

static NSString * ZSHMagazineCellID = @"ZSHMagazineCellID";

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
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"magazineHead"]];
    [self.view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *designerLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"设计师", @"font":kPingFangMedium(15)}];
    [self.view addSubview:designerLabel];
    [designerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom).offset(25);
        make.left.mas_equalTo(self.view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), 16));
    }];
    
    UIButton *joinBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"入驻",@"font":kPingFangRegular(12)}];
    [self.view addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-kRealValue(KLeftMargin));
        make.centerY.mas_equalTo(designerLabel);
        make.size.mas_equalTo(CGSizeMake(kRealValue(25), 13));
    }];
    
    NSArray *namesArr = @[@"Ronald", @"Andrew", @"Herbert", @"Frederick", @"Potter"];
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSStringFormat(@"designer%d", i+1)]];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(designerLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(self.view).offset(kRealValue(KLeftMargin+(35.5+45)*i));
            make.size.mas_equalTo(CGSizeMake(kRealValue(45), kRealValue(45)));
        }];
        
        UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":namesArr[i], @"font":kPingFangRegular(14), @"textAlignment":@(NSTextAlignmentCenter)}];
        [self.view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).offset(7.5);
            make.centerX.mas_equalTo(imageView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(70), kRealValue(15)));
        }];
    }
    
    UILabel *magazineLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"设计师", @"font":kPingFangMedium(15)}];
    [self.view addSubview:magazineLabel];
    [magazineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(designerLabel.mas_bottom).offset(106.5);
        make.left.mas_equalTo(self.view).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), 16));
    }];
    
    self.collectionView.frame = CGRectMake(0, KNavigationBarHeight+kRealValue(210), kScreenWidth, kScreenHeight - KNavigationBarHeight-kRealValue(210)-KBottomTabH);
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerClass:[ZSHMagazineListCell class] forCellWithReuseIdentifier:ZSHMagazineCellID];
    
    
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
    return CGSizeMake(kScreenWidth/2-8, kRealValue(274));
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
    NSDictionary *dic = @{@"MAGAZINE_ID":@"398896682013556736", @"MAGAZINETYPE":@"1"};
    ZSHMagazineViewController *magazineVC = [[ZSHMagazineViewController alloc] initWithParamDic:@{@"magazine":dic}];
    [self.navigationController pushViewController:magazineVC animated:YES];
}

- (void)collectionHeaderRereshing {
    [self.collectionView.mj_header endRefreshing];
}
- (void)collectionFooterRereshing {
    [self.collectionView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
