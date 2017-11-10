//
//  ZSHTitleContentViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger,ZSHToTitleContentVC){
    FromLiveTabBarVCToTitleContentVC,        //尚播（推荐，附近，分类）
    FromFindVCToTitleContentVC,              //发现（精选，数码，亲子。。。）
    FromAllOrderVCToTitleContentVC,          //我的订单（全部，待付款，待收货，待评价，退款售后)
    FromIntegralVCToTitleContentVC,          //积分账单（全部，收入，支出)
    FromHotelVCToTitleContentVC,             //酒店（排序，品牌，筛选）
    FromFoodVCToTitleContentVC,              //酒店（排序，品牌，筛选）
    FromPlaneTicketVCToTitleContentVC,       //飞机票（价格，时间，准确率）
    FromActivityCenterVCToTitleContentVC,    //活动中心（我发布的，我参与的）
    FromMineLevelVCToTitleContentVC,         //我的等级（用户等级，主播等级）
    FromContributionListVCToTitleContentVC,  //贡献榜（日榜，周榜，月榜，总榜）
    FromNoneToTitleContentVC
};

@interface ZSHTitleContentViewController : RootViewController

@end
