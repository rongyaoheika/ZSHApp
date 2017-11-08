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

@end

