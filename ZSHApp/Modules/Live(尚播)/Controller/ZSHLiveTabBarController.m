//
//  ZSHLiveTabBarController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveTabBarController.h"
#import "RootNavigationController.h"
#import "TabBarItem.h"
#import "ZSHHomeViewController.h"
#import "ZSHTitleContentViewController.h"
#import "ZSHLiveMineViewController.h"
#import "MainTabBarController.h"
#import "RXLSideSlipViewController.h"
#import "ZSHBottomBlurPopView.h"

@interface ZSHLiveTabBarController ()<TabBarDelegate>

@property (nonatomic, strong) NSMutableArray             *VCS;   //tabbar root VC
@property (nonatomic, strong) UIView                     *baseView;
@property (nonatomic, strong) ZSHBottomBlurPopView       *bottomBlurPopView;

@end

@implementation ZSHLiveTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化tabbar
    [self setUpTabBar];
    
    //添加子控制器
    [self setUpAllChildViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.selectedIndex = 0;
     self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self removeOriginControls];
}

#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    [self.tabBar addSubview:({
        TabBar *tabBar = [[TabBar alloc] init];
        tabBar.toTabBarType = FromLiveTabVCToTabBar;
        tabBar.backgroundColor = KZSHColor0B0B0B;
        tabBar.frame     = self.tabBar.bounds;
        tabBar.delegate  = self;
        self.TabBar = tabBar;
    })];
    
}
#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    
    NSDictionary *nextParamDic = @{KFromClassType:@(FromLiveTabBarVCToTitleContentVC),@"title":@"尚播"};
    ZSHTitleContentViewController *liveVC = [[ZSHTitleContentViewController alloc]initWithParamDic:nextParamDic];
    [self setupChildViewController:liveVC title:@"尚播" imageName:@"tab_live_normal" seleceImageName:@"tab_live_press"];
    
    ZSHLiveMineViewController *mineVC = [[ZSHLiveMineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"live_mine_normal" seleceImageName:@"live_mine_press"];
    self.viewControllers = _VCS;
    
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    //    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];
    
    //    controller.tabBarItem.badgeValue = _VCS.count%2==0 ? @"100": @"1";
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    controller.title = title;
    [_VCS addObject:nav];
}

#pragma mark ————— 统一设置tabBarItem属性并添加到TabBar —————
- (void)setViewControllers:(NSArray *)viewControllers {
    
    self.TabBar.badgeTitleFont         = kPingFangRegular(10);
    self.TabBar.itemTitleFont          = kPingFangRegular(10);
    self.TabBar.itemImageRatio         = self.itemImageRatio == 0 ? 0.7 : self.itemImageRatio;
    self.TabBar.itemTitleColor         = KZSHColor929292;
    self.TabBar.selectedItemTitleColor = KZSHColorF29E19;
    
    self.TabBar.tabBarItemCount = viewControllers.count;
    
    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *VC = (UIViewController *)obj;
        UIImage *selectedImage = VC.tabBarItem.selectedImage;
        VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addChildViewController:VC];
        [self.TabBar addTabBarItem:VC.tabBarItem];
        if (idx == 0) {//直播item
            UITabBarItem *item = [[UITabBarItem alloc]init];
            item.image = [UIImage imageNamed:@"live_mid"];
            item.selectedImage = [UIImage imageNamed:@"live_mid"];
            self.TabBar.itemImageRatio = 0.9;
            [self.TabBar addTabBarItem:item];
        }
        self.TabBar.itemImageRatio = self.itemImageRatio == 0 ? 0.7 : self.itemImageRatio;
    }];
}

#pragma mark ————— 选中某个tab —————
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    self.TabBar.selectedItem.selected = NO;
    self.TabBar.selectedItem = self.TabBar.tabBarItems[selectedIndex];
    self.TabBar.selectedItem.selected = YES;
}

#pragma mark ————— 取出系统自带的tabbar并把里面的按钮删除掉 —————
- (void)removeOriginControls {
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * obj, NSUInteger idx, BOOL * stop) {
        if ([obj isKindOfClass:[UIControl class]]) {
            [obj removeFromSuperview];
        }
    }];
}

#pragma mark - TabBarDelegate Method

- (void)tabBar:(TabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    if (to == 1) {//中间直播button
        NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromLiveMidVCToBottomBlurPopView)};
        ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
        bottomBlurPopView.blurRadius = 20;
        bottomBlurPopView.dynamic = NO;
        bottomBlurPopView.tintColor = KClearColor;
        [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
        bottomBlurPopView.dissmissViewBlock = ^(UIView *blurView, NSIndexPath *indexpath) {
            [ZSHBaseUIControl setAnimationWithHidden:YES view:blurView completedBlock:nil];
        };
        return;
    }
    
    self.selectedIndex = to;
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
