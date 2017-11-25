//
//  ZSHClassSubModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHClassSubModel : ZSHBaseModel

@property (nonatomic, copy) NSString *BRANDICON_ID;
@property (nonatomic, copy) NSString *BRANDNAME;
@property (nonatomic, copy) NSString *BRAND_ID;
@property (nonatomic, copy) NSString *ICONIMGS;


/** 商品类题  */
@property (nonatomic, copy ,readonly) NSString *goods_title;

/** 商品图片  */
@property (nonatomic, copy ,readonly) NSString *image_url;

@end
