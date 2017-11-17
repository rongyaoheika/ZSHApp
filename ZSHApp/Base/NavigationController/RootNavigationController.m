//
//  RootNavigationController.m
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RootNavigationController.h"
#import "XYTransitionProtocol.h"
#import "XYTransition.h"
#import "UIImage+BlurGlass.h"

@interface RootNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak)   id popDelegate;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition  *interactivePopTransition;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer      *popRecognizer;
@property (nonatomic, assign) BOOL                                  isSystemSlidBack;//是否开启系统右滑返回
@end

@implementation RootNavigationController

//APP生命周期中 只会执行一次
+ (void)initialize
{
    //设置导航栏背景色
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:KZSHColor0B0B0B];
    
    //设置导航栏字体颜色
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = KZSHColor929292;
    attr[NSFontAttributeName] = kPingFangMedium(17);
    [navBar setTitleTextAttributes:attr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    
    self.interactivePopGestureRecognizer.enabled = YES;
    _popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
    //    _popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
    //    _popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
    _popRecognizer.edges = UIRectEdgeLeft;
    [_popRecognizer setEnabled:NO];
    [self.view addGestureRecognizer:_popRecognizer];
}

//解决手势失效问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }else{
        self.interactivePopGestureRecognizer.delegate = self;
    }
    if (_isSystemSlidBack) {
        self.interactivePopGestureRecognizer.enabled = YES;
        [_popRecognizer setEnabled:NO];
    }else{
        self.interactivePopGestureRecognizer.enabled = NO;
        [_popRecognizer setEnabled:YES];
    }
}

//push时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        if ([viewController conformsToProtocol:@protocol(XYTransitionProtocol)] && [self isNeedTransition:viewController]) {
            viewController.hidesBottomBarWhenPushed = NO;
        } else {
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }
    
    [super pushViewController:viewController animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([viewController isKindOfClass:[RootViewController class]]) {
        RootViewController * vc = (RootViewController *)viewController;
        if (vc.isHidenNaviBar) {
            [vc.navigationController setNavigationBarHidden:YES animated:animated];
        }else{
            [vc.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
}

/**
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
-(BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated
{
    id vc = [self getCurrentViewControllerClass:ClassName];
    if(vc != nil && [vc isKindOfClass:[UIViewController class]])
    {
        [self popToViewController:vc animated:animated];
        return YES;
    }
    
    return NO;
}

/*!
 *  获得当前导航器显示的视图
 *
 *  @param ClassName 要获取的视图的名称
 *
 *  @return 成功返回对应的对象，失败返回nil;
 */
-(instancetype)getCurrentViewControllerClass:(NSString *)ClassName
{
    Class classObj = NSClassFromString(ClassName);
    
    NSArray * szArray =  self.viewControllers;
    for (id vc in szArray) {
        if([vc isMemberOfClass:classObj])
        {
            return vc;
        }
    }
    
    return nil;
}

-(UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}


#pragma mark ————— 转场动画区 —————

//navigation切换是会走这个代理
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    RLog(@"转场动画代理方法");
    self.isSystemSlidBack = YES;
    //如果来源VC和目标VC都实现协议，那么都做动画
    if ([fromVC conformsToProtocol:@protocol(XYTransitionProtocol)] && [toVC conformsToProtocol:@protocol(XYTransitionProtocol)]) {
        
        BOOL pinterestNedd = [self isNeedTransition:fromVC:toVC];
        XYTransition *transion = [XYTransition new];
        if (operation == UINavigationControllerOperationPush && pinterestNedd) {
            transion.isPush = YES;
            
            //暂时屏蔽带动画的右划返回
            self.isSystemSlidBack = NO;
            //            self.isSystemSlidBack = YES;
        }
        else if(operation == UINavigationControllerOperationPop && pinterestNedd)
        {
            //暂时屏蔽带动画的右划返回
            //            return nil;
            
            transion.isPush = NO;
            self.isSystemSlidBack = NO;
        }
        else{
            return nil;
        }
        return transion;
    }else if([toVC conformsToProtocol:@protocol(XYTransitionProtocol)]){
        //如果只有目标VC开启动画，那么isSystemSlidBack也要随之改变
        BOOL pinterestNedd = [self isNeedTransition:toVC];
        self.isSystemSlidBack = !pinterestNedd;
        return nil;
    }
    return nil;
}

//判断fromVC和toVC是否需要实现pinterest效果
-(BOOL)isNeedTransition:(UIViewController<XYTransitionProtocol> *)fromVC :(UIViewController<XYTransitionProtocol> *)toVC
{
    BOOL a = NO;
    BOOL b = NO;
    if ([fromVC respondsToSelector:@selector(isNeedTransition)] && [fromVC isNeedTransition]) {
        a = YES;
    }
    if ([toVC respondsToSelector:@selector(isNeedTransition)] && [toVC isNeedTransition]) {
        b = YES;
    }
    return (a && b) ;
    
}
//判断fromVC和toVC是否需要实现pinterest效果
-(BOOL)isNeedTransition:(UIViewController<XYTransitionProtocol> *)toVC
{
    BOOL b = NO;
    if ([toVC respondsToSelector:@selector(isNeedTransition)] && [toVC isNeedTransition]) {
        b = YES;
    }
    return b;
    
}

#pragma mark -- NavitionContollerDelegate
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (!self.interactivePopTransition) { return nil; }
    return self.interactivePopTransition;
}


#pragma mark UIGestureRecognizer handlers

- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    //    progress = MIN(1.0, MAX(0.0, progress));
    RLog(@"右划progress %.2f",progress);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        
        if (progress > 0.5 || velocity.x >100) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        self.interactivePopTransition = nil;
    }
}

#pragma mark ————— 屏幕旋转 —————
- (BOOL)shouldAutorotate
{
    //也可以用topViewController判断VC是否需要旋转
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //也可以用topViewController判断VC支持的方向
    return self.topViewController.supportedInterfaceOrientations;
}

//显示navigationbar
- (void)setupMainStype{
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = nil;
}

//navigationbar背景透明
- (void)setupTransparentStyle{
    self.navigationBar.translucent = YES;
    UIImage *img = [UIImage imageWithColor:KClearColor AndSize:CGSizeMake(kScreenWidth, 64)];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
