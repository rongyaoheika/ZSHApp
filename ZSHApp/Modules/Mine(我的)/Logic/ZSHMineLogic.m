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

@end
