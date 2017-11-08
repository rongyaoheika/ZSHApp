//
//  ZSHGoodsMineViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsMineViewController.h"
#import "ZSHGoodsMineGridCell.h"
#import "ZSHManageAddressViewController.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHIntegralViewController.h"
#import "ZSHCouponViewController.h"
#import "ZSHLogisticsDetailViewController.h"

static NSString * cellIdentifier = @"cellId";
static NSString *headerViewIdentifier = @"hederview";

@interface ZSHGoodsMineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSArray        *sectionTitleArr;
@property (nonatomic,strong)NSArray        *dataArr;
@property (nonatomic,strong)NSArray        *pushVCArr;
@property (nonatomic,strong)NSArray        *pushVCDicArr;


@end

@implementation ZSHGoodsMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    self.sectionTitleArr = @[@"我的订单",@"必备工具",@"钱包中心"];
    
    self.dataArr = @[
     @[@{@"image":@"goods_mine_payment",@"desc":@"待付款", @"tag":@(1)},
       @{@"image":@"goods_mine_receipt",@"desc":@"待收货",@"tag":@(2)},
       @{@"image":@"goods_mine_judge",@"desc":@"待评价",@"tag":@(3)},
       @{@"image":@"goods_mine_service",@"desc":@"售后",@"tag":@(4)}],
     @[@{@"image":@"goods_mine_vip",@"desc":@"会员中心",@"tag":@(5)},
       @{@"image":@"goods_mine_collect",@"desc":@"炫购收藏",@"tag":@(6)},
       @{@"image":@"goods_mine_locate",@"desc":@"地址管理",@"tag":@(7)},
       @{@"image":@"goods_mine_phoneService",@"desc":@"客服中心",@"tag":@(8)}],
     @[@{@"image":@"goods_mine_discount",@"desc":@"优惠券",@"tag":@(9)},
       @{@"image":@"goods_mine_integral",@"desc":@"积分",@"tag":@(10)},
       @{@"image":@"goods_mine_gift",@"desc":@"礼品",@"tag":@(11)}]
       ];
    
    self.pushVCArr = @[@"",@"",@"",@"ZSHLogisticsDetailViewController",@"",@"",@"ZSHManageAddressViewController",@"",@"ZSHCouponViewController",@"ZSHIntegralViewController",@""];
}

- (void)createUI{
    self.title = @"我的订单";

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(KScreenWidth/4, kRealValue(75));
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, kRealValue(44));
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    self.collectionView.frame = CGRectMake(0,KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight);
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = KClearColor;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerClass:[ZSHGoodsMineGridCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    
    CGFloat top =  layout.headerReferenceSize.height + layout.itemSize.height;
    CGFloat sectionHeight = layout.headerReferenceSize.height + layout.itemSize.height;
    for (int i = 0; i<self.sectionTitleArr.count; i++) {
        UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(0,top + i*sectionHeight,KScreenWidth,0.5)];
        horizontalLine.backgroundColor = [UIColor colorWithHexString:@"1D1D1D"];
        [self.collectionView addSubview:horizontalLine];
    }
}

#pragma collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArr[section]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    kWeakSelf(self);
    ZSHGoodsMineGridCell *cell = (ZSHGoodsMineGridCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dicData = self.dataArr[indexPath.section][indexPath.row];
    cell.modelDic = dicData;
    cell.btnClickBlock = ^(UIButton *btn){
        Class className = NSClassFromString(weakself.pushVCArr[btn.tag-1]);
        UIViewController *vc = [[className alloc]init];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        header.userInteractionEnabled = YES;
        header.tag = indexPath.section + 1;
        [header addSubview:[self createHeaderiewWithTitle:self.sectionTitleArr[indexPath.section]]];
        [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewAction:)]];
        return header;
    }
        return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dicData = self.dataArr[indexPath.row];
    dicData[@"desc"] = @"你点击了我";
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    RLog(@"didSelectItemAtIndexPath:, indexPath.row=%ld ", (long)indexPath.row);
}

//创建头视图
- (UIView *)createHeaderiewWithTitle:(NSString *)title{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(44))];
    NSDictionary *headLabellDic = @{@"text":title, @"font":kPingFangMedium(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *headLabel = [ZSHBaseUIControl createLabelWithParamDic:headLabellDic];
    [headView addSubview:headLabel];
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(kRealValue(13));
        make.bottom.mas_equalTo(headView).offset(-kRealValue(18));
        make.width.mas_equalTo(KScreenWidth -2*kRealValue(13));
        make.height.mas_equalTo(kRealValue(15));
    }];
    return headView;
}

- (void)headViewAction:(UITapGestureRecognizer *)gesture{
    if (gesture.view.tag == 1) {//我的订单
        NSDictionary *nextParamDic = @{@"fromClassType":@(FromAllOrderVCToTitleContentVC),@"title":@"我的订单"};
        ZSHTitleContentViewController *liveVC = [[ZSHTitleContentViewController alloc]initWithParamDic:nextParamDic];
        [self.navigationController pushViewController:liveVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
