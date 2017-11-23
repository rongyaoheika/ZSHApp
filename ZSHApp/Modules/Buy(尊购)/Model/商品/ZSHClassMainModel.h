//
//  ZSHClassMainModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"
@class ZSHClassSubModel;
@interface ZSHClassMainModel : ZSHBaseModel

/** 商品名称 */
@property (nonatomic, copy ,readonly) NSString *BRANDBANE;
/** BrandID */
@property (nonatomic, strong) NSString *BRAND_ID;
/** BrandOrder */
@property (nonatomic, strong) NSString *BRANDORDER;

/** 文标题  */
@property (nonatomic, copy ,readonly) NSString *title;

/** goods  */
@property (nonatomic, strong) NSArray<ZSHClassSubModel *> *goods;



@end
