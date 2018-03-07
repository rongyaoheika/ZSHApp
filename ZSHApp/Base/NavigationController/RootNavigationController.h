//
//  RootNavigationController.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "RxWebViewNavigationViewController.h"

/**
 导航控制器基类
 */
@interface RootNavigationController : UINavigationController//RxWebViewNavigationViewController

/*!
 *  返回到指定的类视图
 *
 *  @param ClassName 类名
 *  @param animated  是否动画
 */
-(BOOL)popToAppointViewController:(NSString *)ClassName animated:(BOOL)animated;

- (void)setupMainStype;
- (void)setupTransparentStyle;

@end
