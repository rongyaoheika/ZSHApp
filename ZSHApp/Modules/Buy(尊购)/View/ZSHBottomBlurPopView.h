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
    ZSHFromHomeMenuVCToBottomBlurPopView,                    //首页-菜单栏
    ZSHFromAirplaneUserInfoVCToBottomBlurPopView,            //机票个人信息-底部弹出
    ZSHFromAirplaneAgeVCToBottomBlurPopView,                 //年龄-底部弹出
    ZSHFromPersonInfoVCToBottomBlurPopView,                  //主播个人信息
    ZSHFromLiveMidVCToBottomBlurPopView,                     //直播-弹框
    ZSHFromTrainUserInfoVCToBottomBlurPopView,               //火车票个人信息-底部弹出
    ZSHFromShareVCToToBottomBlurPopView,                     //分享
    ZSHFromNoneVCToBottomBlurPopView
};

typedef void (^ZSHConfirmOrderBlock)();
typedef void (^DismissBlurViewBlock) (UIView *view, NSIndexPath *indexpath);

@interface ZSHBottomBlurPopView :FXBlurView

@property (nonatomic, strong) ZSHBaseTableViewModel     *tableViewModel;
@property (nonatomic, copy) dispatch_block_t            confirmOrderBlock;
@property (nonatomic, copy) DismissBlurViewBlock        dissmissViewBlock;


- (instancetype)initWithFrame:(CGRect)frame paramDic:(NSDictionary *)paramDic;
- (void)updateViewWithParamDic:(NSDictionary *)paramDic;

@end
