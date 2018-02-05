//
//  ZSHUploadIDCardController.h
//  ZSHApp
//
//  Created by mac on 13/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM (NSInteger,ZSHToUploadIDCardVC) {
    FromCreateStoreVCToLiveContentFirstVC,             // 门店创建提交
    FromWeMediaVerifyVCToLiveContentFirstVC,           // 自媒体提交
    FromActivityCenterVCToLiveContentFirstVC
};



@interface ZSHUploadIDCardController : RootViewController

@end
