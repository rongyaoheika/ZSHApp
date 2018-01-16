//
//  ZSHFindModel.h
//  ZSHApp
//
//  Created by apple on 2017/12/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHFindModel : ZSHBaseModel

@property (nonatomic, copy) NSString   *TITLE;
@property (nonatomic, copy) NSString   *SHOWVIDEO;            // video
@property (nonatomic, strong) NSArray  *VIDEOBACKIMAGE;       // 图片
@property (nonatomic, copy) NSString   *PAGEVIEWS;            // 浏览量
@property (nonatomic, copy) NSString   *DIS_TYPE;

@property (nonatomic, copy) NSString   *DISCOVERVIDEO_ID;

@end
