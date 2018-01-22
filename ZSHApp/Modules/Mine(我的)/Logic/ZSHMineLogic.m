//
//  ZSHMineLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMineLogic.h"
#import "ZSHUserInfoModel.h"

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
    [PPNetworkHelper POST:kUrlOrderAllList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        weakself.goodOrderModelArr = [ZSHGoodOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(weakself.goodOrderModelArr);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 获取用户名带条件查询的订单列表（待付款，待收货，待评价，已完成）
- (void)requestOrderConListWithOrderStatus:(NSString *)orderStatus success:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlOrderConList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"ORDERSTATUS":orderStatus} success:^(id responseObject) {
        weakself.goodOrderModelArr = [ZSHGoodOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(weakself.goodOrderModelArr);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 获得用户名下所有酒店订单列表
- (void)requestOrderWithURL:(NSString *)url orderStatus:(NSString *)orderStatus success:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:url parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"ORDERSTATUS":orderStatus} success:^(id responseObject) {
        if([url isEqualToString:kUrlHotelOrderAllList]) {
            weakself.hotlOrderModelArr = [ZSHHotelOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
            success(weakself.hotlOrderModelArr);
        } else if ([url isEqualToString:kUrlKtvOrderAllList]) {
            weakself.ktvOrderModelArr = [ZSHKtvOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
            success(weakself.ktvOrderModelArr);
        } else if ([url isEqualToString:kUrlFoodOrderAllList]) {
            weakself.foodOrderModelArr = [ZSHFoodOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
            success(weakself.foodOrderModelArr);
        } else if ([url isEqualToString:kUrlBarorderAllList]) {
            weakself.barorderOrderModelArr = [ZSHBarorderOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
            success(weakself.barorderOrderModelArr);
        }
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 获得用户名下所有KTV订单列表
- (void)requestKtvOrderAllList:(void (^)(id response))success {
    
//    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlKtvOrderAllList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
       
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


// 上传头像
- (void)uploadImage:(NSArray *)imageArr name:(NSArray *)nameArr success:(void (^)(id response))success {
    [PPNetworkHelper uploadImagesWithURL:kUrlUp parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} name:@"showfile" images:imageArr fileNames:@[@"headImage.jpg"] imageScale:1.0 imageType:@"image/jpeg" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

// 修改个人信息
- (void)requestUserInfoWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlUserPersonalInfo parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 获取个人信息
- (void)requestGetUserInfo:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlGetUserInfo parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        ZSHUserInfoModel *userInfoModel = [ZSHUserInfoModel mj_objectWithKeyValues:responseObject[@"user"]];
        success(userInfoModel);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 修改用户密码
- (void)requestUserUpdPasswordWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlUserUpdPassword parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 获取能量值
- (void)requestEnergyList:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlEnergyList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 按月份统计用户能量值
- (void)requestEnergyValueMonth:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlEnergyValueMonth parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 获取用户会员中心信息
- (void)requestGetMemberInfo:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlGetMemberInfo parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}
// 获取我的优惠券，黑卡币，能量值
- (void)requestCouBlackEnergy:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlGetMyCouBlackEnergy parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 给商品添加用户评价
- (void)requestSProductAddEva:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlSProductAddEva parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 找回登录密码 (忘记密码)
- (void)requestForgetUser:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlGetUserByForget parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 修改用户手机号码
- (void)requestUserPhone:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlUpdUserphone parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}






@end
