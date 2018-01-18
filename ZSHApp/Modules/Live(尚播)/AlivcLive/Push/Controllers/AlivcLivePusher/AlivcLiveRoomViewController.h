//
//  AlivcLiveRoomViewController.h
//  ZSHApp
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"
@class AlivcLivePushConfig;

@interface AlivcLiveRoomViewController : RootViewController

// URL
@property (nonatomic, strong) NSString *pushURL;
// SDK
@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;

@property (nonatomic, assign) BOOL isUseAsyncInterface;


@end
