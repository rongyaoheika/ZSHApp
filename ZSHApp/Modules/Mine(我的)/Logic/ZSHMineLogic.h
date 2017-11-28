//
//  ZSHMineLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginLogic.h"
#import "ZSHAddrModel.h"

@interface ZSHMineLogic : ZSHLoginLogic

@property (nonatomic, strong) ZSHAddrModel                     *addNewAddr;
@property (nonatomic, strong) NSMutableArray<ZSHAddrModel *>   *addrModelArr;


// 获取用户收货地址列表
- (void)requestShipAdr:(NSString *)userID success:(void (^)(id response))success;
// 添加用户收货地址
- (void)requestShipAddShipAdr:(void (^)(id response))success;
// 删除用户收货地址
- (void)requestUserDelShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success;
// 修改用户收货地址
- (void)requestUserEdiShipAdrWithModel:(ZSHAddrModel *)model success:(void (^)(id response))success;
@end
