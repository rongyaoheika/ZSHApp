//
//  ZSHBuyLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBuyLogic.h"

@implementation ZSHBuyLogic

- (void)requestShipBrandList:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipBrandList parameters:nil success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


- (void)requestBrandIconListWithBrandID:(NSString *)BrandID success:(void (^)(id response))success {
    
    [PPNetworkHelper POST:kUrlShipBrandIconList parameters:@{@"BRAND_ID":BrandID} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)requestShipCollectWithUserID:(NSString *)userID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipCollect parameters:@{@"HONOURUSER_ID":userID} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
