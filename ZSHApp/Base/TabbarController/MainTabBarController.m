//
//  MainTabBarController.m
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "MainTabBarController.h"
#import "RootNavigationController.h"
#import "TabBarItem.h"
#import "ZSHHomeViewController.h"
#import "ZSHTogetherViewController.h"
#import "ZSHMineViewController.h"
#import "ZSHLiveTabBarController.h"
#import "ZSHTitleContentViewController.h"

@interface MainTabBarController ()<TabBarDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray * VCS;   //tabbar root VC

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tabbar
    [self setUpTabBar];
    
    //添加子控制器
    [self setUpAllChildViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self removeOriginControls];
}

#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    [self.tabBar addSubview:({
        self.tabBar.barTintColor = KZSHColor0B0B0B;
        TabBar *tabBar = [[TabBar alloc] init];
        tabBar.toTabBarType = FromMainTabVCToTabBar;
        tabBar.backgroundColor = KZSHColor0B0B0B;
        tabBar.frame     = self.tabBar.bounds;
        tabBar.delegate  = self;
        self.TabBar = tabBar;
    })];
    
}
#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;
    
    ZSHHomeViewController *homeVC = [[ZSHHomeViewController alloc]init];
    [self setupChildViewController:homeVC title:@"RYHK" imageName:@"tab_home_normal" seleceImageName:@"tab_home_press"];
    
    NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToTitleContentVC),@"title":@"尊购"};
    ZSHTitleContentViewController *buyVC = [[ZSHTitleContentViewController alloc]initWithParamDic:nextParamDic];
    [self setupChildViewController:buyVC title:@"尊购" imageName:@"tab_buy_normal" seleceImageName:@"tab_buy_press"];
    
    ZSHLiveTabBarController *liveVC = [[ZSHLiveTabBarController alloc]init];
    liveVC.delegate = self;
    [self setupChildViewController:liveVC title:@"尚播" imageName:@"tab_live_normal" seleceImageName:@"tab_live_press"];
    
    ZSHTogetherViewController *togetherVC = [[ZSHTogetherViewController alloc]init];
    [self setupChildViewController:togetherVC title:@"汇聚" imageName:@"tab_together_normal" seleceImageName:@"tab_together_press"];
    
    ZSHMineViewController *mineVC = [[ZSHMineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"tab_mine_normal" seleceImageName:@"tab_mine_press"];
    
    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    //    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [UIImage imageNamed:imageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:selectImageName];

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
    self.selectedIndex = to;
    if (self.selectedIndex ==2) {
         self.navigationController.navigationBarHidden = YES ;
        self.tabBar.hidden = YES;
    }
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return ![viewController isEqual:tabBarController.viewControllers[1]];
}


@end
