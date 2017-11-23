//
//  ZSHBuyLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginLogic.h"

@interface ZSHBuyLogic : ZSHLoginLogic


- (void)requestShipBrandList:(void(^)(id response))success;

- (void)requestBrandIconListWithBrandID:(NSString *)BrandID success:(void (^)(id response))success;

- (void)requestShipCollectWithUserID:(NSString *)userID success:(void (^)(id response))success;
@end
