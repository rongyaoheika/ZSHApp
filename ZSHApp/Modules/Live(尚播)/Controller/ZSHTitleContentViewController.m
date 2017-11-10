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
    switch ([self.paramDic[@"fromClassType"]integerValue]) {
        case FromLiveTabBarVCToTitleContentVC:{
            self.titleArr = @[@"推荐",@"附近",@"分类"];
            self.indicatorHeight = 1.0;
            [self createLiveNaviUI];
            
            break;
        }
        case FromFindVCToTitleContentVC:{
            self.titleArr = @[@"精选",@"数码",@"亲子",@"时尚",@"美食"];
            self.indicatorHeight = 0.0;
            
            break;
        }
        case FromAllOrderVCToTitleContentVC:{
            self.titleArr = @[@"全部",@"待付款",@"待收货",@"待评价",@"退款售后"];
            self.indicatorHeight = 0.0;
            
            break;
        }
        case FromIntegralVCToTitleContentVC:{
            self.titleArr = @[@"全部",@"收入",@"支出"];
            self.indicatorHeight = 1.0;
            
            break;
        }
        case FromHotelVCToTitleContentVC:
        case FromFoodVCToTitleContentVC:{
            self.titleArr = @[@"排序",@"品牌",@"筛选"];
            self.titleImage = @"hotel_btn";
            self.indicatorHeight = 0.0;
            [self createHotelNaviUI];
            break;
        }
        case FromPlaneTicketVCToTitleContentVC:{
            self.titleArr = @[@"价格",@"时间",@"准确率"];
            self.titleImage = @"hotel_btn";
            self.indicatorHeight = 0.0;
            [self createTicketNaviUI];
            break;
        }
        case FromActivityCenterVCToTitleContentVC:{
            self.titleArr = @[@"我发布的",@"我参与的"];
            self.indicatorHeight = 0.0;
            break;
        }
        
        default:
            break;
    }
    
    self.titleWidth = KScreenWidth/(self.titleArr.count);
    self.contentVCS = @[@"ZSHLiveContentFirstViewController",@"ZSHFindViewController",@"ZSHOrderSubViewController",@"ZSHIntegralBillViewController",@"ZSHHotelViewController",@"ZSHFoodViewController",@"ZSHMoreTicketViewController",@"ZSHActivityViewController"];
}

- (void)createLiveNaviUI{
    [self.navigationItem setTitleView:self.searchBar];
    self.searchBar.delegate = self;
    
    [self addNavigationItemWithImageName:@"nav_home_more" title:@"三亚" locate:XYButtonEdgeInsetsStyleRight isLeft:YES target:self action:@selector(locateBtnAction) tag:10];
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
            if ([weakSelf.paramDic[@"fromClassType"]integerValue] == FromHotelVCToTitleContentVC && index == 0) {
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
    
    Class className = NSClassFromString(self.contentVCS[[self.paramDic[@"fromClassType"]integerValue]]);
    for (int i = 0; i<self.titleArr.count; i++) {
        UIViewController *vc =  [[className alloc]init];
        [self.vcs addObject:vc];
    }
    
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
}

#pragma  getter
- (ZSHBottomBlurPopView *)bottomBlurPopView{
    NSDictionary *nextParamDic = @{@"fromClassType":@(ZSHFromHotelVCToBottomBlurPopView)};
    _bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
    _bottomBlurPopView.blurRadius = 20;
    _bottomBlurPopView.dynamic = NO;
    _bottomBlurPopView.tintColor = KClearColor;
    return _bottomBlurPopView;
}

#pragma action
- (void)locateBtnAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
