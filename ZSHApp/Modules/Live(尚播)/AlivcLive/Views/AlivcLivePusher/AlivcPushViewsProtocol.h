//
//  AlivcPushViewsProtocol.h
//  AlivcLivePusherTest
//
//  Created by lyz on 2017/11/24.
//  Copyright © 2017年 TripleL. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AlivcPublisherViewDelegate <NSObject>

- (void)publisherOnClickedBackButton;

- (void)publisherOnClickedPreviewButton:(BOOL)isPreview button:(UIButton *)sender;

- (BOOL)publisherOnClickedPushButton:(BOOL)isPush button:(UIButton *)sender;

- (void)publisherOnClickedPauseButton:(BOOL)isPause button:(UIButton *)sender;

- (void)publisherOnClickedRestartButton;

- (void)publisherOnClickedPushVideoButton:(BOOL)isMute button:(UIButton *)sender;
- (void)publisherOnClickedSwitchCameraButton;

- (void)publisherOnClickedFlashButton:(BOOL)flash button:(UIButton *)sender;

- (void)publisherOnClickedBeautyButton:(BOOL)beautyOn;


- (void)publisherOnClickedZoom:(CGFloat)zoom;

- (void)publisherOnClickedFocus:(CGPoint)focusPoint;

- (void)publisherOnClickedShowDebugTextInfo:(BOOL)isShow;

- (void)publisherOnClickedShowDebugChartInfo:(BOOL)isShow;


- (void)publisherSliderBeautyWhiteValueChanged:(int)value;

- (void)publisherSliderBeautyBuffingValueChanged:(int)value;

- (void)publisherSliderBeautyRubbyValueChanged:(int)value;

- (void)publisherSliderBeautyCheekPinkValueChanged:(int)value;

- (void)publisherSliderBeautyThinFaceValueChanged:(int)value;

- (void)publisherSliderBeautyShortenFaceValueChanged:(int)value;

- (void)publisherSliderBeautyBigEyeValueChanged:(int)value;

- (void)publisherOnBitrateChangedTargetBitrate:(int)targetBitrate;

- (void)publisherOnBitrateChangedMinBitrate:(int)minBitrate;


- (void)publisherOnClickSharedButon;

- (void)publisherOnClickAutoFocusButton:(BOOL)isAutoFocus;

- (void)publisherOnClickPreviewMirrorButton:(BOOL)isPreviewMorror;

- (void)publisherOnClickPushMirrorButton:(BOOL)isPushMirror;

@end


@protocol AlivcMusicViewDelegate <NSObject>

- (void)musicOnClickPlayButton:(BOOL)isPlay musicPath:(NSString *)musicPath;

- (void)musicOnClickPauseButton:(BOOL)isPause;

- (void)musicOnClickLoopButton:(BOOL)isLoop;

- (void)musicOnClickMuteButton:(BOOL)isMute;

- (void)musicOnClickEarBackButton:(BOOL)isEarBack;

- (void)musicOnClickDenoiseButton:(BOOL)isDenoiseOpen;

- (void)musicOnSliderAccompanyValueChanged:(int)value;

- (void)musicOnSliderVoiceValueChanged:(int)value;

@end

