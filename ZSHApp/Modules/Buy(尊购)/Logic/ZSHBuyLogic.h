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


@interface ZSHBuyLogic : ZSHLoginLogic

@property (nonatomic, strong) NSArray<ZSHPersonalModel *>                 *personModelArr;
@property (nonatomic, strong) ZSHPersonalDetailModel                      *personalDetailModel;
@property (nonatomic, strong) NSArray<ZSHGoodModel *>                     *goodsListModelArr;
@property (nonatomic, strong) NSArray<ZSHCollectModel *>                  *collectModelArr;


- (void)requestShipBrandList:(void(^)(id response))success;
- (void)requestBrandIconListWithBrandID:(NSString *)BrandID success:(void (^)(id response))success;
- (void)requestShipListAllsuccess:(void (^)(id response))success;
// 私人定制
- (void)requestPersonLists:(void (^)(id response))success;
// 定制详情
- (void)requestPersonDetailWithPersonalID:(NSString *)personalID success:(void (^)(id response))success;

- (void)requestShipCollectWithUserID:(NSString *)userID success:(void (^)(id response))success;
@end
