//
//  TabBarBadge.h
//  MiAiApp
//
//  Created by Apple on 2017/8/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 tabbar 红点
 */
@interface TabBarBadge : UIButton

/**
 *  TabBar item badge value
 */
@property (nonatomic, copy) NSString *badgeValue;

/**
 *  TabBar's item count
 */
@property (nonatomic, assign) NSInteger tabBarItemCount;

/**
 *  TabBar item's badge title font
 */
@property (nonatomic, strong) UIFont *badgeTitleFont;

@end
