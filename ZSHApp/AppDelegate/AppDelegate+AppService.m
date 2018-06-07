//
//  AppDelegate+AppService.m
//  MiAiApp
//
//  Created by Apple on 2017/8/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "ZSHLoginViewController.h"
#import "OpenUDID.h"
#import "ZSHLeftContentViewController.h"
#import "RXLSideSlipViewController.h"
#import "ZSHLiveTabBarController.h"
#import "ZSHGuideViewController.h"
#import "ZegoAVKitManager.h"
#import "ZSHHomeLogic.h"
#import "ZSHTitleContentViewController.h"
#import "HCLocationManager.h"
#import "ZSHLiveMineViewController.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <AlipaySDK/AlipaySDK.h>
@implementation AppDelegate (AppService)


#pragma mark ————— 初始化服务 —————
-(void)initService{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];
    
    //网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
}

#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KClearColor;
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    //    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
    [self setUpFixiOS11];
}

#pragma mark - 适配
- (void)setUpFixiOS11
{
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
}

#pragma mark ————— 键盘响应 —————
- (void)initKeyboard{
    [ZSHBaseFunction initKeyboard];
}

#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    RLog(@"设备IMEI ：%@",[OpenUDID value]);
    if([userManager loadUserInfo]){
        
        //如果有本地数据，先展示TabBar 随后异步自动登录
        self.mainTabBarVC = [MainTabBarController new];
        self.window.rootViewController = self.mainTabBarVC;
        
        //自动登录
        [userManager autoLoginToServer:^(BOOL success, NSString *des) {
            if (success) {
                RLog(@"自动登录成功");
                //                    [MBProgressHUD showSuccessMessage:@"自动登录成功"];
                KPostNotification(KNotificationAutoLoginSuccess, nil);
            }else{
                [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
            }
        }];
        
    }else{
        //没有登录过，展示登录页面
        KPostNotification(KNotificationLoginStateChange, @NO)
        //                [MBProgressHUD showErrorMessage:@"需要登录"];
    }
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {//登陆成功加载主窗口控制器
        
        //为避免自动登录成功刷新tabbar
        if (!self.slipVC || ![self.window.rootViewController isKindOfClass:[RXLSideSlipViewController class]]) {
            self.mainTabBarVC = [MainTabBarController new];
            
            //侧滑栏
            ZSHLeftContentViewController *leftVC = [[ZSHLeftContentViewController alloc] init];
            RXLSideSlipViewController *RXL = [[RXLSideSlipViewController alloc] initWithContentViewController:self.mainTabBarVC leftMenuViewController:leftVC rightMenuViewController:nil];
            
            RXL.menuPreferredStatusBarStyle = UIStatusBarStyleDefault; // UIStatusBarStyleLightContent
            RXL.contentViewShadowColor = [UIColor blackColor];
            RXL.contentViewShadowOffset = CGSizeMake(0, 0);
            RXL.contentViewShadowOpacity = 0.6;
            RXL.contentViewShadowRadius = 12;
            RXL.contentViewShadowEnabled = YES; // 是否显示阴影
            RXL.contentPrefersStatusBarHidden = NO;//是否隐藏主视图的状态条
            RXL.scaleMenuView = NO;
            RXL.scaleContentView = NO;
            RXL.scaleBackgroundImageView = NO;
            RXL.panGestureEnabled = false;
            
            CATransition *anima = [CATransition animation];
            anima.type = @"cube";//设置动画的类型
            anima.subtype = kCATransitionFromRight; //设置动画的方向
            anima.duration = 0.3f;
            
            self.window.rootViewController = RXL;// self.mainTabBarVC;
            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
            
        }
        
    } else {//登陆失败加载登陆页面控制器
        self.mainTabBarVC = nil;
        self.slipVC = nil;
        RootNavigationController *loginNavi = [[RootNavigationController alloc] initWithRootViewController:[ZSHGuideViewController new]];
        
        CATransition *anima = [CATransition animation];
        anima.type = @"fade";//设置动画的类型
        anima.subtype = kCATransitionFromRight; //设置动画的方向
        anima.duration = 0.3f;
        
        self.window.rootViewController = loginNavi;
        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
        
    }
    //展示FPS
    //    [AppManager showFPS];
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    BOOL isNetWork = [notification.object boolValue];
    
    if (isNetWork) {//有网络
        if ([userManager loadUserInfo] && !isLogin) {//有用户数据 并且 未登录成功 重新来一次自动登录
            [userManager autoLoginToServer:^(BOOL success, NSString *des) {
                if (success) {
                    RLog(@"网络改变后，自动登录成功");
                    //                    [MBProgressHUD showSuccessMessage:@"网络改变后，自动登录成功"];
                    KPostNotification(KNotificationAutoLoginSuccess, nil);
                }else{
                    [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
                }
            }];
        }
        
    }else {//登陆失败加载登陆页面控制器
        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
    }
}


#pragma mark ————— 友盟 初始化 —————
-(void)initUMeng{
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:UMengKey channel:@"App Store"];
    
    // U-Share 平台设置
    [self configUSharePlatforms];
}
#pragma mark ————— 配置第三方 —————
-(void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppKey_Wechat appSecret:kAppSecret_Wechat redirectURL:KRedirectURL];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kAppKey_Tencent appSecret:nil redirectURL:nil];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kAppKey_Sina appSecret:kAppSecret_Sina redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

#pragma mark ————— OpenURL 回调 —————
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    result = [self payCallBack:result url:url];
    return result;
}


//仅支持iOS9以上系统，iOS8及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    //友盟回调
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    result = [self payCallBack:result url:url];
    return result;
}

//支持目前所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //友盟回调
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    result = [self payCallBack:result url:url];
    return result;
}

//支付回调
- (BOOL)payCallBack:(BOOL)result url:(NSURL *)url{
    if (!result && [url.host isEqualToString:@"safepay"]) {//支付宝回调
        result = YES;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            RLog(@"支付宝支付回调结果= = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:kAliPayCallBack object:resultDic];
        }];
    }
    
    if (!result) {// 微信回调
        result = [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

//微信支付回调
#pragma mark 微信回调方法
- (void)onResp:(BaseResp *)resp{
    NSString * strMsg = [NSString stringWithFormat:@"errorCode: %d",resp.errCode];
    RLog(@"strMsg: %@",strMsg);
    
    NSString * errStr = [NSString stringWithFormat:@"errStr: %@",resp.errStr];
    RLog(@"errStr: %@",errStr);
    
    
    NSString * strTitle;
    //判断是微信消息的回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        strTitle = [NSString stringWithFormat:@"发送媒体消息的结果"];
    }
    
    
    NSString * wxPayResult;
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    if ([resp isKindOfClass:[PayResp class]]){
        //支付返回的结果, 实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode){
            case WXSuccess:
            {
                strMsg = @"支付结果:";
                RLog(@"支付成功: %d",resp.errCode);
                wxPayResult = @"success";
                break;
            }
            case WXErrCodeUserCancel:
            {
                strMsg = @"用户取消了支付";
                RLog(@"用户取消支付: %d",resp.errCode);
                wxPayResult = @"cancel";
                break;
            }
            default:
            {
                strMsg = [NSString stringWithFormat:@"支付失败! code: %d  errorStr: %@",resp.errCode,resp.errStr];
                RLog(@":支付失败: code: %d str: %@",resp.errCode,resp.errStr);
                wxPayResult = @"faile";
                break;
            }
        }
        
        //发出通知
//        NSNotification * notification = [NSNotification notificationWithName:kWXPayCallBack object:wxPayResult];
        [[NSNotificationCenter defaultCenter] postNotificationName:kWXPayCallBack object:nil];
    }
}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
        
        switch (networkStatus) {
                // 未知网络
            case PPNetworkStatusUnknown:
                RLog(@"网络环境：未知网络");
                // 无网络
            case PPNetworkStatusNotReachable:
                RLog(@"网络环境：无网络");
                KPostNotification(KNotificationNetWorkStateChange, @NO);
                break;
                // 手机网络
            case PPNetworkStatusReachableViaWWAN:
                RLog(@"网络环境：手机自带网络");
                // 无线网络
            case PPNetworkStatusReachableViaWiFi:
                RLog(@"网络环境：WiFi");
                KPostNotification(KNotificationNetWorkStateChange, @YES);
                break;
        }
        
    }];
}

+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


-(UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    if ([superVC isKindOfClass:[RXLSideSlipViewController class]]) {
        RXLSideSlipViewController *RXL = (RXLSideSlipViewController *)superVC;
        MainTabBarController *tabVC = (MainTabBarController *)RXL.contentViewController;
        RootNavigationController *nav = [tabVC selectedViewController];
        if ([nav.viewControllers.lastObject isKindOfClass:[ZSHLiveTabBarController class]]) {
            ZSHLiveTabBarController *liveTabVC = (ZSHLiveTabBarController *)nav.viewControllers.lastObject;
            RootNavigationController *liveTabNav = [liveTabVC selectedViewController];
            if ([liveTabNav.viewControllers.lastObject isKindOfClass:[ZSHLiveMineViewController class]]) {
                ZSHLiveMineViewController *liveMinVC = liveTabNav.viewControllers.lastObject;
                return liveMinVC;
            } else {
                ZSHTitleContentViewController *liveContentVC = liveTabNav.viewControllers.lastObject;
                RootViewController *liveVC = liveContentVC.vcs[liveContentVC.vcIndex];
                return liveVC;
            }
        } else {
            return nav.viewControllers.lastObject;
        }
    }
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    } else if ([superVC isKindOfClass:[UINavigationController class]]) {
        
        return ((UINavigationController*)superVC).viewControllers.lastObject;
    }
    return superVC;
}

- (void)initZego{
    [ZegoAVKitManager api];
}

//初始化微信支付
-(void)initWXPaySDK{
    [WXApi registerApp:kAppKey_Wechat];
}


@end
