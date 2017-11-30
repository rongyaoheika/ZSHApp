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
#import "ZSHApplyServiceViewController.h"
#import "ZSHCommentViewController.h"
#import "ZSHCardBtnListView.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHGoodMineReusableView.h"

static NSString * cellIdentifier = @"cellId";
static NSString *headerViewIdentifier = @"hederview";

@interface ZSHGoodsMineViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray        *sectionTitleArr;
@property (nonatomic, strong) NSArray        *dataArr;
@property (nonatomic, strong) NSArray        *pushVCsArr;
@property (nonatomic, strong) NSArray        *paramArr;
@property (nonatomic, strong) UIButton       *titleBtn;

@property (nonatomic, strong) ZSHBottomBlurPopView  *topBtnListView;
@property (nonatomic, assign) NSInteger             typeIndex; // 尊购,KTV,火车票等

@end

@implementation ZSHGoodsMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.topBtnListView) {
        [ZSHBaseUIControl setAnimationWithHidden:YES view:self.topBtnListView completedBlock:nil];
        self.topBtnListView = nil;
    }
}

- (void)loadData{
    _typeIndex = 0;
    self.sectionTitleArr = @[@"我的订单",@"必备工具",@"钱包中心"];
    
    self.dataArr = @[
     @[@{@"image":@"goods_mine_payment",@"desc":@"待付款", @"tag":@(1)},
       @{@"image":@"goods_mine_receipt",@"desc":@"待收货",@"tag":@(2)},
       @{@"image":@"goods_mine_judge",@"desc":@"待评价",@"tag":@(3)},
       @{@"image":@"goods_mine_service",@"desc":@"售后",@"tag":@(4)}],
     @[@{@"image":@"goods_mine_vip",@"desc":@"会员中心",@"tag":@(1)},
       @{@"image":@"goods_mine_collect",@"desc":@"炫购收藏",@"tag":@(2)},
       @{@"image":@"goods_mine_locate",@"desc":@"地址管理",@"tag":@(3)},
       @{@"image":@"goods_mine_phoneService",@"desc":@"客服中心",@"tag":@(4)}],
     @[@{@"image":@"goods_mine_discount",@"desc":@"优惠券",@"tag":@(1)},
       @{@"image":@"goods_mine_integral",@"desc":@"积分",@"tag":@(2)},
       @{@"image":@"goods_mine_gift",@"desc":@"礼品",@"tag":@(3)}]
       ];
    
    
    self.pushVCsArr = @[
      @[@"ZSHTitleContentViewController",
        @"ZSHTitleContentViewController",
        @"ZSHCommentViewController",
        @"ZSHApplyServiceViewController"],
      
      @[@"",
        @"",
        @"ZSHManageAddressListViewController",
        @""],
      
      @[@"ZSHCouponViewController",
        @"ZSHIntegralViewController",
        @""]
                    ];
    
    self.paramArr = @[@[@{KFromClassType:@(FromAllOrderVCToTitleContentVC),@"title":@"我的订单",@"tag":@(_typeIndex)},
                        @{KFromClassType:@(FromAllOrderVCToTitleContentVC),@"title":@"我的订单",@"tag":@(_typeIndex)},
                        @{KFromClassType:@(ZSHFromGoodsMineVCToCommentVC),@"tag":@(_typeIndex)},
                        @{KFromClassType:@(ZSHFromGoodsMineVCToApplyServiceVC),@"tag":@(_typeIndex)}],
                      @[@{},@{},@{},@{}],
                      @[@{},@{},@{},@{}],
                      @[@{},@{},@{},@{}]
                      ];
}

- (void)createUI{
    
    self.navigationItem.titleView = self.titleBtn;
    self.titleBtn.frame = self.navigationItem.titleView.bounds;
    [self.titleBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(10)];

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
    [self.collectionView registerClass:[ZSHGoodMineReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    
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
        Class className = NSClassFromString(weakself.pushVCsArr[indexPath.section][btn.tag-1]);
        RootViewController *vc = [[className alloc]initWithParamDic:weakself.paramArr[indexPath.section][btn.tag-1]];
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZSHGoodMineReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        [header updateWithTitle:self.sectionTitleArr[indexPath.section]];
        header.userInteractionEnabled = YES;
        header.tag = indexPath.section + 1;
//        header = [self createHeaderiewWithTitle:self.sectionTitleArr[indexPath.section]];
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
        NSDictionary *nextParamDic = @{KFromClassType:@(FromAllOrderVCToTitleContentVC),@"title":@"我的订单",@"tag":@(_typeIndex)};
        ZSHTitleContentViewController *liveVC = [[ZSHTitleContentViewController alloc]initWithParamDic:nextParamDic];
        [self.navigationController pushViewController:liveVC animated:YES];
    }
}

- (UIButton *)titleBtn{
    if (!_titleBtn) {
    NSDictionary *titleBtnDic = @{@"title":@"尊购",@"font":kPingFangMedium(17)};
    _titleBtn = [ZSHBaseUIControl createBtnWithParamDic:titleBtnDic];
    [_titleBtn addTarget:self action:@selector(titleBtnAction) forControlEvents:UIControlEventTouchUpInside];
     [_titleBtn setImage:[UIImage imageNamed:@"hotel_btn"] forState:UIControlStateNormal];
    }
    return _titleBtn;
}

- (void)titleBtnAction{
    _titleBtn.selected = !_titleBtn.selected;
    if (_titleBtn.selected) {
        [self changeButtonObject:_titleBtn TransformAngle:M_PI];
    } else {
        [self changeButtonObject:_titleBtn TransformAngle:0];
    }
   
}

-(void)changeButtonObject:(UIButton *)button TransformAngle:(CGFloat)angle{
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        button.imageView.transform =CGAffineTransformMakeRotation(angle);
        if (angle == M_PI ) {//下拉展开
            weakself.topBtnListView = [weakself createBottomBlurPopViewWith:ZSHFromGoodsMineVCToToBottomBlurPopView];
            [ZSHBaseUIControl setAnimationWithHidden:NO view:weakself.topBtnListView completedBlock:nil];
            
            //订单列表button点击
            ZSHCardBtnListView *listView = [weakself.topBtnListView viewWithTag:2];
            listView.btnClickBlock = ^(UIButton *btn) {
                [weakself orderTypeBtnAction:btn];
            };
            
            //点击背景消失
            weakself.topBtnListView .dissmissViewBlock = ^(UIView *blurView, NSIndexPath *indexpath) {
                [ZSHBaseUIControl setAnimationWithHidden:YES view:blurView completedBlock:nil];
            };
            
        } else if(angle == 0){//收起
            [ZSHBaseUIControl setAnimationWithHidden:YES view:weakself.topBtnListView completedBlock:nil];
        }
       
    } completion:^(BOOL finished) {
        
    }];
}

#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, KScreenHeight-KNavigationBarHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    [bottomBlurPopView setBlurEnabled:YES];
    return bottomBlurPopView;
}

//选中某种订单列表
- (void)orderTypeBtnAction:(UIButton *)orderBtn {
    _typeIndex = orderBtn.tag-1;
    switch (orderBtn.tag) {
        case 1:{//尊购
            [self loadData];
            [self.collectionView reloadData];
            [self changeButtonObject:_titleBtn TransformAngle:0];
            _titleBtn.selected = !_titleBtn.selected;
             break;
        }
        case 2:// 火车票
        case 3:// 机票
        case 4:// 酒店
        case 5:// KTV
        case 6:// 美食
        case 7:// 酒吧
        case 8:{// 电影
            self.sectionTitleArr = @[@"我的订单"];
            self.dataArr = @[@[@{@"image":@"goods_mine_allOrder",@"desc":@"全部订单", @"tag":@(1)},
                               @{@"image":@"goods_mine_payment",@"desc":@"待付款",@"tag":@(2)},
                               @{@"image":@"goods_mine_noUse",@"desc":@"待使用",@"tag":@(3)},
                               @{@"image":@"goods_mine_judge",@"desc":@"待评价",@"tag":@(4)}]
                             ];
            self.pushVCsArr = @[
                                @[@"ZSHTitleContentViewController",
                                  @"ZSHTitleContentViewController",
                                  @"ZSHCommentViewController",
                                  @"ZSHApplyServiceViewController"]
                                ];
            self.paramArr = @[
                              @[@{KFromClassType:@(FromAllOrderVCToTitleContentVC),@"title":@"我的订单",@"tag":@(_typeIndex)},
                                @{KFromClassType:@(FromAllOrderVCToTitleContentVC),@"title":@"我的订单",@"tag":@(_typeIndex)},
                                @{KFromClassType:@(ZSHFromGoodsMineVCToCommentVC),@"tag":@(_typeIndex)},
                                @{KFromClassType:@(ZSHFromGoodsMineVCToApplyServiceVC),@"tag":@(_typeIndex)}]
                              ];
            

            
            [self.collectionView reloadData];
            [self changeButtonObject:_titleBtn TransformAngle:0];
            _titleBtn.selected = !_titleBtn.selected;
            break;
        }
        default:{
            
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
