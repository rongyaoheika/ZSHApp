//
//  AliyunPlaySDKDemoFullScreenScrollCollectionViewCell.m
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/8/16.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import "AliyunPlaySDKDemoFullScreenScrollCollectionViewCell.h"
#import "UIView+Layout.h"
#import "ZSHLiveLogic.h"


#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface AliyunPlaySDKDemoFullScreenScrollCollectionViewCell()

@property (nonatomic, strong)UIView             *playerView;
@property (nonatomic, strong)ZSHLiveLogic       *liveLogic;

@end
@implementation AliyunPlaySDKDemoFullScreenScrollCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _liveLogic = [[ZSHLiveLogic alloc]init];
        self.isStart = NO;
        [self setContentView];
    }
    return self;
}

-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    return _aliPlayer;
}

- (void)setContentView{
    self.playerView = [[UIView alloc] init];
    self.playerView = self.aliPlayer.playerView;
    [self.contentView addSubview:self.playerView];
    self.playerView.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.aliPlayer setAutoPlay:YES];
    
    
}

- (void)prepareWithPublishUrl:(NSString *)publishUrl{
   [self.aliPlayer prepareWithURL:[NSURL URLWithString:publishUrl]];
}

- (void)startPlay{
    [self.aliPlayer start];
    self.isStart = YES;
}

- (void)pausePlay{
    [self.aliPlayer pause];
}

- (void)resumePlay{
    [self.aliPlayer resume];
}

- (void)stopPlay{
    [self.aliPlayer stop];
}

- (void)releasePlayer{
    [self.aliPlayer releasePlayer];
    self.isStart = NO;
}



@end
