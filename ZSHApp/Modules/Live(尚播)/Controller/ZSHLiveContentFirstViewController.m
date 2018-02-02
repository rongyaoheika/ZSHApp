//
//  ZSHLiveContentFirstViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveContentFirstViewController.h"
#import "ZSHCustomWaterFlowLayout.h"
#import "ZSHLiveCellView.h"
#import "ZSHWeiboViewController.h"
#import "ZSHLiveListModel.h"
#import "ZSHNearHeadView.h"
#import "ZSHBottomBlurPopView.h"
#import "AdvancedPlayerViewController.h"
#import "AliyunPlaySDKDemoFullScreenScrollViewController.h"
#import "ZSHLiveLogic.h"

@interface ZSHLiveContentFirstViewController ()< UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZSHCustomWaterFlowLayoutDelegate>

@property (nonatomic, strong)ZSHCustomWaterFlowLayout *waterLayout;
@property (nonatomic, strong)ZSHLiveListModel         *listModel;
@property (nonatomic, strong)ZSHLiveLogic             *liveLogic;
@property (nonatomic, strong)NSArray                  *liveListArr;

@end

static NSString * const cellIdentifier = @"cellID";
static NSString * const ZSHNearHeadViewID = @"ZSHNearHeadView";

@implementation ZSHLiveContentFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _liveLogic = [[ZSHLiveLogic alloc]init];
    
    self.waterLayout = [[ZSHCustomWaterFlowLayout alloc]init];
    self.waterLayout.delegate = self;
    if (kFromClassTypeValue == FromLiveNearVCToLiveContentFirstVC) {
          self.waterLayout.headerReferenceSize = CGSizeMake(KScreenWidth, kRealValue(40));
    }

    [self.collectionView setCollectionViewLayout:self.waterLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[ZSHLiveCellView class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHNearHeadViewID];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomTabH , 0));
    }];
    
}

- (void)requestData{
    switch (kFromClassTypeValue) {
        case FromLiveRecommendVCToLiveContentFirstVC:{
            [self requestRecommendLiveListWithParamDic:nil];
            
            break;
        }
        case FromLiveNearVCToLiveContentFirstVC:{
            [self requestNearLiveList];
            break;
        }
        case FromLiveClassifyVCToLiveContentFirstVC:{
            [self requestRecommendLiveListWithParamDic:self.paramDic];
            break;
        }
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestData];
}

#pragma delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.liveListArr.count;
   
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZSHLiveCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    ZSHLiveListModel *model = self.liveListArr[indexPath.item];
    [cell updateCellWithModel:model];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
       UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ZSHNearHeadViewID forIndexPath:indexPath];
    if (kFromClassTypeValue == FromLiveNearVCToLiveContentFirstVC) {
        kWeakSelf(self);
        ZSHNearHeadView *nearView = [[ZSHNearHeadView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(40))];
        nearView.btnClickBlock = ^(UIButton *searchLiveBtn) {
            ZSHBottomBlurPopView *bottomBlurPopView = [weakself createBottomBlurPopViewWith:ZSHFromLiveNearSearchVCToBottomBlurPopView];
            bottomBlurPopView.confirmOrderBlock = ^(NSDictionary *paramDic) {
                [weakself requestNearSearchLiveListWithParamDic:paramDic];
            };
            [kAppDelegate.window addSubview:bottomBlurPopView];
        };
        [reusableview addSubview:nearView];
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
     if (kFromClassTypeValue == FromLiveNearVCToLiveContentFirstVC) {
           return CGSizeMake(KScreenWidth, kRealValue(40));
     }
    return  CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    AdvancedPlayerViewController *demoTwo = [[AdvancedPlayerViewController alloc] init];
//    demoTwo.title = @"高级播放";
//    [self.navigationController pushViewController:demoTwo animated:YES];
    
    
    AliyunPlaySDKDemoFullScreenScrollViewController *demoThree = [[AliyunPlaySDKDemoFullScreenScrollViewController alloc] init];
    ZSHLiveListModel *model = self.liveListArr[indexPath.item];
    demoThree.publishUrl = model.PublishUrl;
    [self presentViewController:demoThree animated:YES completion:nil];
    
    
}

#pragma WaterFlowLayoutDelegate
- (CGFloat)heightForItem:(ZSHCustomWaterFlowLayout *)layout heightForItemAtIndex:(NSInteger)index itemWith:(CGFloat)itemWith{
    return (arc4random()%65 + 165 + kRealValue(22));
}

- (NSInteger)numberOfColums:(ZSHCustomWaterFlowLayout *)layout{
    return 2;
}

- (CGFloat)lineSpacingOfItems:(ZSHCustomWaterFlowLayout *)layout{
    return 10;
}

- (UIEdgeInsets)edgeinsetOfItems:(ZSHCustomWaterFlowLayout *)layout{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma getter
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType),@"typeText":@"筛选"};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bottomBlurPopView setBlurEnabled:NO];
    return bottomBlurPopView;
}

//推荐
- (void)requestRecommendLiveListWithParamDic:(NSDictionary *)dic{
    kWeakSelf(self);

    [_liveLogic requestRecommendPushAddressListWithDic:dic success:^(id response) {
        [weakself endCollectionViewRefresh];
        _liveListArr = [ZSHLiveListModel mj_objectArrayWithKeyValuesArray:response[@"pd"][@"PUSHONLINE"][@"OnlineInfo"][@"LiveStreamOnlineInfo"]];
        [weakself.collectionView reloadData];
    }];
}

//附近
- (void)requestNearLiveList{
    kWeakSelf(self);
    
    NSDictionary *paramDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue};
    [_liveLogic requestNearPushAddressListWithDic:paramDic success:^(id response) {
        [weakself endCollectionViewRefresh];
        _liveListArr = [ZSHLiveListModel mj_objectArrayWithKeyValuesArray:response[@"pd"][@"PUSHONLINE"][@"OnlineInfo"][@"LiveStreamOnlineInfo"]];
        [weakself.collectionView reloadData];
    }];
    
    [_liveLogic requestLiveUserDataWithDic:paramDic success:^(id response) {
        [weakself endCollectionViewRefresh];
        
        RLog(@"用户资料==%@",response);
    }];
}

//附近筛选
- (void)requestNearSearchLiveListWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [_liveLogic requestScreenListWithDic:paramDic success:^(id response) {
        [weakself endCollectionViewRefresh];
        _liveListArr = [ZSHLiveListModel mj_objectArrayWithKeyValuesArray:response[@"pd"][@"PUSHONLINE"][@"OnlineInfo"][@"LiveStreamOnlineInfo"]];
        [weakself.collectionView reloadData];
    }];
    
}

- (void)collectionHeaderRereshing {
    
    [self requestData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
