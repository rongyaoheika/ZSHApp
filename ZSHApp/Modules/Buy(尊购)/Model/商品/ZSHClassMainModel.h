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

/** 文标题  */
@property (nonatomic, copy ,readonly) NSString *title;


/** goods  */
@property (nonatomic, copy ,readonly) NSArray<ZSHClassSubModel *> *goods;

@end
