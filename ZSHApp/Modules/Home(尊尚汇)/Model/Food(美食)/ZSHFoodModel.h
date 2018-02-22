//
//  ZSHFoodModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHFoodModel : ZSHBaseModel

//美食列表
@property (nonatomic, copy) NSString    *SORTFOOD_ID;     //美食id
@property (nonatomic, copy) NSString    *SHOWIMAGES;      //美食图片
@property (nonatomic, assign) CGFloat   SHOPPRICE;       //美食价格
@property (nonatomic, copy) NSString    *SHOPNAMES;       //店铺名字（美食详情名字）
@property (nonatomic, assign) CGFloat   SHOPEVALUATE;     //星星评价（美食星评4.5）
@property (nonatomic, assign) NSInteger SHOPEVACOUNT;     //总评价数（美食总评120）

@end

@interface ZSHFoodDetailModel : ZSHBaseModel

//美食详情
@property (nonatomic, copy)   NSString     *SHOPNAMES;       //店铺名字（美食详情名字）
@property (nonatomic, assign) CGFloat      SHOPEVALUATE;     //星星评价（美食星评4.5）
@property (nonatomic, assign) NSInteger    SHOPEVACOUNT;     //总评价数（美食总评120）
@property (nonatomic, copy)   NSString     *SHOPADDRESS;     //美食地址
@property (nonatomic, copy)   NSString     *SHOPPHONE;       //美食电话
@property (nonatomic, strong) NSArray      *SHOPDETAILSIMGS; //头部轮播图

@property (nonatomic, assign) BOOL      SHOPSERVWIFI;            //WIFI
@property (nonatomic, assign) BOOL      SHOPSERVFOOD;            //餐饮
@property (nonatomic, assign) BOOL      SHOPSERVPAY;             //在线支付
@property (nonatomic, assign) BOOL      SHOPSERVFITNESS;         //健身
@property (nonatomic, assign) BOOL      SHOPSERVSWIM;            //游泳
@property (nonatomic, assign) BOOL      SHOPSERVPARK;            //停车

@end
