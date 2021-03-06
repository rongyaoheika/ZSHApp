//
//  ZSHTitleContentViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTitleContentViewController.h"
#import "LXScrollContentView.h"
#import "LXScollTitleView.h"
#import "ZSHLiveContentFirstViewController.h"
#import "ZSHOrderSubViewController.h"
#import "ZSHFindViewController.h"
#import "ZSHHotelViewController.h"

#import "ZSHFoodViewController.h"
#import "ZSHMoreTicketViewController.h"
#import "ZSHTicketPlaceCell.h"
#import "ZSHActivityViewController.h"
#import "PYSearchViewController.h"
#import "ZSHPickView.h"

#import "ZSHToplineTopView.h"
#import "ZSHWeiboWriteController.h"
#import "ZSHHomeLogic.h"
#import "ZSHGoodsTitleContentViewController.h"
#import "ZSHTopLineMoreTypeViewController.h"
#import "ZSHBuyLogic.h"
#import "ZSHMoreLogic.h"

@interface ZSHTitleContentViewController ()<UISearchBarDelegate,PYSearchViewControllerDelegate>

@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) LXScollTitleView    *titleView;
@property (nonatomic, strong) UIImage             *titleBtnImage;
@property (nonatomic, strong) NSArray             *titleArr;

@property (nonatomic, assign) CGSize                   svContentSize;
@property (nonatomic, assign) CGFloat                  titleWidth;
@property (nonatomic, assign) CGFloat                  indicatorHeight;
@property (nonatomic, assign) XYButtonEdgeInsetsStyle  imageStyle;
@property (nonatomic, assign) CGFloat                  imageTitleSpace;


@property (nonatomic, strong) NSArray             *contentVCS;
@property (nonatomic, strong) NSArray             *paramArr;
@property (nonatomic, strong) NSArray             *subContentVCs;

@property (nonatomic, strong) ZSHBottomBlurPopView *bottomBlurPopView;
@property (nonatomic, strong) ZSHPickView          *pickView;
@property (nonatomic, strong) ZSHTicketPlaceCell   *ticketView;

@property (nonatomic, strong) ZSHBuyLogic          *buyLogic;
@property (nonatomic, strong) ZSHToplineTopView    *toplineTopView;
@property (nonatomic, strong) NSMutableArray       *myTags;
@property (nonatomic, strong) NSMutableArray       *recommandTags;
@property (nonatomic, strong) UILabel              *tagLabel;


@property (nonatomic, strong) NSMutableArray       *paramMArr;
@property (nonatomic, strong) ZSHMoreLogic         *moreLogic;

@end

@implementation ZSHTitleContentViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (kFromClassTypeValue == FromBuyVCToTitleContentVC) {
        RXLSideSlipViewController *rxl = (RXLSideSlipViewController *)kRootViewController;
        rxl.panGestureEnabled = true;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (kFromClassTypeValue == FromBuyVCToTitleContentVC) {
        RXLSideSlipViewController *rxl = (RXLSideSlipViewController *)kRootViewController;
        rxl.panGestureEnabled = false;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData{
    self.paramMArr = [[NSMutableArray alloc]initWithCapacity:3];
    self.myTags = [[NSMutableArray alloc]init];
    self.recommandTags = [[NSMutableArray alloc]init];
    self.buyLogic = [[ZSHBuyLogic alloc]init];
    self.moreLogic = [[ZSHMoreLogic alloc]init];
    self.vcIndex = 0;
    self.indicatorHeight = 0.0;
   
    switch (kFromClassTypeValue) {
        case FromLiveTabBarVCToTitleContentVC:{
            self.titleArr = @[@"推荐",@"附近",@"分类"];
            self.indicatorHeight = 1.0;
            [self createLiveNaviUI];
            self.contentVCS = @[@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveClassifyViewController"];
            self.paramArr = @[@{KFromClassType:@(FromLiveRecommendVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveNearVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)}];
            
        }
            break;
        case FromFindVCToTitleContentVC:{//头条
            [self createFindNaviUI];
            [self requestTopLineMenuData];
            return;
            break;
        }
           
        case FromAllOrderVCToTitleContentVC:{
//            self.titleArr = @[@"全部",@"待付款",@"待收货",@"待评价",@"退款售后"];
            self.titleArr = self.paramDic[@"titleArr"];
            self.contentVCS = self.paramDic[@"contentVCS"];
            self.indicatorHeight = 0.0;

            break;
        }
        case FromIntegralVCToTitleContentVC:{
            self.titleArr = @[@"全部",@"收入",@"支出"];
            self.indicatorHeight = 1.0;
            self.contentVCS = @[@"ZSHIntegralBillViewController",@"ZSHIntegralBillViewController",@"ZSHIntegralBillViewController"];
            break;
        }
        case FromHotelVCToTitleContentVC:
        case FromBarVCToTitleContentVC:{
            [self createTileViewUI];
            [self createSearchNaviUI];
            self.contentVCS = @[@"ZSHHotelViewController",@"ZSHHotelViewController",@"ZSHHotelViewController"];
            self.paramArr = @[@{KFromClassType:@(kFromClassTypeValue)},@{KFromClassType:@(kFromClassTypeValue)},@{KFromClassType:@(kFromClassTypeValue)}];
        }
            break;
        case FromFoodVCToTitleContentVC:{
            [self createTileViewUI];
            [self createSearchNaviUI];
            self.contentVCS = @[@"ZSHFoodViewController",@"ZSHFoodViewController",@"ZSHFoodViewController"];
            
        }
            break;
        case FromKTVVCToTitleContentVC:{
            [self createTileViewUI];
            [self createSearchNaviUI];
            self.contentVCS = @[@"ZSHKTVViewController",@"ZSHKTVViewController",@"ZSHKTVViewController"];
        }
            break;
           
        case FromPlaneTicketVCToTitleContentVC:{
            self.titleArr = @[@"价格",@"时间",@"准确率"];
            self.titleBtnImage = [UIImage imageNamed:@"hotel_btn"];
            self.imageStyle = XYButtonEdgeInsetsStyleRight;
            self.imageTitleSpace = kRealValue(6.0);
            [self createTicketNaviUI];
            self.contentVCS = @[@"ZSHMoreTicketViewController",@"ZSHMoreTicketViewController",@"ZSHMoreTicketViewController"];
            
        }
            break;
        case FromActivityCenterVCToTitleContentVC:{
            self.titleArr = @[@"我发布的",@"我参与的"];
            self.contentVCS = @[@"ZSHActivityViewController",@"ZSHActivityViewController"];
            self.paramArr = @[@{@"STATUS":@"0"}, @{@"STATUS":@"1"}];
            
        }
            break;
        case FromMineLevelVCToTitleContentVC: {
            self.titleArr = @[@"用户等级", @"主播等级"];
            self.contentVCS = @[@"ZSHLiveUserLevelViewController",@"ZSHLivePlayerLevelViewController"];
        }
            break;
        case FromContributionListVCToTitleContentVC: {
            self.titleArr = @[@"日榜", @"周榜", @"月榜", @"总榜"];
            self.contentVCS = @[@"ZSHLiveDayListViewController",
                                @"ZSHLiveDayListViewController",
                                @"ZSHLiveDayListViewController",
                                @"ZSHLiveDayListViewController"];
//            self.contentVCS = @[@"ZSHLiveDayListViewController", @"ZSHLiveWeekListViewController", @"ZSHLiveMonthListViewController", @"ZSHLiveTotalListViewController"];
             self.paramArr = @[@{@"TYPE":@"DATE"},@{@"TYPE":@"WEEK"},@{@"TYPE":@"MONTH"},@{@"TYPE":@"ALL"}];
        }
            break;
        case FromPeronalCenterVCToTitleContentVC:{
            self.titleArr = @[@"商品",@"详情",@"评价"];
            self.contentVCS = @[@"ZSHWeiboViewController",
                                @"ZSHWeiboViewController",
                                @"ZSHWeiboViewController"];
        }
            break;

        case FromHorseVCToTitleContentVC://马术
        case FromShipVCToTitleContentVC://游艇
        case FromGolfVCToTitleContentVC://高尔夫
        case FromLuxcarVCToTitleContentVC:{//豪车
            self.contentVCS = @[@"ZSHMoreListViewController",
                                @"ZSHMoreListViewController",
                                @"ZSHMoreListViewController"];
            self.paramArr = @[self.paramDic,self.paramDic,self.paramDic];
            [self createTileViewUI];
            [self createSearchNaviUI];
        }
            break;
        case FromMagazineVCToTitleContentVC : { //荣耀杂志
            self.titleArr = @[@"推荐",@"科技", @"吃喝", @"心灵", @"时尚", @"运动", @"摄影"];
            self.contentVCS = @[@"ZSHMagazineListViewController",
                                @"ZSHMagazineListViewController",
                                @"ZSHMagazineListViewController",
                                @"ZSHMagazineListViewController",
                                @"ZSHMagazineListViewController",
                                @"ZSHMagazineListViewController",
                                @"ZSHMagazineListViewController"];
        }
        break;
        case FromBuyVCToTitleContentVC : { //尊购
            [self createBuyNaviUI];
            self.titleArr = @[@"首页",@"时尚圈",@"专柜店", @"旗舰店", @"会员特权"];
            self.contentVCS = @[@"ZSHBuyViewController",
                                @"ZSHFashionViewController",
                                @"ZSHCabinetViewController",
                                @"ZSHFlagshipViewController",
                                @"ZSHPrivilegeController"
                                ];
        }
            break;
        default:{
            self.titleArr = self.paramDic[@"titleArr"];
            self.titleBtnImage = [UIImage imageNamed:@"hotel_btn"];
            self.imageStyle = XYButtonEdgeInsetsStyleRight;
            self.imageTitleSpace = kRealValue(6.0);
            self.contentVCS = self.paramDic[@"contentVCS"];
            if (!self.contentVCS.count) {
                NSMutableArray *mContentVCS = [[NSMutableArray alloc]init];
                for (int i = 0; i<self.titleArr.count; i++) {
                    [mContentVCS addObject:@"RootViewController"];
                }
                self.contentVCS = mContentVCS;
            }
           
            [self createSearchNaviUI];
            
        }
            break;
    }
    self.svContentSize = CGSizeZero;
    self.titleWidth = KScreenWidth/(self.titleArr.count);
    [self createUI];
}

- (void)createFindNaviUI{
     [self addNavigationItemWithTitles:@[@"发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(2)]];
}

- (void)createTileViewUI{
    self.titleArr = @[@"排序",@"品牌",@"筛选"];
    self.titleBtnImage = [UIImage imageNamed:@"hotel_btn"];
    self.imageStyle = XYButtonEdgeInsetsStyleRight;
    self.imageTitleSpace = kRealValue(6.0);
}

- (void)createLiveNaviUI{
    [self addNavigationItemWithImageName:@"nav_back" isLeft:YES target:self action:@selector(backAction) tag:1];
    [self addNavigationItemWithImageName:@"live_search" isLeft:NO target:self action:@selector(searchAction) tag:2];
}

- (void)createSearchNaviUI{
    [self.navigationItem setTitleView:self.searchView];
    self.searchView.searchBar.delegate = self;
}

- (void)createTicketNaviUI{
    self.ticketView = [[ZSHTicketPlaceCell alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44) paramDic:nil];
    self.ticketView.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y);
    [self.navigationItem setTitleView:self.ticketView];
}

- (void)createBuyNaviUI{
    UIButton *searchBtn = [ZSHBaseUIControl  createBtnWithParamDic:@{@"title":@"搜索",@"normalImage":@"nav_home_search"} target:self action:@selector(searchAction)];
    searchBtn.frame = CGRectMake(0, 0, kRealValue(270), 30);
    searchBtn.backgroundColor = KZSHColor1A1A1A;
    searchBtn.layer.cornerRadius = 5.0;
    searchBtn.layer.masksToBounds = YES;
    [self.navigationItem setTitleView:searchBtn];
    
    [self addNavigationItemWithImageName:@"nav_buy_mine" isLeft:YES target:self action:@selector(buyMineBtntAction) tag:1];
    [self addNavigationItemWithImageName:@"nav_buy_scan" isLeft:NO target:self action:@selector(buyScanBtntAction) tag:2];
}

- (void)createUI{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.title = self.paramDic[@"title"];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    if (kFromClassTypeValue == FromFindVCToTitleContentVC) {
        self.titleView.scrollView.contentSize = CGSizeMake(KScreenWidth+kRealValue(40), 0);
        [self addOtherUI];
    }
    
    [self reloadListData];
}

- (void)addOtherUI{
    UIButton *moreBtn = [[UIButton alloc]init];
    [moreBtn setImage:[UIImage imageNamed:@"topline_menu"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(topLineMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleView);
        make.right.mas_equalTo(self.titleView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(44), kRealValue(44)));
    }];
    
    
}

- (LXScollTitleView *)titleView{
    kWeakSelf(self);
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(35))];
        _titleView.normalImage = self.titleBtnImage;
        _titleView.imageStyle = self.imageStyle;
        _titleView.imageTitleSpace = self.imageTitleSpace;
        _titleView.normalTitleFont = kPingFangRegular(15);
        _titleView.selectedTitleFont = kPingFangMedium(15);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = self.indicatorHeight;
        _titleView.svContentSize = self.svContentSize;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            strongSelf.vcIndex = index;
            strongSelf.contentView.currentIndex = index;
            if ((kFromClassTypeValue>=FromHotelVCToTitleContentVC) &&(kFromClassTypeValue<=FromLuxcarVCToTitleContentVC)) {
                //美食，酒店，酒吧，KTV，马术，游艇，豪车，高尔夫汇 (0代表美食，1酒店，2KTV，3酒吧，4游艇，5豪车,6马术,7飞机,8高尔夫)
                [weakself titleViewSelectChangeWithIndex:index];
            }
           
        };
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.titleWidth = self.titleWidth;
    }
    return _titleView;
}

- (LXScrollContentView *)contentView{
    if (!_contentView) {
        _contentView = [[LXScrollContentView alloc] initWithFrame:CGRectMake(0,kRealValue(35) + KNavigationBarHeight, KScreenWidth,KScreenHeight - kRealValue(35) - KNavigationBarHeight)];
        _contentView.backgroundColor = KClearColor;
        kWeakSelf(self);
        _contentView.scrollBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakself;
            strongSelf.titleView.selectedIndex = index;
        };
    }
    return _contentView;
}


- (void)reloadListData{
    
    [self.titleView reloadViewWithTitles:self.titleArr];
    self.vcs = [[NSMutableArray alloc]init];
    RootViewController *vc = nil;

    if (kFromClassTypeValue == FromAllOrderVCToTitleContentVC) {
   
        for (int i = 0;i< [(NSArray *)self.paramDic[@"titleArr"] count]; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
            [dic setValue:self.paramDic[@"ORDERSTATUS"][i] forKey:@"ORDERSTATUS"];
            Class className = NSClassFromString(self.paramDic[@"contentVCS"][i]);
            vc = [[className alloc]initWithParamDic:dic];
            [self.vcs addObject:vc];
        }
    } else {
        for (int i = 0; i<self.titleArr.count; i++) {
            Class className = NSClassFromString(self.contentVCS[i]);

            if (self.paramArr.count) {
                vc = [[className alloc]initWithParamDic:self.paramArr[i]];
            } else {
               vc = [[className alloc]init];
            }
           
            [self.vcs addObject:vc];
        }
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
    self.titleView.selectedIndex = [self.paramDic[@"selectedIndex"] integerValue];
    self.contentView.currentIndex = [self.paramDic[@"selectedIndex"] integerValue];
}

#pragma  getter
- (ZSHBottomBlurPopView *)bottomBlurPopView{
    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromHotelVCToBottomBlurPopView)};
    _bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    _bottomBlurPopView.blurRadius = 20;
    _bottomBlurPopView.dynamic = NO;
    _bottomBlurPopView.tintColor = KClearColor;
    return _bottomBlurPopView;
}

-(ZSHPickView *)createPickViewWithParamDic:(NSDictionary *)paramDic{
    ZSHPickView *pickView = [[ZSHPickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) paramDic:paramDic];
    pickView.controller = self;
    return pickView;
}


#pragma action
- (void)titleViewSelectChangeWithIndex:(NSInteger)index{
    kWeakSelf(self);
    
    //弹出底部
    NSArray *midTitleArr = @[@"排序",@"品牌",@"筛选"];
    NSDictionary *nextParamDic = @{@"type":@(WindowDefault),@"midTitle":midTitleArr[index]};
    weakself.pickView = [weakself createPickViewWithParamDic:nextParamDic];
    [weakself.pickView show:WindowDefault];
    weakself.pickView.saveChangeBlock = ^(NSString *rowTitle, NSInteger tag,NSDictionary *dic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateDataWithSort object:@{@"row":@(tag),@"midTitle":midTitleArr[index],@"rowTitle":rowTitle,KFromClassType:@(kFromClassTypeValue)}];
    };
 
    if (index == 0) {//排序
        weakself.pickView.dataArr = [@[@"推荐",@"距离由近到远",@"评分由高到低",@"价格由高到低",@"价格由低到高"]mutableCopy];
    } else {//1：品牌  2：筛选
        NSMutableArray *shopSortArr = [[NSMutableArray alloc]init];
        NSDictionary *paramDic = @{@"TYPE":@(index-1),@"SORTNAME":[self.paramDic[@"storeName"] stringValue]};
        [self.moreLogic loadBottomCategoryWithParamDic:paramDic success:^(id responseObject) {
            for (NSDictionary *subDic in responseObject) {
                [shopSortArr addObject:subDic[@"NAME"]];
            }
            weakself.pickView.dataArr = shopSortArr;
        } fail:nil];
    }
    
}

- (void)locateBtnAction {
    
}

- (void)backAction{
    [[kAppDelegate getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RXLSideSlipViewController *RXL= (RXLSideSlipViewController *)delegate.window.rootViewController;
    MainTabBarController *tab = (MainTabBarController *)RXL.contentViewController;
    tab.tabBar.hidden = NO;
    tab.selectedIndex = 0;
}

//尊购
- (void)searchAction {
    BOOL showRecommendView = NO;
    NSDictionary *paramDic = [[NSDictionary alloc]init];
    switch (kFromClassTypeValue) {
        case FromBuyVCToTitleContentVC:{
            paramDic = @{@"PARENT_ID":@(2)};
            showRecommendView = YES;
             break;
        }
        case FromLiveTabBarVCToTitleContentVC:{
            paramDic = @{@"PARENT_ID":@(4)};
            showRecommendView = NO;
            break;
        }
            
        default:
            break;
    }
    
    ZSHHomeLogic *homeLogic = [[ZSHHomeLogic alloc]init];
    NSMutableArray *hotSearchMArr = [[NSMutableArray alloc]init];
    NSMutableArray *recommendImageMArr = [[NSMutableArray alloc]init];
    [homeLogic loadSearchListWithDic:paramDic success:^(id response) {
        for (NSDictionary *dic in response[@"pd"]) {
            [hotSearchMArr addObject:dic[@"NAME"]];
        }
        
        for (NSDictionary *dic in response[@"showimgs"]) {
            [recommendImageMArr addObject:dic[@"SHOWIMAGES"]];
        }
        
        kWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSearchMArr searchBarPlaceholder:NSLocalizedString(@"Search", @"搜索") recommendArr:recommendImageMArr didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
                ZSHGoodsTitleContentViewController *goodContentVC = [[ZSHGoodsTitleContentViewController alloc]initWithParamDic:@{@"searchText":searchText,KFromClassType:@(FromSearchResultVCTOGoodsTitleVC)}];
                [weakself.navigationController pushViewController:goodContentVC animated:YES];
            }];
            
            searchViewController.showRecommendView = showRecommendView;
            searchViewController.delegate = self;
            [self.navigationController pushViewController:searchViewController animated:YES];
        });
        
        
    }];
    
}

- (void)buyMineBtntAction{
    [self.sideSlipVC presentLeftMenuViewController];
    
}

- (void)buyScanBtntAction{
    
}

/**********************头条*********************/
//头条-发布
- (void)distributeAction{
    RLog(@"发布");
    kWeakSelf(self);
    
    if (![self.view viewWithTag:18011506]) {
        [UIView transitionWithView:self.toplineTopView duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^ {
            [self.view addSubview:self.toplineTopView];
            self.toplineTopView.btnClickBlock = ^(UIButton *btn) {
                NSArray *values = @[@(FromWordVCToZSHWeiboWriteVC), @(FromPhotoVCToZSHWeiboWriteVC), @(FromVideoVCToZSHWeiboWriteVC)];
                NSMutableDictionary *mutableDic = [NSMutableDictionary new];
                [mutableDic setValue:values[btn.tag] forKey:KFromClassType];
                [mutableDic setValue:weakself.paramArr forKey:@"paramArr"];
                [mutableDic setValue:weakself.titleArr forKey:@"titleArr"];
                [mutableDic setValue:weakself.titleArr[weakself.vcIndex] forKey:@"title"];
                
                NSDictionary *dic = weakself.paramArr[weakself.vcIndex];
                [mutableDic setValue:dic[@"CAIDAN_ID"] forKey:@"typeId"];
                
                
                ZSHWeiboWriteController *weiboWriteVC = [[ZSHWeiboWriteController alloc]initWithParamDic:mutableDic];
                [weakself.navigationController pushViewController:weiboWriteVC animated:YES];
            };
        } completion:nil];
    } else {
        [UIView transitionWithView:self.toplineTopView duration:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^ {
            [self.toplineTopView removeFromSuperview];
            self.toplineTopView = nil;
        } completion:nil];
    }
}

- (void)topLineMenuAction:(UIButton *)btn{

    ZSHTopLineMoreTypeViewController *topLineMoreVC = [[ZSHTopLineMoreTypeViewController alloc]initWithParamDic:@{@"myChannels":self.myTags,@"recommandChannels":self.recommandTags}];
    [self presentViewController:topLineMoreVC animated:YES completion:^{}];
    
    //所有的已选的tags
    __block  NSMutableString *_str = @"已选：\n".mutableCopy;
    topLineMoreVC.choosedTags = ^(NSArray *chooseTags, NSArray *recommandTags) {
        _myTags = @[].mutableCopy;
        _recommandTags = @[].mutableCopy;
        for (Channel *mod in recommandTags) {
            [_recommandTags addObject:mod.title];
        }
        for (Channel *mod in chooseTags) {
            [_myTags addObject:mod.title];
            [_str appendString:mod.title];
            [_str appendString:@"、"];
        }
        _tagLabel.text = _str;
    };
    
    //单选tag
    topLineMoreVC.selectedTag = ^(Channel *channel) {
        [_str appendString:channel.title];
        _tagLabel.text = _str;
    };
}

- (ZSHToplineTopView *)toplineTopView{
    if (!_toplineTopView) {
        _toplineTopView = [[ZSHToplineTopView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, kScreenWidth, kScreenHeight - KNavigationBarHeight)];
        _toplineTopView.tag = 18011506;
    }
    return _toplineTopView;
}

#pragma requestData
- (void)requestTopLineMenuData{
    kWeakSelf(self);
    RLog(@"用户id=%@",HONOURUSER_IDValue);
    [_buyLogic requestCaidanWithDic:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id response) {
        RLog(@"头条数据== %@",response);
        
        NSString *shopId  = self.paramDic[@"shopId"]?self.paramDic[@"shopId"]:@"";
        NSMutableArray *titleMArr = [[NSMutableArray alloc]init];
        NSMutableArray *paramMArr = [[NSMutableArray alloc]init];
        NSMutableArray *contentVCSMArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in response[@"topline"]) {
            [titleMArr addObject:dic[@"NAME"]];
            [paramMArr addObject:@{@"CAIDAN_ID":dic[@"CAIDAN_ID"],@"shopId":shopId}];
            [contentVCSMArr addObject:@"ZSHFindViewController"];
        }
        
        for (NSDictionary *dic in response[@"recomList"]) {
            [weakself.recommandTags addObject:dic[@"NAME"]];
        }
        weakself.myTags = titleMArr;
        weakself.titleArr = titleMArr;
        weakself.paramArr = paramMArr;
        weakself.contentVCS = contentVCSMArr;
        weakself.titleWidth = kRealValue(60);
        weakself.svContentSize = CGSizeMake((self.titleArr.count+1)*self.titleWidth, 0);
        [weakself createUI];
       
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
