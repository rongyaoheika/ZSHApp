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

#import <AlivcLivePusher/AlivcLivePusherHeader.h>
#import "AlivcLivePusherViewController.h"
@interface ZSHLiveTabBarController ()<TabBarDelegate>

@property (nonatomic, strong) NSMutableArray             *VCS;   //tabbar root VC
@property (nonatomic, strong) UIView                     *baseView;
@property (nonatomic, strong) ZSHBottomBlurPopView       *bottomBlurPopView;


@property (nonatomic, assign) BOOL isUseAsync; // 是否使用异步接口
@property (nonatomic, assign) BOOL isUseWatermark; // 是否使用水印
@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;

@end

@implementation ZSHLiveTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化tabbar
    [self setUpTabBar];
    
    //添加子控制器
    [self setUpAllChildViewController];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentPreViewVC) name:KPresentPreviewVC object:nil];
}

- (void)presentPreViewVC{
    self.pushConfig = [[AlivcLivePushConfig alloc] init];
    self.pushConfig.resolution = AlivcLivePushResolution540P;//分辨率：默认为540P，最大支持720P，兼容V1.3.0版1080P
    
    self.pushConfig.qualityMode = AlivcLivePushQualityModeResolutionFirst;// 清晰度优先模式
    self.pushConfig.targetVideoBitrate = 1200; //  目标码率1200Kbps
    self.pushConfig.minVideoBitrate = 600; //  最小码率400Kbps
    self.pushConfig.initialVideoBitrate = 1000; //  初始码率900Kbps
    self.pushConfig.audioBitrate = 64; // 音频码率
    self.pushConfig.audioSampleRate = 32; // 音频采样率
    self.pushConfig.fps = AlivcLivePushFPS20; //建议用户使用20fps
    self.pushConfig.minFps = 8;//最小帧率
    self.pushConfig.videoEncodeGop = AlivcLivePushVideoEncodeGOP_2;//关键帧间隔：默认值为2
    self.pushConfig.connectRetryInterval = 2000; // 单位为毫秒，重连时长2s
    self.pushConfig.connectRetryCount = 5; //重连次数
    self.pushConfig.orientation = AlivcLivePushOrientationPortrait; // 横屏推流
    self.pushConfig.audioChannel = AlivcLivePushAudioChannel_2;  //双声道
    self.pushConfig.audioEncoderProfile = AlivcLivePushAudioEncoderProfile_AAC_LC; //音频格式
    
    self.pushConfig.pushMirror = YES;     // 关闭预览镜像
    self.pushConfig.previewMirror = YES; // 关闭预览镜像
    self.pushConfig.audioOnly = NO;//纯音频
    self.pushConfig.videoEncoderMode = AlivcLivePushVideoEncoderModeHard; //硬编
    self.pushConfig.videoOnly = NO; //纯视频
    self.pushConfig.autoFocus = YES;//自动对焦
    self.pushConfig.flash = NO;//开启闪光灯
    self.pushConfig.beautyOn = YES; // 打开美颜
    self.pushConfig.cameraType = AlivcLivePushCameraTypeFront; //前置摄像头
    self.isUseAsync = YES;//异步接口
//    self.isUseWatermark = YES;//使用水印
    self.pushConfig.beautyMode = AlivcLivePushBeautyModeProfessional;//美颜模式：人脸识别专业版本
    
    // 美白范围0-100
    self.pushConfig.beautyWhite = 70;
    // 磨皮范围0-100
    self.pushConfig.beautyBuffing = 40;
    // 红润设置范围0-100
    self.pushConfig.beautyRuddy = 40;
    /* 下面接口是人脸识别下的高级美颜参数 */
    // 腮红设置范围0-100
    self.pushConfig.beautyCheekPink = 15;
    // 大眼设置范围0-100
    self.pushConfig.beautyBigEye = 30;
    // 瘦脸设置范围0-100
    self.pushConfig.beautyThinFace = 40;
    // 收下巴设置范围0-100
    self.pushConfig.beautyShortenFace = 50;
    
    
    
//    NSString *watermarkBundlePath01 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"watermark"] ofType:@"png"];
//    [self.pushConfig addWatermarkWithPath: watermarkBundlePath01
//                          watermarkCoordX:0.1
//                          watermarkCoordY:0.1
//                           watermarkWidth:0.15];
//    
//    NSString *watermarkBundlePath02 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"watermark"] ofType:@"png"];
//    [self.pushConfig addWatermarkWithPath: watermarkBundlePath02
//                          watermarkCoordX:0.1
//                          watermarkCoordY:0.3
//                           watermarkWidth:0.15];
//    NSString *watermarkBundlePath03 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"watermark"] ofType:@"png"];
//    [self.pushConfig addWatermarkWithPath: watermarkBundlePath03
//                          watermarkCoordX:0.1
//                          watermarkCoordY:0.5
//                           watermarkWidth:0.15];
    
    AlivcLivePusherViewController *publisherVC = [[AlivcLivePusherViewController alloc] init];
    publisherVC.pushURL = AlivcTextPushURL;
    publisherVC.pushConfig = self.pushConfig;
    publisherVC.isUseAsyncInterface = YES;
    [self presentViewController:publisherVC animated:YES completion:nil];
    
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
        self.tabBar.barTintColor = KZSHColor0B0B0B;
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
    
    self.TabBar.tabBarItemCount = viewControllers.count + 1;
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
    if (to>0) {
        self.selectedIndex = to-1;
    } else {
        self.selectedIndex = to;
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

@end
