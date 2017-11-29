//
//  ZSHBuyLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginLogic.h"
#import "ZSHGoodModel.h"
#import "ZSHPersonalModel.h"
#import "ZSHPersonalDetailModel.h"
#import "ZSHCollectModel.h"
#import "ZSHGoodDetailModel.h"
#import "ZSHBuySearchModel.h"

@interface ZSHBuyLogic : ZSHLoginLogic

@property (nonatomic, strong) NSArray<ZSHPersonalModel *>                 *personModelArr;
@property (nonatomic, strong) ZSHPersonalDetailModel                      *personalDetailModel;
@property (nonatomic, strong) NSArray<ZSHGoodModel *>                     *goodsListModelArr;
@property (nonatomic, strong) NSArray<ZSHCollectModel *>                  *collectModelArr;
@property (nonatomic, strong) ZSHGoodDetailModel                          *goodDetailModel;
@property (nonatomic, strong) NSArray<ZSHBuySearchModel *>                *buySearchModelArr;

// 尊购首页轮播图
- (void)requestScarouselfigure:(void (^)(id response))success;

// 尊购里模糊查询
- (void)requestShipDimQueryWithKeywords:(NSString *)keyword success:(void (^)(id response))success;
// 商品分类
- (void)requestShipBrandList:(void(^)(id response))success;
// 商品品牌
- (void)requestBrandIconListWithBrandID:(NSString *)BrandID success:(void (^)(id response))success;
- (void)requestShipListAllsuccess:(void (^)(id response))success;
// 尊购专区点击之后跳转页面
- (void)requestShipPrefectureWithBrandID:(NSString *)brandID success:(void (^)(id response))success;
//商品详情
- (void)requestShipDetailWithProductID:(NSString *)productID success:(void (^)(id response))success;
// 私人定制
- (void)requestPersonLists:(void (^)(id response))success;
// 定制详情
- (void)requestPersonDetailWithPersonalID:(NSString *)personalID success:(void (^)(id response))success;
// 炫购收藏
- (void)requestShipCollectWithUserID:(NSString *)userID success:(void (^)(id response))success;
// 炫购添加
- (void)requestShipCollectAddWithProductID:(NSString *)productID success:(void (^)(id response))success;
// 炫购删除
- (void)requestShipCollectDel:(NSString *)collectID success:(void (^)(id response))success;
// 加入购物车
- (void)requestShoppingCartAddWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 获取购物车
- (void)requestShoppingCartWithHonouruserID:(NSString *)honouruerID success:(void (^)(id response))success;
// 购物车删除
- (void)requestShoppingCartDelWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
@end
