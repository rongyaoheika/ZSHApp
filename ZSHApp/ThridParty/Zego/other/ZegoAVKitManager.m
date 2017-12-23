//
//  ZegoAVKitManager.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZegoAVKitManager.h"
#import "ZegoSettings.h"

NSString *kZegoDemoAppTypeKey          = @"apptype";
NSString *kZegoDemoAppIDKey            = @"appid";
NSString *kZegoDemoAppSignKey          = @"appsign";


static ZegoLiveRoomApi *g_ZegoApi = nil;

//NSData *g_signKey = nil;
//uint32_t g_appID = 0;

BOOL g_useTestEnv = NO;
BOOL g_useAlphaEnv = NO;

#if TARGET_OS_SIMULATOR
BOOL g_useHardwareEncode = NO;
BOOL g_useHardwareDecode = NO;
#else
BOOL g_useHardwareEncode = YES;
BOOL g_useHardwareDecode = YES;
#endif

BOOL g_enableVideoRateControl = NO;

BOOL g_useExternalCaptrue = NO;
BOOL g_useExternalRender = NO;

BOOL g_enableReverb = NO;

BOOL g_recordTime = NO;
BOOL g_useInternationDomain = NO;
BOOL g_useExternalFilter = NO;

BOOL g_useHeadSet = NO;

static Byte toByte(NSString* c);
static NSData* ConvertStringToSign(NSString* strSign);

static __strong id<ZegoVideoCaptureFactory> g_factory = nil;
static __strong id<ZegoVideoFilterFactory> g_filterFactory = nil;

@implementation ZegoAVKitManager

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

#pragma mark - private

+ (bool)usingExternalCapture
{
    return g_useExternalCaptrue;
}

+ (void)setRecordTime:(bool)record
{
    if (g_recordTime == record)
        return;
    
    g_recordTime = record;
    [self setUsingExternalFilter:g_recordTime];
}

+ (bool)recordTime
{
    return g_recordTime;
}

+ (void)setUsingExternalFilter:(bool)bUse
{
    if (g_useExternalFilter == bUse)
        return;
    
    [self releaseApi];
    
    g_useExternalFilter = bUse;
    if (bUse)
    {
        if (g_filterFactory == nil)
//            g_filterFactory = [[ZegoVideoFilterFactoryDemo alloc] init];
        
        [ZegoLiveRoomApi setVideoFilterFactory:g_filterFactory];
    }
    else
    {
        [ZegoLiveRoomApi setVideoFilterFactory:nil];
    }
}

+ (void)releaseApi
{
    g_ZegoApi = nil;
}

@end
