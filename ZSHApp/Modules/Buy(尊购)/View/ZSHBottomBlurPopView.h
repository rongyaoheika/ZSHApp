//
//  ZSHBottomBlurPopView.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FXBlurView.h"
#import "ZSHBaseTableViewModel.h"

typedef NS_ENUM(NSUInteger,ZSHFromVCToBottomBlurPopView){
    ZSHFromHotelVCToBottomBlurPopView,                       //酒店-底部弹出
    ZSHFromExchangeVCToBottomBlurPopView,                    //兑换-底部弹出
    ZSHFromHotelDetailConfirmOrderVCToBottomBlurPopView,     //酒店订单-底部弹出
    ZSHFromHotelDetailCalendarVCToBottomBlurPopView,         //酒店入住日历-底部弹出
    ZSHFromKTVConfirmOrderVCToBottomBlurPopView,             //KTV订单-底部弹出
    ZSHFromAirplaneCalendarVCToBottomBlurPopView,            //机票-底部弹出
    ZSHFromAirplaneSeatTypeVCToBottomBlurPopView,            //机票坐席类型-底部弹出
    ZSHFromAirplaneUserInfoVCToBottomBlurPopView,            //机票个人信息-底部弹出
    ZSHFromAirplaneAgeVCToBottomBlurPopView,                 //年龄-底部弹出
    ZSHFromNoneVCToBottomBlurPopView
};

typedef void (^ZSHConfirmOrderBlock)();

@interface ZSHBottomBlurPopView :FXBlurView

@property (nonatomic, strong) ZSHBaseTableViewModel     *tableViewModel;
@property (nonatomic, copy) dispatch_block_t            confirmOrderBlock;    

- (instancetype)initWithFrame:(CGRect)frame paramDic:(NSDictionary *)paramDic;
- (void)updateViewWithParamDic:(NSDictionary *)paramDic;

@end
