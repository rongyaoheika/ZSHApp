//
//  ZSHKTVLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHKTVLogic.h"

@implementation ZSHKTVLogic

- (void)loadKTVListDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlSHotelDo parameters:paramDic success:^(id responseObject) {
        NSArray *KTVListArr = [ZSHKTVModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(KTVListArr);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

- (void)loadKTVDetailDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlKtvSyn parameters:paramDic success:^(id responseObject) {
        RLog(@"KTV详情数据==%@",responseObject)
        ZSHKTVDetailModel *KTVDetailModel = [ZSHKTVDetailModel mj_objectWithKeyValues:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(KTVDetailModel);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}


@end
