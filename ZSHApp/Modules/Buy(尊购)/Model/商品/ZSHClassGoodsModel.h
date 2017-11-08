//
//  ZSHClassGoodsModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHClassGoodsModel : ZSHBaseModel

/** 文标题  */
@property (nonatomic, copy ,readonly) NSString *title;
/** plist  */
@property (nonatomic, copy ,readonly) NSString *fileName;

@end
