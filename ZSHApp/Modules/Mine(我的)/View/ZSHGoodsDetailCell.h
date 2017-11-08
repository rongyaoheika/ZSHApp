//
//  ZSHGoodsDetailCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

typedef NS_ENUM(NSInteger,ZSHFromVCToGoodsDetailCell){
    ZSHFromConfirmOrderVCToGoodsDetailCell,
    ZSHFromOrderDetailVCToGoodsDetailCell
};

@interface ZSHGoodsDetailCell : ZSHBaseCell

@property(nonatomic, assign) NSInteger  fromClassType;
@end
