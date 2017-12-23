//
//  ZSHVideoViewController.h
//  ZSHApp
//
//  Created by apple on 2017/11/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger,ZSHToVideoVC){
    FromPersonalVCToVideoVC,                        //个人中心
    FromTabbarToVideoVC,                            //tabbar
    FromNoneToVideoVC
};


@interface ZSHVideoViewController : RootViewController

@end
