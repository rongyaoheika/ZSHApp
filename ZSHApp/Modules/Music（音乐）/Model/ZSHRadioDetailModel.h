//
//  ZSHRadioDetailModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"
@class ZSHRadioDetailSubModel;
@interface ZSHRadioDetailModel : ZSHBaseModel

@property (nonatomic, copy)   NSString    *channel;    //"KTV金曲"
@property (nonatomic, copy)   NSString    *channelid;  //null
@property (nonatomic, copy)   NSString    *ch_name;    // "public_tuijian_ktv"
@property (nonatomic, copy)   NSString    *artistid;   //null
@property (nonatomic, copy)   NSString    *avatar;     //null
@property (nonatomic, copy)   NSString    *count;      //null

@property (nonatomic, strong) NSArray<ZSHRadioDetailSubModel*>    *songlist;//具体歌曲信息

@end

@interface ZSHRadioDetailSubModel : ZSHBaseModel

@property (nonatomic, copy)   NSString    *songid;     //歌曲id-获取歌曲
@property (nonatomic, copy)   NSString    *title;      //歌曲名字
@property (nonatomic, copy)   NSString    *artist;     //歌手名字
@property (nonatomic, copy)   NSString    *thumb;      //图片
@property (nonatomic, copy)   NSString    *havehigh;   //2
@property (nonatomic, copy)   NSString    *artist_id;  //歌手id-获取歌手歌单
@property (nonatomic, copy)   NSString    *all_artist_id;  //歌手id-获取歌手歌单
@property (nonatomic, copy)   NSString    *all_rate;

@end
