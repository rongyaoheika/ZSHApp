//
//  ZSHLiveTabBarController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSHLiveTabBarController : UITabBarController

/**
 *  TabBar
 */
@property (nonatomic, strong) TabBar *TabBar;

/**
 * tabbar 图片占比，默认 0.7f， 如果是1 就没有文字
 */
@property (nonatomic, assign) CGFloat itemImageRatio;

/**
 *  System will display the original controls so you should call this line when you change any tabBar item, like: `- popToRootViewController`, `someViewController.tabBarItem.title = xx`, etc.
 *  Remove origin controls
 */
- (void)removeOriginControls;


@end
