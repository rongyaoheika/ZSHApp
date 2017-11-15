//
//  ZSHServiceCenterViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"
typedef NS_ENUM(NSUInteger,ZSHFromVCToServiceCenterVC){//** -> 订单支付页面
    ZSHFromMineServiceVCToServiceCenterVC,        //我的-客服中心
    ZSHFromMineFriendVCToServiceCenterVC,         //我的-好友
    ZSHFromHomeMenuVCToServiceCenterVC,           //首页菜单-系统通知
//    ZSHFrom                       //
    ZSHFromNoneVCToServiceCenterVC
};
@interface ZSHServiceCenterViewController : RootViewController

@end
