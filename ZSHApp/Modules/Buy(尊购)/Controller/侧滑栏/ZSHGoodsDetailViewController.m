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
#import "ZSHBuyLogic.h"
#import "ZSHGoodDetailModel.h"
#import "ZSHGoodsChartCell.h"
#import "ZSHGoodsDetailSubCell.h"
#import "ZSHGoodsDetailModel.h"
#import "ZSHGoodsDetailCommentCell.h"

@interface ZSHGoodsDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray                        *titleArr;
@property (nonatomic, strong) LXScollTitleView               *titleView;
@property (nonatomic, strong) NSArray                        *contentVCS;
@property (nonatomic, assign) CGFloat                        titleWidth;
@property (nonatomic, strong) NSMutableArray                 *vcs;
@property (nonatomic, strong) UIView                         *bottomView;
@property (nonatomic, strong) UIView                         *lineTitleView;
@property (nonatomic, strong) ZSHBuyLogic                    *buyLogic;
@property (nonatomic, assign) NSInteger                      count;
@property (nonatomic, strong) NSArray                        *chartDataArr;
@property (nonatomic, strong) NSArray                        *dataArr;
@property (nonatomic, strong) NSArray                        *commentArr;

@end

//header
static NSString *ZSHDetailShufflingHeadViewID = @"ZSHDetailShufflingHeadView";

//cell
static NSString *ZSHDetailGoodReferralCellID    = @"ZSHDetailGoodReferralCell";
static NSString *ZSHDetailGoodBottomCellID      = @"ZSHDetailGoodBottomCellID";
static NSString *ZSHGoodsDetailColorCellID      = @"ZSHGoodsDetailColorCell";
static NSString *ZSHGoodsDetailCountCellID      = @"ZSHGoodsDetailCountCell";
static NSString *ZSHGoodsChartCellID            = @"ZSHGoodsChartCell";
static NSString *ZSHGoodsDetailSubCellID        = @"ZSHGoodsDetailSubCell";
static NSString *ZSHGoodsDetailCommentCellID    = @"ZSHGoodsDetailCommentCell";


@implementation ZSHGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.titleArr = @[@"商品",@"详情",@"评价"];
    self.titleWidth = kScreenWidth/[self.titleArr count];
    
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

    //注册Cell
    [self.collectionView registerClass:[ZSHDetailGoodReferralCell class] forCellWithReuseIdentifier:ZSHDetailGoodReferralCellID];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ZSHDetailGoodBottomCellID];

    [self.collectionView registerClass:[ZSHGoodsDetailColorCell class] forCellWithReuseIdentifier:ZSHGoodsDetailColorCellID];
    [self.collectionView registerClass:[ZSHGoodsDetailCountCell class] forCellWithReuseIdentifier:ZSHGoodsDetailCountCellID];
    
    //商品,详情，评价
    [self.collectionView registerClass:[ZSHGoodsChartCell class] forCellWithReuseIdentifier:ZSHGoodsChartCellID];
    [self.collectionView registerClass:[ZSHGoodsDetailSubCell class] forCellWithReuseIdentifier:ZSHGoodsDetailSubCellID];
    [self.collectionView registerClass:[ZSHGoodsDetailCommentCell class] forCellWithReuseIdentifier:ZSHGoodsDetailCommentCellID];
    
    [self.view addSubview:self.titleView];
    self.titleView.frame = CGRectMake(0, KNavigationBarHeight, kScreenWidth, kRealValue(40));
    self.titleView.alpha = 0;
    [self reloadListData];
    
    
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
        kWeakSelf(self);
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, 5, KScreenWidth, kRealValue(40))];
        _titleView.selectedIndex = 0;
        _titleView.normalTitleFont = kPingFangMedium(12);
        _titleView.selectedTitleFont = kPingFangMedium(12);
        _titleView.selectedColor = KZSHColorF29E19;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        _titleView.selectedBlock = ^(NSInteger index){
             [weakself.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+1] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        };
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.titleWidth = self.titleWidth;
    }
    return _titleView;
}

//上半部分
#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0){
        return 3;
    } else if (section == 1){//商品
        return _chartDataArr.count;
    } else if (section == 2){//详情
        return _dataArr.count;
    } else if (section == 3){//评价
        return _commentArr.count;
    }
    return 0;
}


#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 商品轮播图
            ZSHDetailGoodReferralCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHDetailGoodReferralCellID forIndexPath:indexPath];
            cell.goodTitleLabel.text = _goodModel.goods_title;
            cell.goodPriceLabel.text = _goodModel.price;
            cell.goodSubtitleLabel.text = _goodModel.main_title;
            gridcell = cell;
        } else if(indexPath.row == 1){ //商品颜色
            ZSHGoodsDetailColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsDetailColorCellID forIndexPath:indexPath];
            if (_buyLogic.goodDetailModel) {
                [cell updateCellWithModel:_buyLogic.goodDetailModel];
            }
            gridcell = cell;
        } else if(indexPath.row == 2){ //商品数量
            ZSHGoodsDetailCountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsDetailCountCellID forIndexPath:indexPath];
            cell.NumberChangeBlock = ^(NSInteger count) {
                _count = count;
                _goodModel.count = NSStringFormat(@"%zd", count);
            };
            gridcell = cell;
        }
        
    } else if (indexPath.section == 1){ //商品，详情，评价
        ZSHGoodsChartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsChartCellID forIndexPath:indexPath];
        cell.row = indexPath.row;
        [cell updateCellWithParamDic:_chartDataArr[indexPath.row]];
        gridcell = cell;
    } else if (indexPath.section == 2){ //详情
        ZSHGoodsDetailSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsDetailSubCellID forIndexPath:indexPath];
        ZSHGoodsDetailModel *model = _dataArr[indexPath.row];
        [cell updateCellWithModel:model];
        gridcell = cell;
        
    } else if (indexPath.section == 3){//评价
        ZSHGoodsDetailCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZSHGoodsDetailCommentCellID forIndexPath:indexPath];
        ZSHGoodCommentModel *model = _commentArr[indexPath.row];
        [cell updateCellWithModel:model];
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
        }
    }
    return reusableview;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            return (indexPath.row == 0) ? CGSizeMake(kScreenWidth, [ZSHSpeedy zsh_calculateTextSizeWithText:_goodTitle WithTextFont:kPingFangMedium(12) WithMaxW:kScreenWidth*0.7].height + [ZSHSpeedy zsh_calculateTextSizeWithText:_goodSubtitle WithTextFont:kPingFangRegular(12) WithMaxW:kScreenWidth*0.7].height + kRealValue(50)) : CGSizeMake(kScreenWidth, 50);
            break;
        }
        case 1:{
            return CGSizeMake(kScreenWidth, kRealValue(40));
            break;
        }
        case 2:{
            ZSHGoodsDetailModel *model = _dataArr[indexPath.row];
            return CGSizeMake(kScreenWidth, model.cellHeight);
            break;
        }
        case 3:{
            return CGSizeMake(kScreenWidth,kRealValue(100));
            break;
        }
            
        default:{
            return CGSizeMake(0, 0);
             break;
        }
         
    }
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
         return CGSizeMake(kScreenWidth, kScreenHeight*0.3);
    }
    return CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma action
- (void)collectionHeaderRereshing {
    [self.collectionView.mj_header endRefreshing];
}

- (void)collectionFooterRereshing {
    [self.collectionView.mj_footer endRefreshing];
}

- (void)collectAction{
    
}

- (void)reloadListData{
    [self.titleView reloadViewWithTitles:self.titleArr];
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

- (NSArray *)splitGoodProperty:(NSDictionary *)dic {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *allKeys = [dic allKeys];
    for (int i = 0; i < allKeys.count; i++) {
        [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:allKeys[i],@"leftTitle", dic[allKeys[i]], @"rightTitle", nil]];
    }
    return array;
}

- (NSArray *)splitGoodDetail {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<_buyLogic.goodDetailModel.PRODETAILSIMG.count; i++) {
        NSString *string;
        if (i == 0) {
            string = _buyLogic.goodDetailModel.PRODETAILSINT;
        } else {
            string = @"";
        }
        [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:_buyLogic.goodDetailModel.PRODETAILSIMG[i], @"detailPicture",string, @"detailText",nil]];
    }
    return [ZSHGoodsDetailModel mj_objectArrayWithKeyValuesArray:arr];
}


- (void)requestData {
    kWeakSelf(self);
    [_buyLogic requestShipDetailWithProductID:_goodModel.PRODUCT_ID success:^(id response) {
        [weakself.collectionView reloadData];
        weakself.goodModel.count = NSStringFormat(@"%zd", _count);
        weakself.chartDataArr = [weakself splitGoodProperty:weakself.buyLogic.goodDetailModel.PROPROPERTY];
        weakself.dataArr = weakself.buyLogic.goodsDetailModelArr;
        weakself.commentArr = weakself.buyLogic.goodCommentModelArr;
        [weakself.collectionView reloadData];
    }];
    
//    [_buyLogic requestGetProbyStandard:@{@"PRODUCT_ID":_goodModel.PRODUCT_ID } success:^(id response) {
//        
//    }];
}


- (void)addCart {
    if (_count<1) _count = 1;
    [_buyLogic requestShoppingCartAddWithDic:@{@"PRODUCT_ID":_buyLogic.goodDetailModel.PRODUCT_ID, @"HONOURUSER_ID":HONOURUSER_IDValue, @"QUANTITY":@(_count)} success:^(id response) {
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetToShow = 200.0;
    CGFloat alpha = 1 - (offsetToShow - scrollView.contentOffset.y) / offsetToShow;
    self.titleView.alpha = alpha;
    
    if (scrollView.contentOffset.y >= 200 && scrollView.contentOffset.y <= 400) {
        if ( self.titleView.selectedIndex != 0) {
             self.titleView.selectedIndex = 0;
        }
       
    } else  if (scrollView.contentOffset.y > 400 && scrollView.contentOffset.y <= 800) {
        if ( self.titleView.selectedIndex != 1) {
            self.titleView.selectedIndex = 1;
        }
    } else if (scrollView.contentOffset.y > 800) {
        if ( self.titleView.selectedIndex != 2) {
            self.titleView.selectedIndex = 2;
        }
    }
}

@end
