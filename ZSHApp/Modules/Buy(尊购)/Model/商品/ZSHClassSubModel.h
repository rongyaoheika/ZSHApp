//
//  ZSHClassSubModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHClassSubModel : ZSHBaseModel



/** 商品类题  */
@property (nonatomic, copy ,readonly) NSString *goods_title;

/** 商品图片  */
@property (nonatomic, copy ,readonly) NSString *image_url;

@end
