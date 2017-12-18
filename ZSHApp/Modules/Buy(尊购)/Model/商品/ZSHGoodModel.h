//
//  ZSHGoodModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHGoodModel : ZSHBaseModel

/** 图片URL */
@property (nonatomic, copy ,readonly) NSString *image_url;
/** 商品标题 */
@property (nonatomic, copy ,readonly) NSString *main_title;
/** 商品小标题 */
@property (nonatomic, copy ,readonly) NSString *goods_title;
/** 商品价格 */
@property (nonatomic, copy ,readonly) NSString *price;
/** 剩余 */
@property (nonatomic, copy ,readonly) NSString *stock;
/** 属性 */
@property (nonatomic, copy ,readonly) NSString *nature;

/* 头部轮播 */
@property (copy , nonatomic , readonly)NSArray *images;


@property (nonatomic, copy) NSString *count;
/** 商品标题 */
@property (nonatomic, copy) NSString *PROTITLE;
/** 商品价格 */
@property (nonatomic, copy) NSString *PROPRICE;
/** 图片URL */
@property (nonatomic, copy) NSString *PROSHOWIMG;
@property (nonatomic, copy) NSString *PRODUCT_ID;


@end
