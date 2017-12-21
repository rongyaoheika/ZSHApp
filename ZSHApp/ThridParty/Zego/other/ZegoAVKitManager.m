//
//  ZegoAVKitManager.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZegoAVKitManager.h"
#import "ZegoSettings.h"

@implementation ZegoAVKitManager

static ZegoLiveRoomApi *g_ZegoApi = nil;

+ (ZegoLiveRoomApi *)api{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ZegoLiveRoomApi setUseTestEnv:YES];
        
#ifdef DEBUG
        [ZegoLiveRoomApi setVerbose:YES];
#endif
        
        [ZegoLiveRoomApi setUserID:[ZegoSettings sharedInstance].userID userName:[ZegoSettings sharedInstance].userName];
        
        NSData *appSign = [self zegoAppSignFromServer];
        if (appSign) {
            g_ZegoApi = [[ZegoLiveRoomApi alloc] initWithAppID:[self appID] appSignature:appSign];
        }
    });
    return g_ZegoApi;
}

+ (uint32_t)appID
{
    return kAppId_Zego;
}


+ (NSData *)zegoAppSignFromServer
{
        Byte signkey[] = {kAppKey_Zego};
        return [NSData dataWithBytes:signkey length:32];
}


@end
