//
//  ZSHLoginLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

typedef void(^LoginSuccess)(id response);

@interface ZSHLoginLogic : ZSHBaseLogic

@property (nonatomic, copy) LoginSuccess loginSuccess;

//手机号登录
- (void)loginWithPhone:(NSString *)phone;
//卡密登录
- (void)loginWithCardNo:(NSString *)CardNo password:(NSString *)password;
// 注册
- (void)userRegisterWithDic:(NSDictionary *)dic;
// 账号密码
- (void)loginUserNamePwdWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 选择卡种类的图片
- (void)requestCardImgsWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 分类随机显示6个卡号
- (void)requestCardNumWithDic:(NSDictionary *)dic success:(void (^)(id response))success;


@end
