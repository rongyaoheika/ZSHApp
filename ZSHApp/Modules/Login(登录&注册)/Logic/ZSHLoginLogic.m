//
//  ZSHLoginLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginLogic.h"

@implementation ZSHLoginLogic


- (void)loginWithPhone:(NSString *)phone {
    
    [PPNetworkHelper POST:kUrlUserHome parameters:@{@"PHONE":phone} success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        if (_loginSuccess) {
            _loginSuccess(responseObject);
        }
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


- (void)loginWithCardNo:(NSString *)CardNo password:(NSString *)password {
    
    [PPNetworkHelper POST:kUrlUserLoginCard parameters:@{@"CARDNO":CardNo,@"PASSWORD":password} success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        if (_loginSuccess) {
            _loginSuccess(responseObject);
        }
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
