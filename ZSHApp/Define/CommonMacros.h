//
//  CommonMacros.h
//  MiAiApp
//
//  Created by Apple on 2017/8/31.
//  Copyright © 2017年 Apple. All rights reserved.
//

//全局标记字符串，用于 通知 存储

#ifndef CommonMacros_h
#define CommonMacros_h

#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange      @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess      @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick                @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName                     @"KUserCacheName"

//用户model缓存
#define KUserModelCache                    @"KUserModelCache"

#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange     @"KNotificationNetWorkStateChange"

// 美食（酒店，KTV,酒吧等）排序通知
#define KUpdateDataWithSort                 @"KUpdateDataWithSort"

//跳转直播预览页
#define KPresentPreviewVC                   @"KPresentPreviewVC"
#define KPresentFinishShowVC                @"KPresentFinishShowVC"
#define KPushLivePersonInfoVC               @"KPushLivePersonInfoVC"

//酒店，游艇入驻日历选择通知
#define KCalendarDateChanged               @"KCalendarDateChanged"

//三方分享
#define KShareInfo                          @"KShareInfo"
#endif /* CommonMacros_h */
