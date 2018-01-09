//
//  ZSHRecommendView.m
//  ZSHApp
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHRecommendView.h"

@interface ZSHRecommendView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) NSMutableArray            *dataArr;
@end

@implementation ZSHRecommendView

-(void)setup{
    _dataArr = [[NSMutableArray alloc]init];
    if (kFromClassTypeValue == 0) {//首页
        for (int i = 10; i<18; i++) {
            NSString *imageName = [NSString stringWithFormat:@"search_image_%zd",i];
            [_dataArr addObject:imageName];
        }
    } else {//尊购
        for (int i = 18; i<26; i++) {
            NSString *imageName = [NSString stringWithFormat:@"search_image_%zd",i];
            [_dataArr addObject:imageName];
        }
    }
   
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(25, 5, 0, 5);
    layout.itemSize = CGSizeMake((KScreenWidth - 15)/2, kRealValue(120));
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 5.0;
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadViewID"];
    [self addSubview:self.collectionView];
    
}

#pragma collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadViewID" forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionHeader){
        NSDictionary *headTitleParamDic = @{@"text":@"为您推荐",@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentLeft)};
        UIView *headView = [ZSHBaseUIControl createTabHeadLabelViewWithParamDic:headTitleParamDic];
        headView.frame = CGRectMake(0, 0, KScreenWidth, kRealValue(50));
        [reusableview addSubview:headView];
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(kScreenWidth,kRealValue(50));
    }
    return CGSizeMake(0, 0);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
    UIImageView *cellIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_dataArr[indexPath.item]]];
    cellIV.layer.cornerRadius = 5.0;
    cellIV.clipsToBounds = YES;
    [cell.contentView addSubview:cellIV];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RLog(@"点击cell");
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth , KScreenHeight*0.5) collectionViewLayout:flow];
        _collectionView.backgroundColor = KClearColor;
        _collectionView.scrollsToTop = YES;
        
    }
    return _collectionView;
}

@end
