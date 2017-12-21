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

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;

+ (instancetype)sharedInstance;
- (ZegoUser *)getZegoUser;

@end
