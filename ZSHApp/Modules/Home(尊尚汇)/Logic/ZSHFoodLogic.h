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

@property (nonatomic, strong) NSArray        *foodListArr;
@property (nonatomic, strong) NSDictionary   *foodDetailDic;
@property (nonatomic, strong) ZSHFoodModel   *foodModel;
- (void)loadFoodListData;
- (void)loadFoodDetailDataWithParamDic:(NSDictionary *)paramDic;

@end
