//
//  ZSHBuyLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHGoodModel.h"
#import "ZSHPersonalModel.h"
#import "ZSHPersonalDetailModel.h"
#import "ZSHCollectModel.h"
#import "ZSHGoodDetailModel.h"
#import "ZSHBuySearchModel.h"
#import "ZSHGoodCommentModel.h"
#import "ZSHGoodsDetailModel.h"

@interface ZSHBuyLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray<ZSHPersonalModel *>                 *personModelArr;
@property (nonatomic, strong) NSArray<ZSHPersonalDetailModel*>            *personalDetailModelArr;
@property (nonatomic, strong) NSArray<ZSHGoodModel *>                     *goodsListModelArr;
@property (nonatomic, strong) NSArray<ZSHCollectModel *>                  *collectModelArr;
@property (nonatomic, strong) ZSHGoodDetailModel                          *goodDetailModel;
@property (nonatomic, strong) NSArray<ZSHBuySearchModel *>                *buySearchModelArr;
@property (nonatomic, strong) NSArray<ZSHGoodCommentModel*>               *goodCommentModelArr;
@property (nonatomic, strong) NSArray<ZSHGoodsDetailModel *>              *goodsDetailModelArr;

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
// 商品详情
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
// 获取发现中所有的菜单项
- (void)requestCaidan:(void (^)(id response))success;
// 获取发现中所有的菜单项
- (void)requestCaidanWithID:(NSString *)caidanID success:(void (^)(id response))success;
// 给商品添加用户评价
- (void)requestSProductAddEva:(NSDictionary *)dic success:(void (^)(id response))success;
- (void)requestProductEvaList:(NSDictionary *)dic success:(void (^)(id response))success;


@end
