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

//本地数据
@property (nonatomic, strong)NSMutableArray           *localDataArr;
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
    NSArray *baseDataArr = @[
                             @{@"LiveTitle":@"夏天在我手中",@"LiveCover":@"live_image_1", @"UserNumber":@"33",@"PublishUrl":AlivcPullURL},
                             @{@"LiveTitle":@"忘记时间的钟",@"LiveCover":@"live_image_2", @"UserNumber":@"43",@"PublishUrl":AlivcPullURL},
                             @{@"LiveTitle":@"流沙",@"LiveCover":@"live_image_3", @"UserNumber":@"33",@"PublishUrl":AlivcPullURL},
                             @{@"LiveTitle":@"夏天",@"LiveCover":@"live_image_4", @"UserNumber":@"44",@"PublishUrl":AlivcPullURL},
                             @{@"LiveTitle":@"绅士",@"LiveCover":@"live_image_5", @"UserNumber":@"63",@"PublishUrl":AlivcPullURL},
                             @{@"LiveTitle":@"拉流",@"LiveCover":@"live_image_6", @"UserNumber":@"40",@"PublishUrl":AlivcPullURL}];
    self.localDataArr = [ZSHLiveListModel mj_objectArrayWithKeyValuesArray:baseDataArr];
    
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
        if (kFromClassTypeValue!=4) {
             make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, KBottomTabH , 0));
        } else {
             self.title = @"小视频";
             make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(KNavigationBarHeight, 0, KBottomHeight , 0));
        }
       
    }];
    
//    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionViewAction:)]];
    
}

//测试
- (void)collectionViewAction:(UIGestureRecognizer *)gesture{
    AliyunPlaySDKDemoFullScreenScrollViewController *livePlayVC = [[AliyunPlaySDKDemoFullScreenScrollViewController alloc] init];
    livePlayVC.publishUrl = AlivcPullURL;
    [self.navigationController pushViewController:livePlayVC animated:YES];
}

- (void)requestData{
    switch (kFromClassTypeValue) {
        case FromOtherVCToLiveContentFirstVC:
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
    //点击观看直播
    [self requestNumerOfTimes];
//    AdvancedPlayerViewController *demoTwo = [[AdvancedPlayerViewController alloc] init];
//    demoTwo.title = @"高级播放";
//    [self.navigationController pushViewController:demoTwo animated:YES];
    
    
    AliyunPlaySDKDemoFullScreenScrollViewController *livePlayVC = [[AliyunPlaySDKDemoFullScreenScrollViewController alloc] init];
    ZSHLiveListModel *model = self.liveListArr[indexPath.item];
    livePlayVC.publishUrl = model.PublishUrl;
    [self.navigationController pushViewController:livePlayVC animated:YES];
    
    
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
        if (_liveListArr.count==0) {
            _liveListArr = weakself.localDataArr;
        }
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
        if (_liveListArr.count==0) {
            _liveListArr = weakself.localDataArr;
        }
        [weakself.collectionView reloadData];
    }];
    
}

//附近筛选
- (void)requestNearSearchLiveListWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [_liveLogic requestScreenListWithDic:paramDic success:^(id response) {
        [weakself endCollectionViewRefresh];
        _liveListArr = [ZSHLiveListModel mj_objectArrayWithKeyValuesArray:response[@"pd"][@"PUSHONLINE"][@"OnlineInfo"][@"LiveStreamOnlineInfo"]];
        [weakself.collectionView reloadData];
        if (_liveListArr.count==0) {
            _liveListArr = weakself.localDataArr;
        }
    }];
    
}

//用户点进直播间时请先调用该接口
- (void)requestNumerOfTimes{
    kWeakSelf(self);
    
    NSDictionary *paramDic = @{@"HONOURUSER_ID":HONOURUSER_IDValue};
    [_liveLogic requestNearPushAddressListWithDic:paramDic success:^(id response) {
        [weakself endCollectionViewRefresh];
        RLog(@"点击某个直播播进入直播间观看");
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
