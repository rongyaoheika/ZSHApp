//
//  ZSHPickView.h
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSHManageAddressViewController.h"

typedef void(^SaveChangeBlock)(NSString *str, NSInteger tag, NSDictionary *moreDic);

@interface ZSHPickView : UIWindow

@property (nonatomic, weak) RootViewController                   *controller;
@property (nonatomic, copy) SaveChangeBlock                      saveChangeBlock;
@property (nonatomic, strong) NSMutableArray                     *dataArr;

- (instancetype)initWithFrame:(CGRect)frame type:(ShowPickViewWindowType)type;
- (instancetype)initWithFrame:(CGRect)frame paramDic:(NSDictionary *)paramDic;

// 设置当前用户的身高和体重和出生日期
- (void)setUserBirthDay:(long long)birthday;
// 显示
- (void)show:(ShowPickViewWindowType)type;
// 消失
- (void)dismiss;

@end
