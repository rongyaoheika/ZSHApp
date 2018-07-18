//
//  TabBar.m
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "TabBar.h"
#import "TabBarItem.h"

@interface TabBar()

@end

@implementation TabBar

- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        
        _tabBarItems = [[NSMutableArray alloc] init];
    }
    return _tabBarItems;
}

- (void)addTabBarItem:(UITabBarItem *)item {
    
    TabBarItem *tabBarItem = [[TabBarItem alloc] initWithItemImageRatio:self.itemImageRatio];
    
    tabBarItem.badgeTitleFont         = self.badgeTitleFont;
    tabBarItem.itemTitleFont          = self.itemTitleFont;
    tabBarItem.itemTitleColor         = self.itemTitleColor;
    tabBarItem.selectedItemTitleColor = self.selectedItemTitleColor;
    
    tabBarItem.tabBarItemCount = self.tabBarItemCount;
    tabBarItem.tabBarItem = item;
    [tabBarItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tabBarItem];
    [self.tabBarItems addObject:tabBarItem];
    if (self.tabBarItems.count == 1) {
        [self buttonClick:tabBarItem];
    }
}

- (void)buttonClick:(TabBarItem *)tabBarItem {
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)]) {
        [self.delegate tabBar:self didSelectedItemFrom:self.selectedItem.tabBarItem.tag to:tabBarItem.tag];
    }
    
    if (tabBarItem.tag == 1 && self.toTabBarType == FromLiveTabVCToTabBar) {//直播中间按钮
        return;
    }
    self.selectedItem.selected = NO;
    self.selectedItem = tabBarItem;
    self.selectedItem.selected = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    int count = (int)self.tabBarItems.count;
    CGFloat itemY = 0;
    CGFloat itemW = w / self.subviews.count;
    CGFloat itemH = h;
    
    if (self.toTabBarType == FromMainTabVCToTabBar) {
        for (int index = 0; index < count; index++) {
            TabBarItem *tabBarItem = self.tabBarItems[index];
            tabBarItem.tag = index;
            CGFloat itemX = index * itemW;
            tabBarItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
        }
    } else if (self.toTabBarType == FromLiveTabVCToTabBar){
        for (int index = 0; index < count; index++) {
            TabBarItem *tabBarItem = self.tabBarItems[index];
            tabBarItem.tag = index;
            CGFloat itemX = index * itemW;
            tabBarItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
            
            if (index == 0) {//尚播
                tabBarItem.frame = CGRectMake(0,itemY, kRealValue(150), itemH);
            } else if (index == 1){//直播
                [tabBarItem mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self);
                    make.size.mas_equalTo(CGSizeMake(kRealValue(35), kRealValue(35)));
                    make.top.mas_equalTo(self).offset(kRealValue(5));
                }];
            } else if (index == 2){//我的
                tabBarItem.frame = CGRectMake(kScreenWidth - kRealValue(150),itemY, kRealValue(150), itemH);
            }
        }
    }
}


@end
