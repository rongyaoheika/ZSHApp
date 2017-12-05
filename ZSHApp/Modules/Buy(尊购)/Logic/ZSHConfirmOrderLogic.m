//
//  ZSHConfirmOrderLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHConfirmOrderLogic.h"

@implementation ZSHConfirmOrderLogic

- (void)requestConfirmOrderWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlShipHotlOrder parameters:paramDic success:^(id responseObject) {
        RLog(@"生成酒店订单==%@",responseObject);
        NSDictionary *newsDetailDic = responseObject[@"pd"];
        success(newsDetailDic);
        
    } failure:^(NSError *error) {
        
    }];
}

@end
