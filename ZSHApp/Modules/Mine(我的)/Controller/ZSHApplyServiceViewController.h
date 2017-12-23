//
//  ZSHApplyServiceViewController.h
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger,ZSHFromVCToApplyServiceVC){
    ZSHromAllOrderVCToApplyServiceVC,          //我的订单-售后
    ZSHFromGoodsMineVCToApplyServiceVC,        //我的订单-退款售后
};

@interface ZSHApplyServiceViewController : RootViewController

@end
