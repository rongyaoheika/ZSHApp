//
//  ZegoSettings.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZegoSettings.h"

NSString *kZegoDemoUserIDKey            = @"userid";
NSString *kZegoDemoUserNameKey          = @"username";
NSString *kZegoDemoChannelIDKey         = @"channelid";
NSString *kZegoDemoVideoPresetKey       = @"preset";
NSString *kZegoDemoVideoWitdhKey        = @"resolution-width";
NSString *kZegoDemoVideoHeightKey       = @"resolution-height";
NSString *kZegoDemoVideoFrameRateKey    = @"framerate";
NSString *kZegoDemoVideoBitRateKey      = @"bitrate";
NSString *kZeogDemoBeautifyFeatureKey   = @"beautify_feature";

NSString *kZegoDemoWolfResolutionKey    = @"wolfResolution";
NSString *kZegoDemoWolfModeKey          = @"wolfMode";
NSString *kZegoDemoWolfLowDelayKey      = @"wolfLowDelay";


@implementation ZegoSettings
{
    NSString *_userID;
    NSString *_userName;
    int _beautifyFeature;
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
        _presetVideoQualityList = @[NSLocalizedString(@"超低质量", nil),
                                    NSLocalizedString(@"低质量", nil),
                                    NSLocalizedString(@"标准质量", nil),
                                    NSLocalizedString(@"高质量", nil),
                                    NSLocalizedString(@"超高质量", nil),
                                    NSLocalizedString(@"极高质量", nil),
                                    NSLocalizedString(@"自定义", nil)];
        
        _appTypeList = @[NSLocalizedString(@"国内版", nil),
                         NSLocalizedString(@"国际版", nil),
                         NSLocalizedString(@"自定义", nil)];
        
        [self loadConfig];
        
    }
    
    return self;
}

- (NSUserDefaults *)myUserDefaults {
    return [[NSUserDefaults alloc] initWithSuiteName:@"com.zoe.TC168"];
}

// 从本地文件加载保存的视频配置
- (void)loadConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id preset = [ud objectForKey:kZegoDemoVideoPresetKey];
    if (preset) {
        _presetIndex = [preset integerValue];
        if (_presetIndex < _presetVideoQualityList.count - 1) {
            _currentConfig = [ZegoAVConfig presetConfigOf:(ZegoAVConfigPreset)_presetIndex];
            return ;
        }
    } else {
        _presetIndex = ZegoAVConfigPreset_High;
        _currentConfig = [ZegoAVConfig presetConfigOf:ZegoAVConfigPreset_High];
        return ;
    }
    
    _currentConfig = [ZegoAVConfig presetConfigOf:ZegoAVConfigPreset_Generic];
    
    NSInteger vWidth = [ud integerForKey:kZegoDemoVideoWitdhKey];
    NSInteger vHeight = [ud integerForKey:kZegoDemoVideoHeightKey];
    if (vWidth && vHeight) {
        CGSize r = CGSizeMake(vWidth, vHeight);
        _currentConfig.videoEncodeResolution = r;
        _currentConfig.videoCaptureResolution = r;
    }
    
    id frameRate = [ud objectForKey:kZegoDemoVideoFrameRateKey];
    if (frameRate) {
        _currentConfig.fps = (int)[frameRate integerValue];
    }
    
    id bitRate = [ud objectForKey:kZegoDemoVideoBitRateKey];
    if (bitRate) {
        _currentConfig.bitrate = (int)[bitRate integerValue];
    }
}

// 保存视频配置
- (void)saveConfig {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(_presetIndex) forKey:kZegoDemoVideoPresetKey];
    
    if (_presetIndex >= self.presetVideoQualityList.count - 1) {
        [ud setInteger:_currentConfig.videoEncodeResolution.width forKey:kZegoDemoVideoWitdhKey];
        [ud setInteger:_currentConfig.videoEncodeResolution.height forKey:kZegoDemoVideoHeightKey];
        [ud setObject:@([_currentConfig fps]) forKey:kZegoDemoVideoFrameRateKey];
        [ud setObject:@([_currentConfig bitrate]) forKey:kZegoDemoVideoBitRateKey];
    } else {
        [ud removeObjectForKey:kZegoDemoVideoWitdhKey];
        [ud removeObjectForKey:kZegoDemoVideoHeightKey];
        [ud removeObjectForKey:kZegoDemoVideoFrameRateKey];
        [ud removeObjectForKey:kZegoDemoVideoBitRateKey];
    }
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

- (void)setCurrentConfig:(ZegoAVConfig *)currentConfig {
    _presetIndex = self.presetVideoQualityList.count - 1;
    _currentConfig = currentConfig;
    
    [self saveConfig];
}

#pragma mark - Beautify

- (int)beautifyFeature {
    if (_beautifyFeature == 0) {
        NSUserDefaults *ud = [self myUserDefaults];
        if ([ud objectForKey:kZeogDemoBeautifyFeatureKey]) {
            _beautifyFeature = (int)[ud integerForKey:kZeogDemoBeautifyFeatureKey];
        } else {
            _beautifyFeature = ZEGO_BEAUTIFY_POLISH | ZEGO_BEAUTIFY_WHITEN;
        }
    }
    
    return _beautifyFeature;
}

- (void)setBeautifyFeature:(int)beautifyFeature {
    if (_beautifyFeature != beautifyFeature) {
        _beautifyFeature = beautifyFeature;
        [[self myUserDefaults] setInteger:_beautifyFeature forKey:kZeogDemoBeautifyFeatureKey];
    }
}


@end
