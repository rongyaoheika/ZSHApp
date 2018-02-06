//
//  ZSHUploadIDCardController.h
//  ZSHApp
//
//  Created by mac on 13/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM (NSInteger,ZSHToUploadPhotoVC) {
    FromIDCardVCToUploadPhotoVC,                   // 身份证
    FromStoreVCToUploadPhotoVC,                    // 店铺
    FromLicenseVCToUploadPhotoVC                   // 营业执照
};



@interface ZSHUploadIDCardController : RootViewController

@end
