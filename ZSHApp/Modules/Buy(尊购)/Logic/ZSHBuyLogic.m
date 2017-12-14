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
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlShipDimQuery parameters:@{@"KEYWORDS":keyword,@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        weakself.buySearchModelArr = [ZSHBuySearchModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
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


//result = 01;
//pd = (
//      {
//          BRAND_ID = 1b4ed4c57ef04933b97e8def48fc423a;
//          PRODUCTIMG = (
//                        http://47.104.16.215:8088/productimgs/productimg/db473bf6aa39469ca0abb82640ec446c.png,
//                        http://47.104.16.215:8088/productimgs/productimg/c547535af72141e39201a6300271061d.png,
//                        http://47.104.16.215:8088/productimgs/productimg/3a9e779a5abf4ac498bf2fb39f085151.png,
//                        );
//          PROCOLOR = 2385cc;
//          PRODUCT_ID = 383674340182327296;
//          PRODETAILSIMG = ;
//          PROPROPERTY = 暂无;
//          PROTITLE = 天梭手表的标题;
//          PRODETAILSINT = 天梭手表详情介绍;
//          PROPRICE = 28888;
//          PROBRAND = 天梭;
//      }
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

// 炫购添加
- (void)requestShipCollectAddWithProductID:(NSString *)productID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipCollectAdd parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue,@"PRODUCT_ID":productID} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 炫购删除
- (void)requestShipCollectDel:(NSString *)collectID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlShipCollectDel parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue,@"COLLECT_ID":collectID} success:^(id responseObject) {
        success(responseObject);
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

// 尊购首页轮播图
- (void)requestScarouselfigure:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlScarouselfigure parameters:@{} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
