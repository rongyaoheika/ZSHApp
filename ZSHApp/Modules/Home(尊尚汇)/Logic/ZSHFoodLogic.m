//
//  ZSHFoodLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFoodLogic.h"


@implementation ZSHFoodLogic

- (void)loadFoodListDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlSFood parameters:paramDic success:^(id responseObject) {
        weakself.foodListArr = [ZSHFoodModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(nil);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

- (void)loadFoodDetailDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlFoodSyn parameters:paramDic success:^(id responseObject) {
        RLog(@"美食详情请求成功：返回数据&%@",responseObject);
        NSDictionary *foodDetailParamDic = responseObject[@"pd"];
        ZSHFoodDetailModel *foodDetailModel = [ZSHFoodDetailModel mj_objectWithKeyValues:responseObject[@"pd"]];
        NSDictionary *nextParamDic = @{@"foodDetailModel":foodDetailModel,@"foodDetailParamDic":foodDetailParamDic};
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(nextParamDic);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

@end
