//
//  ZSHEntryLogic.m
//  ZSHApp
//
//  Created by mac on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHEntryLogic.h"

@implementation ZSHEntryLogic

//商家入驻
- (void)loadBusinessInDataWith:(NSDictionary *)dic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlAppBusinessIn parameters:dic success:^(id responseObject) {
        RLog(@"商家入驻信息%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"商家入驻失败");
    }];
}

@end
