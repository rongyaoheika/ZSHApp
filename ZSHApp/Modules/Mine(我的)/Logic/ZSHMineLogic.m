//
//  ZSHMineLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMineLogic.h"

@implementation ZSHMineLogic

// 获取用户收货地址列表
- (void)requestShipAdr:(NSString *)userID success:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlUserShipAdr parameters:@{@"HONOURUSER_ID":userID} success:^(id responseObject) {
        weakself.addrModelArr = [ZSHAddrModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 添加用户收货地址
- (void)requestShipAddShipAdr:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlUserAddShipAdr parameters:self.addNewAddr.mj_keyValues success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 删除用户收货地址
- (void)requestUserDelShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlUserDelShipAdr parameters:model.mj_keyValues success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 修改用户收货地址
- (void)requestUserEdiShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlUserEdiShipAdr parameters:model.mj_keyValues success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 获得用户名下尊购订单列表
- (void)requestOrderAllList:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlOrderAllList parameters:@{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c"} success:^(id responseObject) {
        weakself.goodOrderModelArr = [ZSHGoodOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 获取用户名带条件查询的订单列表（待付款，待收货，待评价，已完成）
- (void)requestOrderConListWithOrderStatus:(NSString *)orderStatus success:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlOrderConList parameters:@{@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c", @"ORDERSTATUS":orderStatus} success:^(id responseObject) {
        weakself.goodOrderModelArr = [ZSHGoodOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 生成订单接口（未产生交易）状态为待付款（购物车结算）
- (void)requestShipOrderWithModel:(ZSHBuyOrderModel *)model success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipOrder parameters:model.mj_keyValues success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
