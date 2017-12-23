//
//  AudioPlayerController.h
//  AudioPlayer
//
//  Created by ClaudeLi on 16/4/1.
//  Copyright © 2016年 ClaudeLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZSHRankModel.h"
#import "RotatingView.h"   // 旋转View
#import "ZSHMusicLryViewController.h"
#import "QQLrcLabel.h"
/**
 *  注：为适配中间旋转图片大小
 *      topHeight: 上部分控件高度
 *      downHeight: 下部分控件高度
 */
static CGFloat topHeight = 64.0+20.0; 
static CGFloat downHeight = 100.0+16.0;

/**
 *  AudioPlayerMode 播放模式
 */
typedef NS_ENUM(NSInteger, AudioPlayerMode) {
    /**
     *  顺序播放
     */
    AudioPlayerModeOrderPlay,
    /**
     *  随机播放
     */
    AudioPlayerModeRandomPlay,
    /**
     *  单曲循环
     */
    AudioPlayerModeSinglePlay,
};


typedef void(^PaceValueChanged) (float value);
typedef void(^PlayStatus) (float value,BOOL play);

@interface AudioPlayerController : UIViewController

+(AudioPlayerController *)audioPlayerController;

// 播放模式
@property (assign, nonatomic)AudioPlayerMode  playerMode;

// 进度条
@property (weak, nonatomic) IBOutlet UISlider *paceSlider;
@property (copy, nonatomic) PaceValueChanged  paceValueChanged;
@property (copy, nonatomic) PlayStatus        playStatus;

/**
 *  旋转View
 */
@property (strong, nonatomic) RotatingView *rotatingView;
/**
 *  背景模糊图
 */
@property (weak, nonatomic) IBOutlet UIImageView *underImageView;
/**
 *  第三方提示MBProgressHUD
 */
@property (strong, nonatomic) MBProgressHUD *HUD;

/**
 *  播放器数据传入
 *
 *  @param array 传入所有数据model数组
 *  @param index 传入当前model在数组的下标
 */
- (void)initWithArray:(NSArray *)array index:(NSInteger)index;

/**
 *  开始播放
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)stop;

/**
 *  播放/暂停按钮点击事件执行的方法
 */
- (void)playerStatus;

/**
 *  上一曲
 */
- (void)inASong;

/**
 *  下一曲
 */
- (void)theNextSong;

// *************************** 其他控件或数据 ********************************
/** 单行歌词*/
@property (nonatomic, strong) QQLrcLabel *lrcLabel;

/** 歌词的背景视图*/
//@property (weak, nonatomic) IBOutlet UIScrollView *lrcBackView;
@property (nonatomic, strong) UIScrollView      *lrcBackView;

/** 歌词视图*/
@property (nonatomic, strong) UIView            *lrcView;

/** 歌词控制器*/
@property (nonatomic, strong) ZSHMusicLryViewController *lrcTVC;

/** 定时器*/
@property (nonatomic, weak) NSTimer *timer;

/** 歌词定时器*/
@property (nonatomic, weak) CADisplayLink *displayLink;

/** 进度条手势*/
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end
