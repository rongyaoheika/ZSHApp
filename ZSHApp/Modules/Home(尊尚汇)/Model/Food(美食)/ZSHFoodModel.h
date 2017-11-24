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
@property (nonatomic, copy) NSString    *SHOPPRICE;       //美食价格
@property (nonatomic, copy) NSString    *SHOPNAMES;       //店铺名字（美食详情名字）
@property (nonatomic, copy) NSString    *SHOPEVALUATE;    //星星评价（美食星评4.5）
@property (nonatomic, copy) NSString    *SHOPEVACOUNT;    //总评价数（美食总评120）
@property (nonatomic, assign) CGFloat   cellHeight;

@end

@interface ZSHFoodDetailModel : ZSHBaseModel

//美食详情
@property (nonatomic, copy) NSString     *SHOPNAMES;       //店铺名字（美食详情名字）
@property (nonatomic, copy) NSString     *SHOPEVALUATE;    //星星评价（美食星评4.5）
@property (nonatomic, copy) NSString     *SHOPEVACOUNT;    //总评价数（美食总评120）
@property (nonatomic, copy) NSString     *SHOPPHONE;       //美食电话
@property (nonatomic, strong) NSArray   *SHOPDETAILSIMGS; //头部轮播图
@property (nonatomic, assign) BOOL      SHOPSERVFOOD;     //餐饮
@property (nonatomic, assign) BOOL      SHOPSERVPARK;     //停车
@property (nonatomic, assign) BOOL      SHOPSERVPAY;      //移动支付
@property (nonatomic, assign) BOOL      SHOPSERVWIFI;     //WIFI

@end
