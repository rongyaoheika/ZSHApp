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
#import "PYSearchViewController.h"
#import "ZSHPickView.h"
#import "ZSHBottomBlurPopView.h"

@interface ZSHTitleContentViewController ()<UISearchBarDelegate,PYSearchViewControllerDelegate>

@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) LXScollTitleView    *titleView;
@property (nonatomic, strong) UIImage             *titleBtnImage;
@property (nonatomic, strong) NSArray             *titleArr;
@property (nonatomic, strong) NSMutableArray      *vcs;

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

@end

@implementation ZSHTitleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    self.indicatorHeight = 0.0;
    //
    switch (kFromClassTypeValue) {
        case FromLiveTabBarVCToTitleContentVC:{
            self.titleArr = @[@"推荐",@"附近",@"分类"];
            self.indicatorHeight = 1.0;
            [self createLiveNaviUI];
            self.contentVCS = @[@"ZSHLiveContentFirstViewController",@"ZSHLiveContentFirstViewController",@"ZSHLiveClassifyViewController"];
            self.paramArr = @[@{KFromClassType:@(FromLiveRecommendVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveNearVCToLiveContentFirstVC)},@{KFromClassType:@(FromLiveClassifyVCToLiveContentFirstVC)}];
            
        }
            break;
        case FromFindVCToTitleContentVC:{
            [self createFindNaviUI];
            self.titleArr = @[@"精选",@"数码",@"亲子",@"时尚",@"美食"];
            self.contentVCS = @[@"ZSHFindViewController",@"ZSHFindViewController",@"ZSHFindViewController",@"ZSHFindViewController",@"ZSHFindViewController"];
            self.paramArr = @[@{@"CAIDAN_ID":@"387563351791632384",@"shopId":self.paramDic[@"shopId"]},
                              @{@"CAIDAN_ID":@"387563399975796736",@"shopId":self.paramDic[@"shopId"]},
                              @{@"CAIDAN_ID":@"387563457622310912",@"shopId":self.paramDic[@"shopId"]},
                              @{@"CAIDAN_ID":@"387563486307155968",@"shopId":self.paramDic[@"shopId"]},
                              @{@"CAIDAN_ID":@"387563525268045824",@"shopId":self.paramDic[@"shopId"]}];
        }
            break;
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
        case FromGolfVCToTitleContentVC://游艇
        case FromLuxcarVCToTitleContentVC:{//豪车
            self.contentVCS = @[@"ZSHMoreListViewController",
                                @"ZSHMoreListViewController",
                                @"ZSHMoreListViewController"];
            self.paramArr = @[@{KFromClassType:@(kFromClassTypeValue)},@{KFromClassType:@(kFromClassTypeValue)},@{KFromClassType:@(kFromClassTypeValue)}];
            [self createTileViewUI];
            [self createSearchNaviUI];
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
    self.titleWidth = KScreenWidth/(self.titleArr.count);
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

- (void)createUI{
    self.title = self.paramDic[@"title"];
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];

    [self reloadListData];
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
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            strongSelf.contentView.currentIndex = index;
            if (kFromClassTypeValue == FromHotelVCToTitleContentVC||kFromClassTypeValue == FromBarVCToTitleContentVC||kFromClassTypeValue == FromFoodVCToTitleContentVC|| kFromClassTypeValue ==FromKTVVCToTitleContentVC ) {
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
    RootViewController *vc  = nil;

    if (kFromClassTypeValue == FromAllOrderVCToTitleContentVC) {
        for (int i = 0;i< [self.paramDic[@"titleArr"] count]; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
            [dic setValue:self.paramDic[@"ORDERSTATUS"][i] forKey:@"ORDERSTATUS"];
            Class className = NSClassFromString(self.paramDic[@"contentVCS"][i]);
            vc = [[className alloc]initWithParamDic:dic];
            [self.vcs addObject:vc];
        }
    } else{
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
    
    //0:排序  1：品牌  2：筛选
    NSArray *paramArr = nil;
    switch (kFromClassTypeValue) {
        case FromHotelVCToTitleContentVC://酒店排序
        case FromBarVCToTitleContentVC:{//酒吧排序
            paramArr = @[@{@"shopSortArr":@[@"推荐",@"距离由近到远",@"评分由高到低",@"价格由高到低",@"价格由低到高"],@"midTitle":@"排序"},
                         @{@"shopSortArr":@[@"全部品牌",@"如家",@"7天",@"汉庭",@"锦江之星"],@"midTitle":@"品牌"},
                         @{@"shopSortArr":@[@"经济型酒店",@"高端酒店",@"主题酒店",@"度假酒店",@"公寓型酒店",@"客栈",@"青年旅社"],@"midTitle":@"筛选"}];
            
            break;
        }
        case FromFoodVCToTitleContentVC://美食排序
        case FromKTVVCToTitleContentVC:{//KTV排序
            paramArr = @[@{@"shopSortArr":@[@"推荐",@"距离由近到远",@"评分由高到低",@"价格由高到低",@"价格由低到高"],@"midTitle":@"排序"},
                         @{@"shopSortArr":@[@"全聚德",@"海底捞",@"眉州小吃",@"呷浦呷哺",@"肯德基",@"必胜客"
],@"midTitle":@"品牌"},
                         @{@"shopSortArr":@[@"甜点饮品",@"火锅",@"自助餐",@"小吃快餐",@"日韩料理",@"西餐",@"烧烤烤肉",@"素食"],@"midTitle":@"筛选"}];
            break;
        }
         

            
        default:
            break;
    }
    
    
    NSMutableDictionary *nextParamDic = [[NSMutableDictionary alloc] initWithDictionary:@{KFromClassType:@(ZSHFromFoodVCToBottomBlurPopView)}];
    [nextParamDic addEntriesFromDictionary:paramArr[index]];
    [nextParamDic setObject:@(index) forKey:@"index"];
    [nextParamDic setObject:@(self.contentVCS.count) forKey:@"count"];
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [bottomBlurPopView setBlurEnabled:NO];
    [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
    bottomBlurPopView.dissmissViewBlock = ^(UIView *blurView, NSIndexPath *indexpath) {
        [ZSHBaseUIControl setAnimationWithHidden:YES view:blurView completedBlock:^{
            if (indexpath) {//跳转到对应控制器
                //                        Class className = NSClassFromString(weakself.menuPushVCsArr[indexpath.row]);
                //                        RootViewController *vc = [[className alloc]initWithParamDic:weakself.menuParamArr[indexpath.row]];
                //                        [weakself.navigationController pushViewController:vc animated:YES];
            }
            return;
        }];
    };
    
//    NSDictionary *nextParamDic = @{@"type":@(WindowDefault),@"midTitle":paramArr[index][@"midTitle"],@"dataArr":paramArr[index][@"shopSortArr"]};
//    weakself.pickView = [weakself createPickViewWithParamDic:nextParamDic];
//    [weakself.pickView show:WindowDefault];
//    weakself.pickView.saveChangeBlock = ^(NSString *rowTitle, NSInteger tag) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:KUpdateDataWithSort object:@{@"row":@(tag),@"midTitle":paramArr[index][@"midTitle"],@"rowTitle":rowTitle,KFromClassType:@(kFromClassTypeValue)}];
//    };
    
}

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
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[@"阿哲", @"散打哥", @"天佑", @"赵小磊", @"赵雷", @"陈山", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"PYExampleSearchPlaceholderText", @"搜索") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view conroller
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYHotSearchStyleARCBorderTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleARCBorderTag;
    searchViewController.searchBarBackgroundColor = KZSHColor1A1A1A;
    
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
//    RootNavigationController *nav = [[RootNavigationController alloc] initWithRootViewController:searchViewController];
//    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

//头条-发布
- (void)distributeAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
