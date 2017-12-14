//
//  UserInfo.h
//  MiAiApp
//
//  Created by Apple on 2017/8/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameInfo;

typedef NS_ENUM(NSInteger,UserGender){
    UserGenderUnKnow = 0,
    UserGenderMale, //男
    UserGenderFemale //女
};

@interface UserInfo : NSObject


@property (nonatomic,copy) NSString *HONOURUSER_ID;//用户ID
@property (nonatomic,copy) NSString *PORTRAIT;
@property (nonatomic,copy) NSString *SEX;
@property (nonatomic,copy) NSString *PASSWORD;
@property (nonatomic,copy) NSString *CUSTOM;
@property (nonatomic,copy) NSString *USERIDCARD;
@property (nonatomic,copy) NSString *SMALLCHANGE;
@property (nonatomic,copy) NSString *NICKNAME;
@property (nonatomic,copy) NSString *CARDNO;
@property (nonatomic,copy) NSString *PHONE;
@property (nonatomic,copy) NSString *SIGNNAME;
@property (nonatomic,copy) NSString *REALNAME;
@property (nonatomic,copy) NSString *ADDRESS;
@property (nonatomic,copy) NSString *PROVINCE;

//@property(nonatomic,assign)long long userid;//用户ID
//@property (nonatomic,copy) NSString * idcard;//展示用的用户ID
//@property (nonatomic,copy) NSString * photo;//头像
//@property (nonatomic,copy) NSString * nickname;//昵称
//@property (nonatomic, assign) UserGender sex;//性别
//@property (nonatomic,copy) NSString * imId;//IM账号
//@property (nonatomic,copy) NSString * imPass;//IM密码
//@property (nonatomic,assign) NSInteger  degreeId;//用户等级
//@property (nonatomic,copy) NSString * signature;//个性签名
//@property (nonatomic,copy) NSString * token;//用户登录后分配的登录Token
//@property (nonatomic, strong) GameInfo *info;//游戏数据

@end
