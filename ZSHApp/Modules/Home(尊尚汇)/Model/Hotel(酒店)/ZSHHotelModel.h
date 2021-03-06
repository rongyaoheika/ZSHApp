//
//  ZSHHotelModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHHotelModel : ZSHBaseModel

//详情(订单)
@property (nonatomic, copy) NSString *detailImageName;      //hotel_detail_big
@property (nonatomic, copy) NSString *hotelName;            //三亚大中华希尔顿酒店
@property (nonatomic, copy) NSString *liveInfo;             //6月8日入住，6月9日离开，1天
@property (nonatomic, copy) NSString *sizeInfo;             //60m   大床1.8m

//确认订单弹框
@property (nonatomic, copy) NSString *hotelType;            //豪华贵宾房


//酒店列表
@property (nonatomic, copy) NSString    *SORTHOTEL_ID;           //酒店ID
@property (nonatomic, copy) NSString    *SHOWIMAGES;             //酒店图片
@property (nonatomic, copy) NSString    *HOTELNAMES;             //酒店名字
@property (nonatomic, copy) NSString    *HOTELADDRESS;           //酒店地址
@property (nonatomic, assign) NSInteger HOTELEVACOUNT;           //评论数
@property (nonatomic, assign) CGFloat   HOTELEVALUATE;           //酒店星评
@property (nonatomic, assign) CGFloat   HOTELPRICE;              //酒店价格
@property (nonatomic, assign) CGFloat    cellHeight;

@end

@interface ZSHHotelDetailModel:ZSHBaseModel
//酒店详情
@property (nonatomic, copy) NSString    *HOTELPHONE;             //酒店电话
@property (nonatomic, copy) NSString    *HOTELNAMES;             //酒店名字
@property (nonatomic, copy) NSString    *HOTELADDRESS;           //酒店地址
@property (nonatomic, assign) NSInteger HOTELEVACOUNT;           //评论数
@property (nonatomic, assign) CGFloat   HOTELEVALUATE;           //评分
@property (nonatomic, strong) NSArray   *HOTELDETAILSIMGS;       //酒店轮播图

@property (nonatomic, assign) BOOL      SHOPSERVWIFI;            //WIFI
@property (nonatomic, assign) BOOL      SHOPSERVFOOD;            //餐饮
@property (nonatomic, assign) BOOL      SHOPSERVPAY;             //在线支付
@property (nonatomic, assign) BOOL      SHOPSERVFITNESS;         //健身
@property (nonatomic, assign) BOOL      SHOPSERVSWIM;            //游泳
@property (nonatomic, assign) BOOL      SHOPSERVPARK;            //停车

@end

@interface ZSHHotelDetailListModel:ZSHBaseModel

//酒店列表详情
@property (nonatomic, copy) NSString    *HOTELDETROOMSIZE;        //酒店电话
@property (nonatomic, copy) NSString    *HOTELDETNAME;            //豪华单人间
@property (nonatomic, copy) NSString    *HOTELDETAIL_ID;          //
@property (nonatomic, copy) NSString    *SORTHOTEL_ID;            //
@property (nonatomic, copy) NSString    *HOTELDETBEDTYPE;         //单人床1.35*2  2张;
@property (nonatomic, assign) CGFloat   HOTELDETPRICE;            //酒店价格

@end
