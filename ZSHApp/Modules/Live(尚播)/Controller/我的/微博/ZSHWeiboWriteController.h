//
//  ZSHWeiboWriteController.h
//  ZSHApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger, ZSHWeiboWriteVC) {
    FromWordVCToZSHWeiboWriteVC,            // 头条-文字
    FromPhotoVCToZSHWeiboWriteVC,           // 头条-图片
    FromVideoVCToZSHWeiboWriteVC,           // 头条-视频
    FromWeiboVCToZSHWeiboWriteVC,           // 黑微博
    FromNoneVCToZSHWeiboWriteVC
};

@interface ZSHWeiboWriteController : RootViewController

@end
