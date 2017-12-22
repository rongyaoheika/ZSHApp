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
@property (nonatomic,copy)   NSString            *PORTRAIT;         //头像
@property (nonatomic,copy)   NSString            *NICKNAME;         //名字
@property (nonatomic,copy)   NSString            *SEX;              //性别
@property (nonatomic,copy)   NSString            *distance;         //距离
@property (nonatomic,copy)   NSString            *age;              //年龄
@property (nonatomic,copy)   NSString            *constellation;    //星座

//底部
@property (nonatomic,copy)   NSString            *CONVERGETITLE;     //微博标题
@property (nonatomic,copy)   NSArray<NSString *> *CONVERGEIMGS;      //发表图片
@property (nonatomic,copy)   NSString            *STARTTIME;         //底部开始时间
@property (nonatomic,copy)   NSString            *ENDTIME;           //底部结束时间
@property (nonatomic,copy)   NSString            *CONVERGEPER;       //人数
@property (nonatomic,copy)   NSString            *CONVERGETYPE;      //方式

@property (nonatomic,assign) CGFloat             cellHeight;


// converge detail ID
@property (nonatomic, strong) NSString           *CONVERGEDETAIL_ID;
// userID
@property (nonatomic, strong) NSString           *HONOURUSER_ID;


@end
