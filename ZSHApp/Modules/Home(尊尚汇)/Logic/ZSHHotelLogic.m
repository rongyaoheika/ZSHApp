//
//  ZSHHotelLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelLogic.h"
#import "ZSHHotelDetailModel.h"

@implementation ZSHHotelLogic


- (void)loadHotelListData{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlSHotelDo parameters:nil success:^(id responseObject) {
        weakself.hotelListArr = [ZSHHotelDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        RLog(@"酒店详情数据==%@",responseObject);
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(nil);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}


@end
