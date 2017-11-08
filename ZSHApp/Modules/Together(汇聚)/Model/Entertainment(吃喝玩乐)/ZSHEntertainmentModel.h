//
//  ZSHEntertainmentModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHEntertainmentModel : ZSHBaseModel

//头部
@property (nonatomic,copy)   NSString    *avatarPicture;    //头像
@property (nonatomic,copy)   NSString    *name;             //名字
@property (nonatomic,assign) BOOL        gender;            //性别
@property (nonatomic,assign) CGFloat     distance;          //距离
@property (nonatomic,assign) NSUInteger  age;               //年龄
@property (nonatomic,copy)   NSString    *constellation;    //星座

//底部
@property (nonatomic,copy)   NSString    *title;             //微博标题
@property (nonatomic,copy)   NSString    *detailImage;       //发表图片
@property (nonatomic,copy)   NSString    *beginTime;         //底部开始时间
@property (nonatomic,copy)   NSString    *endTime;           //底部结束时间
@property (nonatomic,copy)   NSString    *personCount;       //人数
@property (nonatomic,copy)   NSString    *mode;              //方式

@property (nonatomic,assign) CGFloat     cellHeight;         

@end
