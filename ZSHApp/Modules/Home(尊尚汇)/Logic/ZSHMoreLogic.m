//
//  ZSHMoreLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMoreLogic.h"

@implementation ZSHMoreLogic

- (void)requestHorseListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSHorseList parameters:paramDic success:^(id responseObject) {
        RLog(@"马术列表数据==%@",responseObject)
        NSArray *horseDicArr = responseObject[@"pd"];
        success(horseDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestYachtListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSYachtlist parameters:paramDic success:^(id responseObject) {
        RLog(@"游艇列表数据==%@",responseObject)
        NSArray *yachtDicArr = responseObject[@"pd"];
        success(yachtDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestGolfListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSGolflist parameters:paramDic success:^(id responseObject) {
        RLog(@"高尔夫列表数据==%@",responseObject)
        NSArray *golfDicArr = responseObject[@"pd"];
        success(golfDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestLuxcarListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSLuxcarlist parameters:paramDic success:^(id responseObject) {
        RLog(@"豪车列表数据==%@",responseObject)
        NSArray *luxcarDicArr = responseObject[@"pd"];
        success(luxcarDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestHorseDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlHorseDetail parameters:paramDic success:^(id responseObject) {
        RLog(@"马术详情数据==%@",responseObject)
        NSArray *horseDetailDicArr = responseObject[@"pd"];
        success(horseDetailDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestYachtDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlYachtDetail parameters:paramDic success:^(id responseObject) {
        RLog(@"游艇详情数据==%@",responseObject)
        NSArray *yachtDetailDicArr = responseObject[@"pd"];
        success(yachtDetailDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestGolfDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlGolfDetail parameters:paramDic success:^(id responseObject) {
        RLog(@"高尔夫详情数据==%@",responseObject)
        NSArray *golfDetailDicArr = responseObject[@"pd"];
        success(golfDetailDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestLuxcarDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlLuxcarDetail parameters:paramDic success:^(id responseObject) {
        RLog(@"豪车详情数据==%@",responseObject)
        NSArray *luxcarDetailDicArr = responseObject[@"pd"];
        success(luxcarDetailDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestPlaneDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlPlaneDetail parameters:paramDic success:^(id responseObject) {
        RLog(@"飞机详情数据==%@",responseObject)
        NSArray *planeDetailDicArr = responseObject[@"pd"];
        success(planeDetailDicArr);
        
    } failure:^(NSError *error) {
        
    }];
}



@end
