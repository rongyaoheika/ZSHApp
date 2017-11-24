//
//  ZSHFoodLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

@class ZSHFoodModel;
@class ZSHFoodDetailModel;
@interface ZSHFoodLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray <ZSHFoodModel *>    *foodListArr;
@property (nonatomic, strong) ZSHFoodDetailModel          *foodDetailModel;

- (void)loadFoodListData;
- (void)loadFoodDetailDataWithParamDic:(NSDictionary *)paramDic;

@end
