//
//  ZSHHotelLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelLogic.h"

@implementation ZSHHotelLogic


- (void)loadHotelListDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlSHotelDo parameters:paramDic success:^(id responseObject) {
        weakself.hotelListArr = [ZSHHotelModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(nil);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

- (void)loadHotelDetailDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlHotelSyn parameters:paramDic success:^(id responseObject) {
        RLog(@"酒店详情数据==%@",responseObject)
        ZSHHotelDetailModel *hotelDetailModel = [ZSHHotelDetailModel mj_objectWithKeyValues:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(hotelDetailModel);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}


@end
