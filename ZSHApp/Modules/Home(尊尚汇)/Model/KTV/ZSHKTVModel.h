//
//  ZSHKTVModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHKTVModel : ZSHBaseModel

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *comment;

//详情
@property (nonatomic, copy) NSString *detailImageName;  //支付界面图片
@property (nonatomic, copy) NSString *KTVName;          //麦乐迪（航天桥店）
@property (nonatomic, copy) NSString *roomType;         //小包（2-4人）
@property (nonatomic, copy) NSString *time;             //10:00-13:00，共3小时
@property (nonatomic, assign) CGFloat    cellHeight;

@end
