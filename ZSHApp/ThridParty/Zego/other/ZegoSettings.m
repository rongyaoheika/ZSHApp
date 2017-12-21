//
//  ZegoSettings.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZegoSettings.h"

@implementation ZegoSettings
{
    NSString *_userID;
    NSString *_userName;
}

+ (instancetype)sharedInstance {
    static ZegoSettings *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [self new];
    });
    
    return s_instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (ZegoUser *)getZegoUser
{
    ZegoUser *user = [ZegoUser new];
    user.userId = [ZegoSettings sharedInstance].userID;
    user.userName = [ZegoSettings sharedInstance].userName;
    
    return user;
}

#pragma mark - UserID & UserName

- (NSString *)userID {
    if (_userID.length == 0) {
        _userID = @"87653423";
    }
    return _userID;
}

- (void)setUserID:(NSString *)userID {
    _userID = userID;
}

- (NSString *)userName {
    if (_userName.length == 0) {
        _userName = @"zww";
    }
    
    return _userName;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
}


@end
