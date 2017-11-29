//
//  ZSHFoodLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHFoodModel.h"

@interface ZSHFoodLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray <ZSHFoodModel *>    *foodListArr;

//美食列表
- (void)loadFoodListDataWithParamDic:(NSDictionary *)paramDic;

//美食详情
- (void)loadFoodDetailDataWithParamDic:(NSDictionary *)paramDic;

@end
