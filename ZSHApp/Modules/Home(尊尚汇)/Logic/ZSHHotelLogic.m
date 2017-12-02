//
//  ZSHHotelLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelLogic.h"

@implementation ZSHHotelLogic

- (void)loadHotelListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSHotelDo parameters:paramDic success:^(id responseObject) {
        RLog(@"酒店列表数据==%@",responseObject)
       NSArray *hotelListDicArr = responseObject[@"pd"];
        success(hotelListDicArr);
        
    } failure:^(NSError *error) {
       
    }];
}

- (void)loadHotelDetailDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlHotelSyn parameters:paramDic success:^(id responseObject) {
        RLog(@"酒店详情数据==%@",responseObject)
        NSDictionary *hotelDetailParamDic = responseObject[@"pd"];
        ZSHHotelDetailModel *hotelDetailModel = [ZSHHotelDetailModel mj_objectWithKeyValues:responseObject[@"pd"]];
        NSDictionary *paramDic = @{@"hotelDetailModel":hotelDetailModel,@"hotelDetailParamDic":hotelDetailParamDic};
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(paramDic);
        }
        
    } failure:^(NSError *error) {
       
    }];
}

- (void)loadHotelDetailListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail {
    [PPNetworkHelper POST:kUrlHotelDetailList parameters:paramDic success:^(id responseObject) {
        RLog(@"酒店详情列表数据==%@",responseObject)
        NSArray *hotelDetaiDicListArr = responseObject[@"pd"];
        success(hotelDetaiDicListArr);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

//酒吧列表
- (void)loadBarListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSBar parameters:paramDic success:^(id responseObject) {
        RLog(@"酒吧列表数据==%@",responseObject)
        NSArray *barListDicArr = responseObject[@"pd"];
        success(barListDicArr);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

//酒吧详情
- (void)loadBarDetailDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlBarSyn parameters:paramDic success:^(id responseObject) {
        RLog(@"酒吧详情数据==%@",responseObject)
        NSDictionary *barDetailDic = responseObject[@"pd"];
        success(barDetailDic);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

//酒吧详情列表
- (void)loadBarDetailListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlBarDetailList parameters:paramDic success:^(id responseObject) {
        RLog(@"酒吧详情列表数据==%@",responseObject)
        NSArray *barDetailListDicArr = responseObject[@"pd"];
        success(barDetailListDicArr);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
