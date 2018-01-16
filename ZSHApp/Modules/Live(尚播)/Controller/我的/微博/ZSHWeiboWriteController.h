//
//  ZSHWeiboWriteController.h
//  ZSHApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger, ZSHWeiboWriteVC) {
    FromWordVCToZSHWeiboWriteVC,            // 文字
    FromPhotoVCToZSHWeiboWriteVC,           // 图片
    FromVideoVCToZSHWeiboWriteVC,           // 视频
    FromNoneVCToZSHWeiboWriteVC
};

@interface ZSHWeiboWriteController : RootViewController

@end
