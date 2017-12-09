//
//  MusicModel.h
//  AudioPlayer
//
//  Created by ClaudeLi on 16/4/1.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

//@property (nonatomic, strong) NSNumber *music_id; // 歌曲id
//@property (nonatomic, strong) NSString *name; // 歌曲名
//@property (nonatomic, strong) NSString *icon; // 图片
//@property (nonatomic, strong) NSString *fileName; // 歌曲地址
//@property (nonatomic, strong) NSString *lrcName;
//@property (nonatomic, strong) NSString *singer; // 歌手
//@property (nonatomic, strong) NSString *singerIcon;


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
