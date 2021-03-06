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
    ZSHConfirmOrderToBottomBlurPopView,                      //美食，酒店，酒吧，KTV,订单-底部弹出
    ZSHFromFoodDetailVCToBottomBlurPopView,                  //餐厅订单-底部弹窗
    ZSHFromHotelDetailCalendarVCToBottomBlurPopView,         //酒店入住日历-底部弹出
    ZSHFromAirplaneCalendarVCToBottomBlurPopView,            //机票-底部弹出
    ZSHFromHomeMenuVCToBottomBlurPopView,                    //首页-菜单栏
    ZSHFromAirplaneUserInfoVCToBottomBlurPopView,            //机票个人信息-底部弹出
    ZSHFromAirplaneAgeVCToBottomBlurPopView,                 //年龄-底部弹出
    ZSHFromPersonInfoVCToBottomBlurPopView,                  //主播个人信息
    ZSHFromLiveMidVCToBottomBlurPopView,                     //直播-弹框
    ZSHFromLiveNearSearchVCToBottomBlurPopView,              //直播-筛选播主
    ZSHFromTrainUserInfoVCToBottomBlurPopView,               //火车票个人信息-底部弹出
    ZSHFromShareVCToToBottomBlurPopView,                     //分享
    ZSHFromGoodsMineVCToToBottomBlurPopView,                 //我的—订单下拉列表
    ZSHFromTrainCalendarVCToBottomBlurPopView,               //火车票日期选择
    ZSHFromGoodsVCToBottomBlurPopView,                       //商品分类
    ZSHFromFoodVCToBottomBlurPopView,                        //美食分类
    ZSHFromTopLineVCToBottomBlurPopView,                     //头条-顶部
    ZSHSubscribeVCToBottomBlurPopView,                       //游艇订单-底部弹出
    ZSHFromNoneVCToBottomBlurPopView
};

typedef void (^ZSHConfirmOrderBlock)(NSDictionary *);
typedef void (^DismissBlurViewBlock) (UIView *view, NSIndexPath *indexpath);

@interface ZSHBottomBlurPopView :FXBlurView

@property (nonatomic, strong) ZSHBaseTableViewModel     *tableViewModel;
@property (nonatomic, copy) ZSHConfirmOrderBlock        confirmOrderBlock;
@property (nonatomic, copy) DismissBlurViewBlock        dissmissViewBlock;


- (instancetype)initWithFrame:(CGRect)frame paramDic:(NSDictionary *)paramDic;
- (void)updateViewWithParamDic:(NSDictionary *)paramDic;

@end
