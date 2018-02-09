//
//  ZSHLiveContentFirstViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM (NSInteger,ZSHToLiveContentFirstVC) {
    FromLiveRecommendVCToLiveContentFirstVC,         //尚播 - 推荐
    FromLiveNearVCToLiveContentFirstVC,              //尚播 - 附近
    FromLiveClassifyVCToLiveContentFirstVC,          //尚播 - 分类
    FromActivityCenterVCToLiveContentFirstVC,
    FromOtherVCToLiveContentFirstVC                  //尚播 - 其他
};

@interface ZSHLiveContentFirstViewController : RootViewController

@end
