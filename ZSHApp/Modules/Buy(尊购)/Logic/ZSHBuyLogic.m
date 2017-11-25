//
//  ZSHBuyLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBuyLogic.h"

@implementation ZSHBuyLogic


// 商品分类
- (void)requestShipBrandList:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipBrandList parameters:nil success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 商品品牌
- (void)requestBrandIconListWithBrandID:(NSString *)BrandID success:(void (^)(id response))success {
    
    [PPNetworkHelper POST:kUrlShipBrandIconList parameters:@{@"BRAND_ID":BrandID} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)requestShipListAllsuccess:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipListAll parameters:@{} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)requestShipListsAllsuccess:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipDetails parameters:@{} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}
// 私人定制
- (void)requestPersonLists:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlPersonalList parameters:@{} success:^(id responseObject) {
        weakself.personModelArr = [ZSHPersonalModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 定制详情
- (void)requestPersonDetailWithPersonalID:(NSString *)personalID success:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlPersonalDet parameters:@{@"PERSONAL_ID":personalID} success:^(id responseObject) {
        weakself.personalDetailModel = [ZSHPersonalDetailModel mj_objectWithKeyValues:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 炫购收藏
- (void)requestShipCollectWithUserID:(NSString *)userID success:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlShipCollect parameters:@{@"HONOURUSER_ID":userID} success:^(id responseObject) {
        weakself.collectModelArr = [ZSHCollectModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
