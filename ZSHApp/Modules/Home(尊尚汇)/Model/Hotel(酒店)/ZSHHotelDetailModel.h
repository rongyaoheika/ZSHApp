//
//  ZSHHotelDetailModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHHotelDetailModel : ZSHBaseModel

//酒店列表
@property (nonatomic, copy) NSString *imageName;           //hotel_image（列表，确认订单）
@property (nonatomic, copy) NSString *title;               //如家-北京霍营地铁站店
@property (nonatomic, copy) NSString *address;             //昌平区回龙观镇科星西路47号
@property (nonatomic, copy) NSString *comment;             //（120条评价）
@property (nonatomic, copy) NSString *distance;            //23公里
@property (nonatomic, copy) NSString *price;               //¥499

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
@property (nonatomic, copy) NSString    *HOTELEVACOUNT;          //评论数
@property (nonatomic, copy) NSString    *HOTELEVALUATE;          //酒店星评
@property (nonatomic, copy) NSString    *HOTELPRICE;             //酒店价格


@property (nonatomic, assign) CGFloat    cellHeight;

@end
