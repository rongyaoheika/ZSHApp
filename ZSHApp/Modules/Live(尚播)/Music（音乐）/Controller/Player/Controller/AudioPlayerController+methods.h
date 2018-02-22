//
//  AudioPlayerController+methods.h
//  AudioPlayer
//
//  Created by ClaudeLi on 16/4/1.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import "AudioPlayerController.h"

@interface AudioPlayerController (methods)
/**
 *  创建部分控件
 */
- (void)creatViews;

/**
 *  设置旋转图的Frame
 */
- (void)setRotatingViewFrame;

/**
 *  设置旋转图片、模糊图片
 *
 *  @param model 当前的音乐model
 */
- (void)setImageWith:(ZSHRankModel *)model;

/**
 *  提示框
 *
 *  @param string 提示字符串
 */
- (void)progressHUDWith:(NSString *)string;


/** 添加歌词视图*/
- (void)addLrcView;
/** 设置歌词视图的 frame*/
- (void)setUpLrcViewFrame;

@end
