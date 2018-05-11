//
//  ZSHConfirmOrderLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHConfirmOrderLogic.h"

@implementation ZSHConfirmOrderLogic

- (void)requestHotelConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlShipHotlOrder parameters:paramDic success:^(id responseObject) {
        RLog(@"生成酒店订单==%@",responseObject);
        NSDictionary *detailDic = responseObject;
        success(detailDic);
        
//        result = 01;
//        ORDERNUMBER = 180504154424641473d27c;        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestFoodConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlShipFoodOrder parameters:paramDic success:^(id responseObject) {
        RLog(@"生成美食订单==%@",responseObject);
        NSDictionary *detailDic = responseObject[@"pd"];
        success(detailDic);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestKTVConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlShipKtvOrder parameters:paramDic success:^(id responseObject) {
        RLog(@"生成KTV订单==%@",responseObject);
        NSDictionary *detailDic = responseObject[@"pd"];
        success(detailDic);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestBarConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlAddBarOrder parameters:paramDic success:^(id responseObject) {
        RLog(@"生成酒吧订单==%@",responseObject);
        NSDictionary *detailDic = responseObject[@"pd"];
        success(detailDic);
        
    } failure:^(NSError *error) {
        
    }];
}

//高级特权
- (void)requestHighConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlAddHighOrder parameters:paramDic success:^(id responseObject) {
        RLog(@"高级特权订单==%@",responseObject);
        NSDictionary *detailDic = responseObject;
        success(detailDic);
        
    } failure:^(NSError *error) {
        
    }];
}

//支付回调接口
- (void)requestPayInfoWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlGetPayInfo parameters:paramDic success:^(id responseObject) {
        RLog(@"订单回调结果%@",responseObject);
        NSDictionary *detailDic = responseObject;
        success(detailDic);
        
    } failure:^(NSError *error) {
        
    }];
}

@end
