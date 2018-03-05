//
//  ZSHFollowViewController.h
//  ZSHApp
//
//  Created by Apple on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger,ZSHToFollowVC){
    FromFocusVCToFollowVC,        // 关注
    FromFansVCToFollowVC,         // 粉丝
    FromNoneToFollowVC
};

@interface ZSHFollowViewController : RootViewController

@end
