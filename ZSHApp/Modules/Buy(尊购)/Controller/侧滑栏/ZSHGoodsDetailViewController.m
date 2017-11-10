//
//  ZSHGoodsDetailViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "ZSHGoodsDetailShufflingHeadView.h"
#import "ZSHDetailGoodReferralCell.h"
#import "ZSHGoodsDetailColorCell.h"
#import "ZSHGoodsDetailCountCell.h"
#import "ZSHConfirmOrderViewController.h"
#import "ZSHGoodModel.h"
#import "ZSHGoodsSubViewController.h"
#import "ZSHGoodsDetailSubViewController.h"
#import "ZSHGoodsCommentSubViewController.h"


@interface ZSHGoodsDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray                        *titleArr;
@property (nonatomic, strong) LXScollTitleView               *titleView;
@property (nonatomic, strong) LXScrollContentView            *contentView;
@property (nonatomic, strong) NSArray                        *contentVCS;
@property (nonatomic, assign) CGFloat                        titleWidth;
@property (nonatomic, strong) NSMutableArray                 *vcs;
@property (nonatomic, strong) UIView                         *bottomView;
@property (nonatomic, strong) UIView                         *lineTitleView;
@end

//header
static NSString *ZSHDetailShufflingHeadViewID = @"ZSHDetailShufflingHeadView";
static NSString *ZSHDetailTitleHeadViewID = @"ZSHDetailTitleHeadView";

//cell
static NSString *ZSHDetailGoodReferralCellID = @"ZSHDetailGoodReferralCell";
static NSString *ZSHDetailGoodBottomCellID = @"ZSHDetailGoodBottomCellID";
static NSString *ZSHGoodsDetailColorCellID = @"ZSHGoodsDetailColorCell";
static NSString *ZSHGoodsDetailCountCellID = @"ZSHGoodsDetailCountCell";

@implementation ZSHGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"商品",@"详情",@"评价"];
    self.titleWidth = kScreenWidth/[self.titleArr count];
    self.contentVCS = @[@"ZSHGoodsSubViewController",@"ZSHGoodsDetailSubViewController",@"ZSHGoodsCommentSubViewController"];
    
    UIImage *image = [UIImage imageNamed:@"buy_bag"];
    self.shufflingArray = @[image,image,image];
//    self.goodTitle = @"Gucci/古奇/古驰女士手拿包蓝色大LOGO";
//    self.goodSubtitle = @"Herschel Supply Co";
//    self.goodPrice = @"¥3999";
}

- (void)createUI{
    self.title = @"商品详情";
    [self addNavigationItemWithImageName:@"goods_bag" isLeft:NO target:self action:@selector(collectAction) tag:2];
    
    //头部商品展示
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumLineSpacing = 0;          //Y
    layout.minimumInteritemSpacing = 0;     //X
    
    self.collectionView.frame = CGRectMake(0, KNavigationBarHeight,kScreenWidth, kScreenHeight - KNavigationBarHeight - KBottomNavH);
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
    
    //注册Header
    [self.collectionView registerClass:[ZSHGoodsDetailShufflingHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHDetailShufflingHeadViewID];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHDetailTitleHeadViewID];
    
    //注册Cell
    [self.collectionView registerClass:[ZSHDetailGoodReferralCell class] forCellWithReuseIdentifier:ZSHDetailGoodReferralCellID];
     [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ZSHDetailGoodBottomCellID];
     [self.collectionView registerClass:[ZSHGoodsDetailColorCell class] forCellWithReuseIdentifier:ZSHGoodsDetailColorCellID];
    [self.collectionView registerClass:[ZSHGoodsDetailCountCell class] forCellWithReuseIdentifier:ZSHGoodsDetailCountCellID];
    
    [self setUpBottomButton];
}

//下半部分

#pragma getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, 5, KScreenWidth, kRealValue(40))];
        _titleView.normalTitleFont = kPingFangMedium(12);
        _titleView.selectedTitleFont = kPingFangMedium(12);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            strongSelf.contentView.currentIndex = index;
        };
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.titleWidth = self.titleWidth;
    }
    return _titleView;
}

- (LXScrollContentView *)contentView{
    if (!_contentView) {
        _contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = KClearColor;
        kWeakSelf(self);
        _contentView.scrollBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakself;
            strongSelf.titleView.selectedIndex = index;
        };
    }
    return _contentView;
}

//底部
#pragma mark - 底部按钮(客服，收藏； 加入购物车 立即购买)
- (void)setUpBottomButton
{
   self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = KZSHColor0B0B0B;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealValue(49));
        make.left.and.right.mas_equalTo(self.view);
    }];
    [self setUpLeftTwoButton];//客服，收藏
    [self setUpRightTwoButton];//加入购物车 立即购买
}

#pragma mark - 收藏 购物车
- (void)setUpLeftTwoButton
{
    NSArray *imagesNor = @[@"goods_service",@"goods_collect"];
    NSArray *imagesSel = @[@"goods_service",@"goods_collect"];
    CGFloat buttonW = kRealValue(30);
    
    for (NSInteger i = 0; i < imagesNor.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = KClearColor;
        [button setImage:[UIImage imageNamed:imagesNor[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imagesSel[i]] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = kRealValue(25) + ((buttonW +kRealValue(28))  * i);
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(buttonW, buttonW));
            make.centerY.mas_equalTo(self.bottomView);
            make.left.mas_equalTo(buttonX);
        }];
    }
}
#pragma mark - 加入购物车 立即购买
- (void)setUpRightTwoButton
{
    NSArray *titles = @[@"加入购物车",@"立即购买"];
    for (NSInteger i = 0; i < titles.count; i++) {
        NSDictionary *btnDic = @{@"title":titles[i],@"titleColor":KZSHColor929292,@"font":kPingFangMedium(17),@"backgroundColor":KClearColor};
        UIButton *button = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
        button.tag = i + 2;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(kRealValue(120));
            make.left.mas_equalTo(kRealValue(135)+i*kRealValue(120));
            make.centerY.mas_equalTo(self.bottomView);
        }];
    }
}

//上半部分

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0){
        return 3;
    } else if (section == 1){
        return 1;
    }
    return 0;
}


#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZSHDetailGoodReferralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHDetailGoodReferralCellID forIndexPath:indexPath];
            cell.goodTitleLabel.text = _goodModel.goods_title;  // _goodTitle;
            cell.goodPriceLabel.text = _goodModel.price;        //[NSString stringWithFormat:@"¥ %@",_goodPrice];
            cell.goodSubtitleLabel.text = _goodModel.main_title; //_goodSubtitle;
            gridcell = cell;
        } else if(indexPath.row == 1){
            ZSHGoodsDetailColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsDetailColorCellID forIndexPath:indexPath];
            gridcell = cell;
        } else if(indexPath.row == 2){
            ZSHGoodsDetailCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsDetailCountCellID forIndexPath:indexPath];
            gridcell = cell;
        }
    } else if(indexPath.section == 1){
        ZSHGoodsDetailColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHDetailGoodBottomCellID forIndexPath:indexPath];
        [cell.contentView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell.contentView);
        }];
        gridcell = cell;
    }
        
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            ZSHGoodsDetailShufflingHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHDetailShufflingHeadViewID forIndexPath:indexPath];
            headerView.shufflingArray = _shufflingArray;
            reusableview = headerView;
        } else if (indexPath.section == 1) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHDetailTitleHeadViewID forIndexPath:indexPath];
            [reusableview addSubview:self.lineTitleView];
            [self reloadListData];
        }
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { //商品详情
        return (indexPath.row == 0) ? CGSizeMake(kScreenWidth, [ZSHSpeedy zsh_calculateTextSizeWithText:_goodTitle WithTextFont:kPingFangMedium(12) WithMaxW:kScreenWidth*0.7].height + [ZSHSpeedy zsh_calculateTextSizeWithText:_goodSubtitle WithTextFont:kPingFangRegular(12) WithMaxW:kScreenWidth*0.7].height + kRealValue(50)) : CGSizeMake(kScreenWidth, 50);
    } else {
        return CGSizeMake(kScreenWidth, kScreenHeight*0.3 - kRealValue(40));
    }
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
         return CGSizeMake(kScreenWidth, kScreenHeight*0.3);
    } else {
       return CGSizeMake(kScreenWidth,KBottomNavH);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma action
- (void)collectAction{
    
}

- (void)reloadListData{
    [self.titleView reloadViewWithTitles:self.titleArr image:nil];
    self.vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.titleArr.count; i++) {
        Class className = NSClassFromString(self.contentVCS[i]);
        RootViewController *vc =  [[className alloc]init];
        [self.vcs addObject:vc];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
}

- (void)bottomButtonClick:(UIButton *)button{
    if (button.tag == 0) {
        NSLog(@"收藏");
        button.selected = !button.selected;
    } else if (button.tag == 1){
        NSLog(@"购物车");
    } else  if (button.tag == 2 || button.tag == 3) { //父控制器的加入购物车和立即购买
        ZSHConfirmOrderViewController *confirmOrderVC = [[ZSHConfirmOrderViewController alloc]init];
        confirmOrderVC.goodsModel = _goodModel;
        [self.navigationController pushViewController:confirmOrderVC animated:YES];
        //异步发通知
//        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",button.tag],@"buttonTag", nil];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"ClikAddOrBuy" object:nil userInfo:dict];
//        });
    }
}

- (UIView *)lineTitleView{
    if (!_lineTitleView) {
        _lineTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KBottomNavH)];
        
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5)];
        topLineView.backgroundColor = KZSHColor1D1D1D;
        [_lineTitleView addSubview:topLineView];
        
        [_lineTitleView addSubview:self.titleView];
        
        UIView *bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, KBottomNavH-0.5, KScreenWidth, 0.5)];
        bottomLineView.backgroundColor = KZSHColor1D1D1D;
        [_lineTitleView addSubview:bottomLineView];
        
    }
    return _lineTitleView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
