//
//  ZSHConfirmOrderLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

@interface ZSHConfirmOrderLogic : ZSHBaseLogic

//酒店订单
- (void)requestHotelConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//美食订单
- (void)requestFoodConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//KTV订单
- (void)requestKTVConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒吧订单
- (void)requestBarConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//高级特权
- (void)requestHighConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//支付回调接口
- (void)requestPayInfoWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//生成美食酒店酒吧KTV订单接口
- (void)requestStoreConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
@end
