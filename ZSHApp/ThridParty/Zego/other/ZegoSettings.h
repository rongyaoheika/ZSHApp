//
//  ZegoSettings.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZegoAVKitManager.h"

@interface ZegoSettings : NSObject

@property (nonatomic, strong)   ZegoAVConfig       *currentConfig;
@property (nonatomic, readonly) NSArray            *appTypeList;
@property (readonly)            NSInteger          presetIndex;
@property (readonly)            NSArray            *presetVideoQualityList;
@property (nonatomic, assign)   int                beautifyFeature;
@property (readonly)            CGSize             currentResolution;
@property (nonatomic, copy)     NSString           *userID;
@property (nonatomic, copy)     NSString           *userName;

+ (instancetype)sharedInstance;
- (BOOL)selectPresetQuality:(NSInteger)presetIndex;
- (ZegoUser *)getZegoUser;
- (UIImage *)getBackgroundImage:(CGSize)viewSize withText:(NSString *)text;
- (NSUserDefaults *)myUserDefaults;

//- (UIViewController *)getViewControllerFromRoomInfo:(ZegoRoomInfo *)roomInfo;

@end
