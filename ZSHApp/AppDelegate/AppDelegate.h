//
//  AppDelegate.h
//  MiAiApp
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
#import "RXLSideSlipViewController.h"
#import "WXApi.h"
/**
 这里面只做调用，具体实现放到 AppDelegate+AppService 或者Manager里面，防止代码过多不清晰
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) MainTabBarController      *mainTabBarVC;
@property (nonatomic, strong) RXLSideSlipViewController *slipVC;

@end

