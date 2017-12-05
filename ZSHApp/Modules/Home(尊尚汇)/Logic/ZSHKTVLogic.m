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
        
    }];
}


- (void)loadKTVDetailSetDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail {
    [PPNetworkHelper POST:kUrlKtvDetailList parameters:paramDic success:^(id responseObject) {
        
        RLog(@"KTV套餐列表数据==%@",responseObject)
        NSArray *KTVDetailSetArr = responseObject[@"pd"];
        success(KTVDetailSetArr);
        
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)loadKTVDetailListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail {
    [PPNetworkHelper POST:kUrlSKtvListRand parameters:paramDic success:^(id responseObject) {

        RLog(@"KTV更多商家列表数据==%@",responseObject)
        NSArray *KTVDetailListArr = responseObject[@"pd"];
        success(KTVDetailListArr);
        
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
