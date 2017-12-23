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
- (void)loadFoodListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//美食详情
- (void)loadFoodDetailDataWithParamDic:(NSDictionary *)paramDic;

//美食套餐列表
- (void)loadFoodDetailSetWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//美食更多商家
- (void)loadFoodDetailListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//美食排序
- (void)loadFoodSortWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
@end
