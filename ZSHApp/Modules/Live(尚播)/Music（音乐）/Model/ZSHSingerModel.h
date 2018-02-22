//
//  ZSHSingerModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHSingerModel : ZSHBaseModel

@property (nonatomic, copy) NSString   *ting_uid;              //歌手id
@property (nonatomic, copy) NSString   *name;                  //歌手名字
@property (nonatomic, copy) NSString   *country;               //歌手国家
@property (nonatomic, copy) NSString   *gender;                //歌手性别
@property (nonatomic, copy) NSString   *firstchar;             //歌手名字首字母L
@property (nonatomic, copy) NSString   *avatar_big;            //歌手大头像
@property (nonatomic, copy) NSString   *avatar_small;          //歌手小头像
@property (nonatomic, copy) NSString   *albums_total;          //专辑个数
@property (nonatomic, copy) NSString   *songs_total;           //歌曲个数
@property (nonatomic, copy) NSString   *artist_id;
@property (nonatomic, copy) NSString   *area;

@end
