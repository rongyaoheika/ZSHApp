//
//  ZSHGoodsDetailModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHGoodsDetailModel : ZSHBaseModel

/** 商品图片  */
@property (nonatomic, copy ,readonly) NSString *detailPicture;
/** 商品描述  */
@property (nonatomic, copy ,readonly) NSString *detailText;

@property (nonatomic, assign) CGFloat    cellHeight;


//BRAND_ID = 1b4ed4c57ef04933b97e8def48fc423a;
//PRODUCTIMG = http://47.104.16.215:8088/productimgs/productimg/db473bf6aa39469ca0abb82640ec446c.png,http://47.104.16.215:8088/productimgs/productimg/c547535af72141e39201a6300271061d.png,http://47.104.16.215:8088/productimgs/productimg/3a9e779a5abf4ac498bf2fb39f085151.png;
//PROCOLOR = 2385cc;
//PRODUCT_ID = 383674340182327296;
//PRODETAILSIMG = ;
//PROPROPERTY = 暂无;
//PROTITLE = 天梭手表的标题;
//PRODETAILSINT = 天梭手表详情介绍;
//PROPRICE = 28888;
//PROBRAND = 天梭;
//}


@end

