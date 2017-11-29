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
@property (nonatomic, copy) NSString    *SORTKTV_ID;           //KTVID
@property (nonatomic, copy) NSString    *SHOWIMAGES;           //KTV图片
@property (nonatomic, copy) NSString    *KTVNAMES;             //KTV名字
@property (nonatomic, copy) NSString    *KTVADDRESS;           //KTV地址
@property (nonatomic, assign) NSInteger KTVEVACOUNT;           //评论数
@property (nonatomic, assign) CGFloat   KTVEVALUATE;           //KTV星评
@property (nonatomic, assign) CGFloat   KTVPRICE;              //KTV价格
@property (nonatomic, assign) CGFloat   cellHeight;


@end



@interface ZSHKTVDetailModel:ZSHBaseModel

//KTV详情
@property (nonatomic, copy) NSString    *KTVPHONE;             //KTV电话
@property (nonatomic, copy) NSString    *KTVNAMES;             //KTV名字
@property (nonatomic, copy) NSString    *KTVADDRESS;           //KTV地址
@property (nonatomic, assign) NSInteger KTVEVACOUNT;           //评论数
@property (nonatomic, assign) CGFloat   KTVEVALUATE;           //评分
@property (nonatomic, strong) NSArray   *KTVDETAILSIMGS;       //KTV轮播图

@property (nonatomic, assign) BOOL      SHOPSERVWIFI;            //WIFI
@property (nonatomic, assign) BOOL      SHOPSERVFOOD;            //餐饮
@property (nonatomic, assign) BOOL      SHOPSERVPAY;             //在线支付
@property (nonatomic, assign) BOOL      SHOPSERVFITNESS;         //健身
@property (nonatomic, assign) BOOL      SHOPSERVSWIM;            //游泳
@property (nonatomic, assign) BOOL      SHOPSERVPARK;            //停车

@end
