//
//  ZSHSubscribeViewController.h
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger,ZSHToSubscribeVC){
    FromHorseVCToSubscribeVC,        // 马术
    FromShipVCToSubscribeVC,         // 游艇
    FromCarVCToSubscribeVC,          // 豪车
    FromHelicopterVCToSubscribeVC,   // 飞机
    FromGolfVCToSubscribeVC,         // 高尔夫
    FromNoneToSubscribeVC
};

@interface ZSHSubscribeViewController : RootViewController



@end
