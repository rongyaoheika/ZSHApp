//
//  ZSHMineLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginLogic.h"
#import "ZSHAddrModel.h"
#import "ZSHGoodOrderModel.h"
#import "ZSHBuyOrderModel.h"

@interface ZSHMineLogic : ZSHLoginLogic

@property (nonatomic, strong) ZSHAddrModel                     *addNewAddr;
@property (nonatomic, strong) NSMutableArray<ZSHAddrModel *>   *addrModelArr;
@property (nonatomic, strong) NSArray<ZSHGoodOrderModel *>     *goodOrderModelArr;
@property (nonatomic, strong) ZSHBuyOrderModel                 *buyOrderModel;


// 获取用户收货地址列表
- (void)requestShipAdr:(NSString *)userID success:(void (^)(id response))success;
// 添加用户收货地址
- (void)requestShipAddShipAdr:(void (^)(id response))success;
// 删除用户收货地址
- (void)requestUserDelShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success;
// 修改用户收货地址
- (void)requestUserEdiShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success;
// 酒店
- (void)requestAllHotelOrder:(void (^)(id response))success;
// 获取订单列表
- (void)requestOrderAllList:(void (^)(id response))success;
// 获取用户名带条件查询的订单列表（待付款，待收货，待评价，已完成）
- (void)requestOrderConListWithOrderStatus:(NSString *)orderStatus success:(void (^)(id response))success;
// 生成订单接口（未产生交易）状态为待付款（购物车结算）
- (void)requestShipOrderWithModel:(ZSHBuyOrderModel *)model success:(void (^)(id response))success;
// 上传头像
- (void)uploadImage:(NSArray *)imageArr name:(NSArray *)nameArr success:(void (^)(id response))success;


@end
