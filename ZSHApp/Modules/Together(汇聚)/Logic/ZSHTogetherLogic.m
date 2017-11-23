//
//  ZSHTogetherLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTogetherLogic.h"

@implementation ZSHTogetherLogic

- (void)requestConvergeList:(void(^)(id ))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlConvergeList parameters:@{} success:^(id responseObject) {
        weakself.dataArr = [ZSHTogetherModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
