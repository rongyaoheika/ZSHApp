//
//  ZSHBuyLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBuyLogic.h"

@implementation ZSHBuyLogic


// 尊购里模糊查询
- (void)requestShipDimQueryWithKeywords:(NSString *)keyword success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipDimQuery parameters:@{@"KEYWORDS":keyword,@"HONOURUSER_ID":@"d6a3779de8204dfd9359403f54f7d27c"} success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

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
- (void)requestBrandIconListWithBrandID:(NSString *)brandID success:(void (^)(id response))success {
    
    [PPNetworkHelper POST:kUrlShipBrandIconList parameters:@{@"BRAND_ID":brandID} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 尊购专区点击之后跳转页面
- (void)requestShipPrefectureWithBrandID:(NSString *)brandID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipPrefecture parameters:@{@"BRAND_ID":brandID} success:^(id responseObject) {
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

//商品详情
- (void)requestShipDetailWithProductID:(NSString *)productID success:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlShipDetails parameters:@{@"PRODUCT_ID":productID} success:^(id responseObject) {
        weakself.goodDetailModel = [ZSHGoodDetailModel mj_objectWithKeyValues:responseObject[@"pd"]];
        success(nil);
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


// 加入购物车
- (void)requestShoppingCartAddWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShoppingCartAdd parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 获取购物车
- (void)requestShoppingCartWithHonouruserID:(NSString *)honouruerID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShoppingCart parameters:@{@"HONOURUSER_ID":honouruerID} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}
// 购物车删除
- (void)requestShoppingCartDelWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShoppingCartDel parameters:dic success:^(id responseObject) {
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
