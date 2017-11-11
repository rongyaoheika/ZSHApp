//
//  ZSHGuideViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGuideViewController.h"
#import "ZSHGuideCell.h"

@interface ZSHGuideViewController ()

// ** guide 图片* /
@property (nonatomic,weak) UIImageView *guide;

// ** guideLargeText 图片* /
@property (nonatomic,weak) UIImageView *guideLargeText;

// ** guideSmallText 图片* /
@property (nonatomic,weak) UIImageView *guideSmallText;

// ** 上次的偏移量 */
@property (nonatomic,assign) CGFloat lastOffsetX;
@end

static NSString  *ZSHGuideCellID = @"ZSHGuideCell";
@implementation ZSHGuideViewController

/**
 *  重新初始化方法· 将设置flowLayout方法封装
 *
 *  @return 已经设置好FlowLayout 的UICollectionViewController
 */
-(instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
    [self addChildView];
}

-(void)addChildView
{
    UIImageView *guide = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide1_bg"]];
    [self.collectionView addSubview:guide];
    guide.zsh_centerX = self.view.zsh_centerX;
    self.guide = guide;
    
//    UIImageView *guideLargeText = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guideLargeText1"]];
//    [self.collectionView addSubview:guideLargeText];
//    guideLargeText.zsh_centerX = self.view.zsh_centerX;
//    guideLargeText.zsh_centerY = self.view.height * 0.7;
//    self.guideLargeText = guideLargeText;
//
//    UIImageView *guideSmallText = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guideSmallText1"]];
//    [self.collectionView addSubview:guideSmallText];
//    guideSmallText.zsh_centerX = self.view.zsh_centerX;
//    guideSmallText.zsh_centerY = self.view.height * 0.8;
//    self.guideSmallText = guideSmallText;
}


-(void)setupCollectionView
{
    self.collectionView.backgroundColor = [UIColor yellowColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ZSHGuideCell class] forCellWithReuseIdentifier:ZSHGuideCellID];
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZSHGuideCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGuideCellID forIndexPath:indexPath];
    cell.image = [UIImage imageNamed:@"guide1_bg"];
    cell.page = indexPath.item + 1;
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat deltaX = currentOffsetX - self.lastOffsetX;
    
    self.guide.zsh_x += 2*deltaX;
    self.guideSmallText.zsh_x += 2*deltaX;
    self.guideLargeText.zsh_x += 2*deltaX;
    
    //更换图片
    NSInteger page = currentOffsetX / [UIScreen mainScreen].bounds.size.width + 1;
    self.guide.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%zd",page]];
//    self.guideLargeText.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideLargeText%zd",page]];
//    self.guideSmallText.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideSmallText%zd",page]];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.guide.zsh_x -= deltaX;
        self.guideSmallText.zsh_x -= deltaX;
        self.guideLargeText.zsh_x -= deltaX;
    }];
    
    self.lastOffsetX = currentOffsetX;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
