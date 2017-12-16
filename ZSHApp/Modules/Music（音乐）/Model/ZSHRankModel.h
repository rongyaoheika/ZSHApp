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

@property (nonatomic, copy) NSString        *artist_id;
@property (nonatomic, copy) NSString        *title;         //歌名
@property (nonatomic, copy) NSString        *author;        //歌手名字
@property (nonatomic, copy) NSString        *album_title;   //专辑名字
@property (nonatomic, copy) NSString        *pic_big;       //大图（模糊背景）
@property (nonatomic, copy) NSString        *pic_small;     //小图（中间）
@property (nonatomic, copy) NSString        *song_id;       //歌曲id
@property (nonatomic, copy) NSString        *ting_uid;      //歌手id
@property (nonatomic, copy) NSString        *hot;           //热度

//电台
@property (nonatomic, copy) NSString        *songid;        //歌曲id(电台)
@property (nonatomic, copy) NSString        *thumb;         //电台图片


//歌曲详情
@property (nonatomic, copy) NSString   *file_link;             //.mp3
@property (nonatomic, copy) NSString   *pic_radio;             //图片
@property (nonatomic, copy) NSString   *pic_huge;              //大图
@property (nonatomic, copy) NSString   *lrcContent;            //歌词字符串


@end

