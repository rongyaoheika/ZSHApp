//
//  ZSHAirPlaneViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger,ZSHFromVCToAirPlaneVC){//** -> 票预订页面
    ZSHHomeAirPlaneVCToAirPlaneVC,               //飞机票预订
    ZSHFromHomeTrainVCToAirPlaneVC,              //火车票预订
    ZSHFromNoneVCToAirPlaneVC
};

@interface ZSHAirPlaneViewController : RootViewController

@end
