//
//  ZSHMineLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHAddrModel.h"
#import "ZSHGoodOrderModel.h"
#import "ZSHBuyOrderModel.h"
#import "ZSHHotelOrderModel.h"


@interface ZSHMineLogic : ZSHBaseLogic

@property (nonatomic, strong) ZSHAddrModel                     *addNewAddr;
@property (nonatomic, strong) ZSHBuyOrderModel                 *buyOrderModel;
@property (nonatomic, strong) NSMutableArray<ZSHAddrModel *>   *addrModelArr;
@property (nonatomic, strong) NSArray<ZSHGoodOrderModel *>     *goodOrderModelArr;
@property (nonatomic, strong) NSArray<ZSHHotelOrderModel *>    *hotlOrderModelArr;
@property (nonatomic, strong) NSArray<ZSHKtvOrderModel *>      *ktvOrderModelArr;
@property (nonatomic, strong) NSArray<ZSHFoodOrderModel *>     *foodOrderModelArr;
@property (nonatomic, strong) NSArray<ZSHBarorderOrderModel *> *barorderOrderModelArr;


// 获取用户收货地址列表
- (void)requestShipAdr:(NSString *)userID success:(void (^)(id response))success;
// 添加用户收货地址
- (void)requestShipAddShipAdr:(void (^)(id response))success;
// 删除用户收货地址
- (void)requestUserDelShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success;
// 修改用户收货地址
- (void)requestUserEdiShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success;
// 获得用户名下所有KTV订单列表
- (void)requestKtvOrderAllList:(void (^)(id response))success;
// 获得用户名下订单列表
- (void)requestOrderWithURL:(NSString *)url orderStatus:(NSString *)orderStatus success:(void (^)(id response))success;
// 获取订单列表
- (void)requestOrderAllList:(void (^)(id response))success;
// 获取用户名带条件查询的订单列表（待付款，待收货，待评价，已完成）
- (void)requestOrderConListWithOrderStatus:(NSString *)orderStatus success:(void (^)(id response))success;
// 生成订单接口（未产生交易）状态为待付款（购物车结算）
- (void)requestShipOrderWithModel:(ZSHBuyOrderModel *)model success:(void (^)(id response))success;
// 上传头像
- (void)uploadImage:(NSArray *)imageArr name:(NSArray *)nameArr success:(void (^)(id response))success;
// 修改个人信息
- (void)requestUserInfoWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 获取个人信息
- (void)requestGetUserInfo:(void (^)(id response))success;
// 修改用户密码
- (void)requestUserUpdPasswordWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 获取能量值
- (void)requestEnergyList:(void (^)(id response))success;
// 按月份统计用户能量值
- (void)requestEnergyValueMonth:(void (^)(id response))success;
// 获取用户会员中心信息
- (void)requestGetMemberInfo:(void (^)(id response))success;
// 获取我的优惠券，黑卡币，能量值
- (void)requestCouBlackEnergy:(void (^)(id response))success;
// 给商品添加用户评价
- (void)requestSProductAddEva:(NSDictionary *)dic success:(void (^)(id response))success;
// 找回登录密码 (忘记密码)
- (void)requestForgetUser:(NSDictionary *)dic success:(void (^)(id response))success;
// 修改用户手机号码
- (void)requestUserPhone:(NSDictionary *)dic success:(void (^)(id response))success;
// 根据店铺获取优惠券列表
- (void)requestCouponList:(NSDictionary *)dic success:(void (^)(id response))success;
// 获取验证码
- (void)requestMessageCodeWithDic:(NSDictionary *)dic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

@end
