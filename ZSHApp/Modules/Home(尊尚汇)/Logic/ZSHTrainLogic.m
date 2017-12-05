//
//  ZSHTrainLogic.m
//  ZSHApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTrainLogic.h"

@implementation ZSHTrainLogic


// 根据条件获取火车票列表接口
- (void)requestTrainSelectWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlTrainSelect parameters:dic success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
