//
//  ZSHSongDetailModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHSongDetailModel : ZSHBaseModel

@property (nonatomic, copy) NSString   *show_link;
@property (nonatomic, copy) NSString   *file_link;             //.mp3
@property (nonatomic, copy) NSString   *title;                 //歌曲名字
@property (nonatomic, copy) NSString   *author;                //歌手名字
@property (nonatomic, copy) NSString   *ting_uid;              //歌手id
@property (nonatomic, copy) NSString   *si_proxycompany;       //歌手公司
@property (nonatomic, copy) NSString   *lrclink;               //歌词文件链接
@property (nonatomic, copy) NSString   *album_title;           //专辑名字
@property (nonatomic, copy) NSString   *song_id;               //歌曲id
@property (nonatomic, copy) NSString   *pic_radio;             //图片
@property (nonatomic, copy) NSString   *pic_huge;              //大图

@end
