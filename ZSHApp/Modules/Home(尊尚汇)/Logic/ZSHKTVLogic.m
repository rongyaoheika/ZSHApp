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
    [PPNetworkHelper POST:kUrlSktvlist parameters:paramDic success:^(id responseObject) {
        RLog(@"KTV列表数据==%@",responseObject);
        NSArray *KTVArr = responseObject[@"pd"];
        NSArray *KTVModelArr = [ZSHKTVModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        NSDictionary *paramDic = @{@"KTVArr":KTVArr,@"KTVModelArr":KTVModelArr};
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(paramDic);
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
        NSDictionary *KTVDetailParamDic = responseObject[@"pd"];
        ZSHKTVDetailModel *KTVDetailModel = [ZSHKTVDetailModel mj_objectWithKeyValues:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            NSDictionary *paramDic = @{@"KTVDetailModel":KTVDetailModel,@"KTVDetailParamDic":KTVDetailParamDic};
            weakself.requestDataCompleted(paramDic);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

@end
