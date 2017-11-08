//
//  ZSHIntegralExchangeCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

typedef NS_ENUM(NSInteger,RLJKToIntegralExchangeCell){
    FromExchangeVCToIntegralExchangeCell,    //积分兑换 - 自定义cellView
    FromCouponVCToIntegralExchangeCell,      //优惠券 - 自定义cellView
    FromNoneVCToIntegralExchangeCell
};

@interface ZSHIntegralExchangeCell : ZSHBaseCell

//兑换
@property (nonatomic, copy) dispatch_block_t exchangeBlock;

@end
