//
//  ZSHPersonalDetailViewController.h
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"


typedef NS_ENUM(NSInteger,ZSHToPersonalDetailVC){
    FromPersonalVCToPersonalDetailVC,                        //个人中心
    FromTabbarToPersonalDetailVC,                            //tabbar
    FromNoneToPersonalDetailVC
};

@interface ZSHPersonalDetailViewController : RootViewController

@end
