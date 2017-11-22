//
//  ZSHHomeLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHomeLogic.h"

@implementation ZSHHomeLogic

- (void)loadData{
    kWeakSelf(self);
    [PPNetworkHelper openLog];
    [PPNetworkHelper POST:kUrlUserHome parameters:nil success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        weakself.dataArr = [ZSHHomeMainModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(nil);
        }

    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
    
}

@end
