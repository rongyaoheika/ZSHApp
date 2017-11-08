//
//  ZSHEnterTainmentCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

typedef NS_ENUM(NSInteger,ZSHFromVCToEnterTainmentCell){
    ZSHFromEnterTainmentVCToEnterTainmentCell,     //娱乐
    ZSHFromActivityVCToEnterTainmentCell,          //活动中心
    ZSHFromNoneVCToEnterTainmentCell
};

@interface ZSHEnterTainmentCell : ZSHBaseCell


@property (nonatomic, assign) ZSHFromVCToEnterTainmentCell    fromClassType;

@end
