//
//  ZSHRadioModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"
@class ZSHRadioSubModel;

@interface ZSHRadioModel : ZSHBaseModel

@property (nonatomic, copy)   NSString                      *title; //公共频道
@property (nonatomic, copy)   NSString                      *cid;   //1
@property (nonatomic, strong) NSArray<ZSHRadioSubModel*>    *channellist;//具体歌曲信息

@end


@interface ZSHRadioSubModel : ZSHBaseModel

@property (nonatomic, copy)   NSString    *name;             // "漫步春天"
@property (nonatomic, copy)   NSString    *channelid;        //"62"
@property (nonatomic, copy)   NSString    *thumb;            //图片网址
@property (nonatomic, copy)   NSString    *ch_name;          // "public_tuijian_spring"
@property (nonatomic, copy)   NSString    *value;            //1000000,
@property (nonatomic, copy)   NSString    *cate_name;        //"tuijian"
@property (nonatomic, copy)   NSString    *cate_sname;       //"推荐频道"

@end
