//
//  ZSHKTVModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHKTVModel : ZSHBaseModel

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *comment;

//详情
@property (nonatomic, copy) NSString *detailImageName;  //支付界面图片
@property (nonatomic, copy) NSString *KTVName;          //麦乐迪（航天桥店）
@property (nonatomic, copy) NSString *roomType;         //小包（2-4人）
@property (nonatomic, copy) NSString *time;             //10:00-13:00，共3小时



//KTV列表
@property (nonatomic, copy) NSString    *SORTHOTEL_ID;           //酒店ID
@property (nonatomic, copy) NSString    *SHOWIMAGES;             //酒店图片
@property (nonatomic, copy) NSString    *HOTELNAMES;             //酒店名字
@property (nonatomic, copy) NSString    *HOTELADDRESS;           //酒店地址
@property (nonatomic, assign) NSInteger HOTELEVACOUNT;           //评论数
@property (nonatomic, assign) CGFloat   HOTELEVALUATE;           //酒店星评
@property (nonatomic, assign) CGFloat   HOTELPRICE;              //酒店价格
@property (nonatomic, assign) CGFloat    cellHeight;

@end



@interface ZSHKTVDetailModel:ZSHBaseModel
//KTV详情
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
