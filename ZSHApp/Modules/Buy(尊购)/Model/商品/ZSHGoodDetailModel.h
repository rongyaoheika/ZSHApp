//
//  ZSHGoodDetailModel.h
//  ZSHApp
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHGoodDetailModel : ZSHBaseModel



/** 商品ID */
@property (nonatomic, copy) NSString *BRAND_ID;
/** 图片URL */
@property (nonatomic, copy) NSString *PRODUCTIMG;
/** 颜色 */
@property (nonatomic, copy) NSString *PROCOLOR;
/** ProduceID */
@property (nonatomic, copy) NSString *PRODUCT_ID;

@property (nonatomic, copy) NSString *PRODETAILSIMG;
/** 属性 */
@property (nonatomic, copy) NSString *PROPROPERTY;
/** 标题 */
@property (nonatomic, copy) NSString *PROTITLE;

@property (nonatomic, copy) NSString *PRODETAILSINT;
/** 商品价格 */
@property (nonatomic, copy) NSString *PROPRICE;

@property (nonatomic, copy) NSString *PROBRAND;



@end
