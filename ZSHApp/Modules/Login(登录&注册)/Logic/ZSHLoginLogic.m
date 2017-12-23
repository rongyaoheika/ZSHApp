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

// 账号密码
- (void)loginUserNamePwdWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlUserLoginCard parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

//  注册
- (void)userRegisterWithDic:(NSDictionary *)dic {

    [PPNetworkHelper POST:kUrlUserRegister parameters:dic success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        if (_loginSuccess) {
            _loginSuccess(responseObject);
        }
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

//选择卡种类的图片
- (void)requestCardImgsWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    
    [PPNetworkHelper POST:kUrlGetCardImgs parameters:dic success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 分类随机显示6个卡号 
- (void)requestCardNumWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlGetCardNum parameters:dic success:^(id responseObject) {
        RLog(@"请求参数：%@", dic);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


@end
