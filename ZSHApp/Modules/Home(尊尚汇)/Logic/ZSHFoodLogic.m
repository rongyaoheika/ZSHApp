//
//  ZSHFoodLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFoodLogic.h"


@implementation ZSHFoodLogic

- (void)loadFoodListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSFood parameters:paramDic success:^(id responseObject) {
        RLog(@"美食列表数据==%@",responseObject[@"pd"]);
        NSArray *foodListArr = responseObject[@"pd"];
        success(foodListArr);

    } failure:^(NSError *error) {
        
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
        
    }];
}

- (void)loadFoodDetailSetWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlFoodDetailList parameters:paramDic success:^(id responseObject) {
        RLog(@"美食套餐列表：返回数据&%@",responseObject);
        NSArray *foodSetArr = responseObject[@"pd"];
        success(foodSetArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadFoodDetailListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail {
    [PPNetworkHelper POST:kUrlSfoodlistRand parameters:paramDic success:^(id responseObject) {
        RLog(@"美食详情列表数据==%@",responseObject)
        NSArray *foodDetaiDicListArr = responseObject[@"pd"];
        success(foodDetaiDicListArr);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


- (void)loadFoodSortWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail {
    [PPNetworkHelper POST:kUrlSFoodListSequence parameters:paramDic success:^(id responseObject) {
        RLog(@"美食排序列表数据==%@",responseObject)
        NSArray *foodDetaiDicListArr = responseObject[@"pd"];
        success(foodDetaiDicListArr);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}
@end
