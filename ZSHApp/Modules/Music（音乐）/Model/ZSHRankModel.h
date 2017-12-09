//
//  ZSHRankModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@class ZSHRankDetailModel;

@interface ZSHRankModel : ZSHBaseModel

//@property (nonatomic, strong) NSArray<ZSHRankDetailModel*>   *song_list;
//@property (nonatomic, strong) NSDictionary  *billboard;


//@property (nonatomic, strong) NSNumber *music_id; // 歌曲id
//@property (nonatomic, strong) NSString *name; // 歌曲名
//@property (nonatomic, strong) NSString *icon; // 图片
//@property (nonatomic, strong) NSString *fileName; // 歌曲地址
//@property (nonatomic, strong) NSString *lrcName;
//@property (nonatomic, strong) NSString *singer; // 歌手
//@property (nonatomic, strong) NSString *singerIcon;

@property (nonatomic, copy) NSString        *artist_id;
@property (nonatomic, copy) NSString        *title;         //歌名
@property (nonatomic, copy) NSString        *author;        //歌手名字
@property (nonatomic, copy) NSString        *artist_name;   //歌手名字
@property (nonatomic, copy) NSString        *album_title;   //专辑名字
@property (nonatomic, copy) NSString        *lrclink;       //歌词链接
@property (nonatomic, copy) NSString        *pic_big;       //大图（模糊背景）
@property (nonatomic, copy) NSString        *pic_small;     //小图（中间）
@property (nonatomic, copy) NSString        *song_id;       //歌曲id
@property (nonatomic, copy) NSString        *ting_uid;      //歌手id
@property (nonatomic, copy) NSString        *hot;           //热度


@end

