//
//  URLMacros.h
//  MiAiApp
//
//  Created by Apple on 2017/8/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h


//内部版本号 每次发版递增
#define KVersionCode 1
/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1
#define TestSever       0
#define ProductSever    0

#if DevelopSever

/**开发服务器*/
#define kUrlRoot                    @"http://192.168.1.108:8080/ZSHINTER/"
//#define kUrlRoot                  @"http://192.168.11.122:8090" //展鹏

#elif TestSever

/**测试服务器*/
#define kUrlRoot                   @"http://192.168.1.108:8080/ZSHINTER/"

#elif ProductSever

/**生产服务器*/
#define kUrlRoot                   @"http://192.168.1.108:8080/ZSHINTER/"

#endif




#pragma mark - ——————— 详细接口地址 ————————

//测试接口
#define kUrlTest                    @"/api/cast/home/start"

#pragma mark - ——————— 用户相关 ————————

//注册
#define kUrlUserRegister            @"/appuserin/userregister?REGISTER"
//自动登录
#define kUrlUserAutoLogin           @"/api/autoLogin"
//登录
#define kUrlUserLogin               @"/appuserin/userloginphone?LOGIN"

#define kUrlUserHome(confusionCode) [NSString stringWithFormat:@"/apphomein/getrecommendlist?FKEY=%@", confusionCode]


#endif /* URLMacros_h */
