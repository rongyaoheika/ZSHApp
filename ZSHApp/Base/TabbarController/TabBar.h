//
//  TabBar.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,ZSHToTabBarType) {
    FromMainTabVCToTabBar,         //主界面 - tabbar
    FromLiveTabVCToTabBar,         //尚播 - tabbar
    FromNoneVCToTabBar
};


@class TabBar, TabBarItem;

//给每个按钮定义协议 与 方法
@protocol TabBarDelegate <NSObject>

@optional
- (void)tabBar:(TabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface TabBar : UIView

@property (nonatomic, assign) ZSHToTabBarType  toTabBarType;

/**
 *  TabBar item title color
 */
@property (nonatomic, strong) UIColor *itemTitleColor;

/**
 *  TabBar selected item title color
 */
@property (nonatomic, strong) UIColor *selectedItemTitleColor;

/**
 *  TabBar item title font
 */
@property (nonatomic, strong) UIFont *itemTitleFont;

/**
 *  TabBar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

/**
 *  TabBar item image ratio
 */
@property (nonatomic, assign) CGFloat itemImageRatio;

/**
 *  TabBar's item count
 */
@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  TabBar's selected item
 */
@property (nonatomic, strong) TabBarItem *selectedItem;

/**
 *  TabBar items array
 */
@property (nonatomic, strong) NSMutableArray *tabBarItems;

/**
 *  TabBar delegate
 */
@property (nonatomic, weak) id<TabBarDelegate> delegate;

/**
 *  Add tabBar item
 */
- (void)addTabBarItem:(UITabBarItem *)item;

@end
