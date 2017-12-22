//
//  ZSHWeiboViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger,ZSHToWeiboVC){
    FromPersonalVCToWeiboVC,                        // 尚播-个人中心
    FromTabbarToWeiboVC,                            // tabbar
    FromSelectToWeiboVC,                            // 筛选
    FromMineVCToWeiboVC,                            // 我的圈子中心
    FromNoneToWeiboVC
};


@interface ZSHWeiboViewController : RootViewController

@end
