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
#import "ZSHBuyLogic.h"



@interface ZSHGoodsDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray                        *titleArr;
@property (nonatomic, strong) LXScollTitleView               *titleView;
@property (nonatomic, strong) LXScrollContentView            *contentView;
@property (nonatomic, strong) NSArray                        *contentVCS;
@property (nonatomic, assign) CGFloat                        titleWidth;
@property (nonatomic, strong) NSMutableArray                 *vcs;
@property (nonatomic, strong) UIView                         *bottomView;
@property (nonatomic, strong) UIView                         *lineTitleView;
@property (nonatomic, strong) ZSHBuyLogic                    *buyLogic;
@property (nonatomic, assign) NSInteger                      count;

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
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"商品",@"详情",@"评价"];
    self.titleWidth = kScreenWidth/[self.titleArr count];
    self.contentVCS = @[@"ZSHGoodsSubViewController",@"ZSHGoodsDetailSubViewController",@"ZSHGoodsCommentSubViewController"];
    
    UIImage *image = [UIImage imageNamed:@"buy_bag"];
    self.shufflingArray = @[image,image,image];
    _buyLogic = [[ZSHBuyLogic alloc] init];
    [self requestData];
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
    
    kWeakSelf(self);
    [self.view addSubview:[ZSHBaseUIControl createBottomButton:^(NSInteger index) {
        if (index == 0) {
            
        }
        else if (index == 1) {
            [self requestCollectAdd];
        }
        else if (index == 2) {
            [weakself addCart];
        }
        else if (index == 3) {
            ZSHConfirmOrderViewController *confirmOrderVC = [[ZSHConfirmOrderViewController alloc]init];
            confirmOrderVC.goodsModel = _goodModel;
            [self.navigationController pushViewController:confirmOrderVC animated:YES];
        }
        
    }]];
    
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
            if (_buyLogic.goodDetailModel) {
                [cell updateCellWithModel:_buyLogic.goodDetailModel];
            }
            gridcell = cell;
        } else if(indexPath.row == 2){
            ZSHGoodsDetailCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsDetailCountCellID forIndexPath:indexPath];
            cell.NumberChangeBlock = ^(NSInteger count) {
                _count = count;
                _goodModel.count = NSStringFormat(@"%zd", count);
            };
            gridcell = cell;
        }
    } else if(indexPath.section == 1){
        ZSHGoodsDetailColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHDetailGoodBottomCellID forIndexPath:indexPath];
        if (![cell.contentView viewWithTag:2]) {
            [cell.contentView addSubview:self.contentView];
            self.contentView.tag = 2;
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell.contentView);
            }];
        }
        gridcell = cell;
    }
        
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            // 轮播图
            ZSHGoodsDetailShufflingHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHDetailShufflingHeadViewID forIndexPath:indexPath];
            if (_buyLogic.goodDetailModel) {
                [headerView updateCellWithModel:_buyLogic.goodDetailModel];
            }
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
    [self.titleView reloadViewWithTitles:self.titleArr];
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

- (UIView *)lineTitleView {
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

- (void)requestData {
    kWeakSelf(self);
    [_buyLogic requestShipDetailWithProductID:_goodModel.PRODUCT_ID success:^(id response) {        
        [weakself.collectionView reloadData];
        weakself.goodModel.count = NSStringFormat(@"%zd", _count);
    }];
}


- (void)addCart {
    if (_count<1) _count = 1;
    [_buyLogic requestShoppingCartAddWithDic:@{@"PRODUCT_ID":_buyLogic.goodDetailModel.PRODUCT_ID, @"HONOURUSER_ID":HONOURUSER_IDValue, @"PRODUCTCOUNT":@(_count)} success:^(id response) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];
    }];
}

- (void)requestCollectAdd {
    kWeakSelf(self);
    [_buyLogic requestShipCollectAddWithProductID:_buyLogic.goodDetailModel.PRODUCT_ID success:^(id response) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [ac addAction:cancelAction];
        [weakself presentViewController:ac animated:YES completion:nil];
    }];
}

@end
