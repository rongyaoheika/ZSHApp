//
//  ZSHWeiBoModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHWeiBoCellModel : ZSHBaseModel

@property (nonatomic, copy) NSString *NICKNAME;
@property (nonatomic, copy) NSString *STATUS;
@property (nonatomic, copy) NSString *PORTRAIT;
@property (nonatomic, copy) NSString *AGREECOUNT;
@property (nonatomic, copy) NSString *CIRCLE_ID;
@property (nonatomic, copy) NSString *HONOURUSER_ID;
@property (nonatomic, copy) NSString *CONTENT;
@property (nonatomic, copy) NSString *PUBLISHTIME;
@property (nonatomic, copy) NSArray  *SHOWIMAGES;
@property (nonatomic, copy) NSString *COMMENTCOUNT;
@property (nonatomic, assign) CGFloat hight;// 图片开始的高度


+(instancetype)modelWithDict:(NSDictionary *)dict;
-(void)updateRowHeight;

@end
