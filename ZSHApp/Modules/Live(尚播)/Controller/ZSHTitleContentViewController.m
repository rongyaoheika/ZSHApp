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
#import "ZSHBottomBlurPopView.h"
#import "ZSHFoodViewController.h"
#import "ZSHMoreTicketViewController.h"
#import "ZSHTicketPlaceCell.h"
#import "ZSHActivityViewController.h"

@interface ZSHTitleContentViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) LXScollTitleView    *titleView;
@property (nonatomic, strong) NSArray             *titleArr;
@property (nonatomic, copy)   NSString            *titleImage;
@property (nonatomic, strong) NSMutableArray      *vcs;
@property (nonatomic, assign) CGFloat             titleWidth;
@property (nonatomic, assign) CGFloat             indicatorHeight;
@property (nonatomic, strong) NSArray             *contentVCS;
@property (nonatomic, strong) NSArray             *paramArr;
@property (nonatomic, strong) NSArray             *subContentVCs;

@property (nonatomic, strong) ZSHBottomBlurPopView *bottomBlurPopView;
@property (nonatomic, strong) ZSHTicketPlaceCell   *ticketView;

@end

@implementation ZSHTitleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    switch ([self.paramDic[KFromClassType]integerValue]) {
        case FromLiveTabBarVCToTitleContentVC:{
            self.titleArr = @[@"推荐",@"附近",@"分类"];
            self.indicatorHeight = 1.0;
            [self createLiveNaviUI];
            self.contentVCS = @[@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveClassifyViewController"];
            self.paramArr = @[@{KFromClassType:@(FromLiveRecommendVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveNearVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)}];
            
        }
            break;
        case FromFindVCToTitleContentVC:{
            self.titleArr = @[@"精选",@"数码",@"亲子",@"时尚",@"美食"];
            self.indicatorHeight = 0.0;
            self.contentVCS = @[@"ZSHFindViewController",@"ZSHFindViewController",@"ZSHFindViewController",@"ZSHFindViewController",@"ZSHFindViewController"];
        }
            break;
        case FromAllOrderVCToTitleContentVC:{
            self.titleArr = @[@"全部",@"待付款",@"待收货",@"待评价",@"退款售后"];
            self.indicatorHeight = 0.0;
            self.contentVCS = @[@"ZSHOrderSubViewController",@"ZSHOrderSubViewController",@"ZSHOrderSubViewController",@"ZSHOrderSubViewController",@"ZSHOrderSubViewController"];
            break;
        }
        case FromIntegralVCToTitleContentVC:{
            self.titleArr = @[@"全部",@"收入",@"支出"];
            self.indicatorHeight = 1.0;
            self.contentVCS = @[@"ZSHIntegralBillViewController",@"ZSHIntegralBillViewController",@"ZSHIntegralBillViewController"];
            break;
        }
        case FromHotelVCToTitleContentVC:{
            self.titleArr = @[@"排序",@"品牌",@"筛选"];
            self.titleImage = @"hotel_btn";
            self.indicatorHeight = 0.0;
            [self createHotelNaviUI];
            self.contentVCS = @[@"ZSHHotelViewController",@"ZSHHotelViewController",@"ZSHHotelViewController"];
        }
            break;
        case FromFoodVCToTitleContentVC:{
            self.titleArr = @[@"排序",@"品牌",@"筛选"];
            self.titleImage = @"hotel_btn";
            self.indicatorHeight = 0.0;
            [self createHotelNaviUI];
            self.contentVCS = @[@"ZSHFoodViewController",@"ZSHFoodViewController",@"ZSHFoodViewController"];
            
        }
            break;
        case FromPlaneTicketVCToTitleContentVC:{
            self.titleArr = @[@"价格",@"时间",@"准确率"];
            self.titleImage = @"hotel_btn";
            self.indicatorHeight = 0.0;
            [self createTicketNaviUI];
            self.contentVCS = @[@"ZSHMoreTicketViewController",@"ZSHMoreTicketViewController",@"ZSHMoreTicketViewController"];
            
        }
            break;
        case FromActivityCenterVCToTitleContentVC:{
            self.titleArr = @[@"我发布的",@"我参与的"];
            self.indicatorHeight = 0.0;
            self.contentVCS = @[@"ZSHActivityViewController",@"ZSHActivityViewController"];
            
        }
            break;
        case FromMineLevelVCToTitleContentVC: {
            self.titleArr = @[@"用户等级", @"主播等级"];
            self.indicatorHeight = 0.0;
            self.contentVCS = @[@"ZSHLiveUserLevelViewController",@"ZSHLivePlayerLevelViewController"];
        }
            break;
        case FromContributionListVCToTitleContentVC: {
            self.titleArr = @[@"日榜", @"周榜", @"月榜", @"总榜"];
            self.indicatorHeight = 0.0;
            self.contentVCS = @[@"ZSHLiveDayListViewController",
                                @"ZSHLiveDayListViewController",
                                @"ZSHLiveDayListViewController",
                                @"ZSHLiveDayListViewController"];
//            self.contentVCS = @[@"ZSHLiveDayListViewController", @"ZSHLiveWeekListViewController", @"ZSHLiveMonthListViewController", @"ZSHLiveTotalListViewController"];
        }
            break;
        case FromPeronalCenterVCToTitleContentVC:{
            self.titleArr = @[@"商品",@"详情",@"评价"];
            self.indicatorHeight = 0.0;
            self.contentVCS = @[@"ZSHWeiboViewController",
                                @"ZSHWeiboViewController",
                                @"ZSHWeiboViewController"];
        }
            break;
        default:
            break;
    }
    self.titleWidth = KScreenWidth/(self.titleArr.count);
}

- (void)createLiveNaviUI{
    [self addNavigationItemWithImageName:@"nav_back" isLeft:YES target:self action:@selector(backAction) tag:1];
    [self addNavigationItemWithImageName:@"live_search" isLeft:NO target:self action:@selector(searchAction) tag:2];
}

- (void)createHotelNaviUI{
    [self.navigationItem setTitleView:self.searchBar];
    self.searchBar.delegate = self;
}

- (void)createTicketNaviUI{
    self.ticketView = [[ZSHTicketPlaceCell alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44) paramDic:nil];
    self.ticketView.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y);
    [self.navigationItem setTitleView:self.ticketView];
}

- (void)createUI{
    self.title = self.paramDic[@"title"];
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    [self reloadListData];
}

- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, KNavigationBarHeight, KScreenWidth, kRealValue(35))];
        _titleView.normalTitleFont = kPingFangRegular(15);
        _titleView.selectedTitleFont = kPingFangMedium(15);
        _titleView.selectedColor = KZSHColor929292;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = self.indicatorHeight;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            strongSelf.contentView.currentIndex = index;
            if ([weakSelf.paramDic[KFromClassType]integerValue] == FromHotelVCToTitleContentVC && index == 0) {
                [kAppDelegate.window addSubview:weakSelf.bottomBlurPopView];
            }
        };
        _titleView.backgroundColor = [UIColor clearColor];
        _titleView.titleWidth = self.titleWidth;
    }
    return _titleView;
}

- (LXScrollContentView *)contentView{
    if (!_contentView) {
        _contentView = [[LXScrollContentView alloc] initWithFrame:CGRectMake(0,kRealValue(35) + KNavigationBarHeight, KScreenWidth,KScreenHeight - kRealValue(35) - KNavigationBarHeight  - KBottomNavH)];
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
    [self.titleView reloadViewWithTitles:self.titleArr image:_titleImage];
    self.vcs = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.titleArr.count; i++) {
        Class className = NSClassFromString(self.contentVCS[i]);
        RootViewController *vc  = nil;
        if (self.paramArr.count) {
           vc = [[className alloc]initWithParamDic:self.paramArr[i]];
        } else {
           vc = [[className alloc]init];
        }
       
        [self.vcs addObject:vc];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
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

#pragma action
- (void)locateBtnAction{
    
}

- (void)backAction{
    [[kAppDelegate getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RXLSideSlipViewController *RXL= (RXLSideSlipViewController *)delegate.window.rootViewController;
    MainTabBarController *tab = (MainTabBarController *)RXL.contentViewController;
    tab.tabBar.hidden = NO;
    tab.selectedIndex = 0;
}

- (void)searchAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
