//
//  AlivcPublisherViewController.h
//  AlivcLiveCaptureDev
//
//  Created by TripleL on 17/7/10.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "RootViewController.h"
@class AlivcLivePushConfig;

@interface AlivcLivePusherViewController : RootViewController


// SDK
@property (nonatomic, strong) AlivcLivePushConfig *pushConfig;

@property (nonatomic, assign) BOOL isUseAsyncInterface;

@end
