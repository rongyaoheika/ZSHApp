//
//  AlivcPublisherViewController.m
//  AlivcLiveCaptureDev
//
//  Created by TripleL on 17/7/10.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcLivePusherViewController.h"
#import "AlivcPublisherView.h"
#import "AlivcPushViewsProtocol.h"
#import <AlivcLivePusher/AlivcLivePusherHeader.h>
#import "ZSHLiveLogic.h"

#define kAlivcLivePusherVCAlertTag 89976
#define kAlivcLivePusherNoticeTimerInterval 5.0



@interface AlivcLivePusherViewController () <AlivcPublisherViewDelegate, AlivcMusicViewDelegate, AlivcLivePusherInfoDelegate, AlivcLivePusherErrorDelegate, AlivcLivePusherNetworkDelegate, AlivcLivePusherBGMDelegate, UIAlertViewDelegate>

// UI
@property (nonatomic, strong) AlivcPublisherView *publisherView;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) NSTimer *noticeTimer;

// flags
@property (nonatomic, assign) BOOL isAutoFocus;

// SDK
@property (nonatomic, strong) AlivcLivePusher *livePusher;

//直播UI类型：预览，直播
@property (nonatomic, assign) AlivcPublisherViewType  viewType;

//直播UI类型：预览，直播
@property (nonatomic, strong) ZSHLiveLogic  *liveLogic;

@end

@implementation AlivcLivePusherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果不需要退后台继续推流，可以参考这套退后台通知的实现。
//    [self addBackgroundNotifications];
    
    _viewType = AlivcPublisherViewTypePreview;
    [self createUI];
    [self loadData];
}

- (void)createUI{
     [self setupSubviews];
}

- (void)loadData{
//    _liveLogic = [[ZSHLiveLogic alloc]init];
//    [self getPushAddress];
    
    [self setupDefaultValues];
    [self setupDebugTimer];
    
    int ret = [self setupPusher];
    
    if (ret != 0) {
        [self showPusherInitErrorAlert:ret];
        return;
    }
    
    ret = [self startPreview];
    
    if (ret != 0) {
        [self showPusherStartPreviewErrorAlert:ret isStart:YES];
        return;
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if (self.pushConfig.orientation == AlivcLivePushOrientationLandscapeLeft) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    } else if (self.pushConfig.orientation == AlivcLivePushOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


#pragma mark - SDK

/**
 创建推流
 */
- (int)setupPusher {
    
    self.livePusher = [[AlivcLivePusher alloc] initWithConfig:self.pushConfig];
    [self.livePusher setLogLevel:(AlivcLivePushLogLevelFatal)];
    if (!self.livePusher) {
        return -1;
    }
    [self.livePusher setInfoDelegate:self];
    [self.livePusher setErrorDelegate:self];
    [self.livePusher setNetworkDelegate:self];
    [self.livePusher setBGMDelegate:self];
    return 0;
}


/**
 销毁推流
 */
- (void)destoryPusher {
    
    if (self.livePusher) {
        [self.livePusher destory];
    }
    
    self.livePusher = nil;
}


/**
 开始预览
 */
- (int)startPreview {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher startPreviewAsync:self.previewView];
        
    } else {
        // 使用同步接口
        ret = [self.livePusher startPreview:self.previewView];
    }
    return ret;
}


/**
 停止预览
 */
- (int)stopPreview {
    
    if (!self.livePusher) {
        return -1;
    }
    int ret = [self.livePusher stopPreview];
    return ret;
}


/**
 开始推流
 */
- (int)startPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher startPushWithURLAsync:self.pushURL];
    
    } else {
        // 使用同步接口
        ret = [self.livePusher startPushWithURL:self.pushURL];
    }
    return ret;
}


/**
 停止推流
 */
- (int)stopPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = [self.livePusher stopPush];
    return ret;
}


/**
 暂停推流
 */
- (int)pausePush {
    
    if (!self.livePusher) {
        return -1;
    }

    int ret = [self.livePusher pause];
    return ret;
}


/**
 恢复推流
 */
- (int)resumePush {
   
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;

    if (self.isUseAsyncInterface) {
        // 使用异步接口
       ret = [self.livePusher resumeAsync];
        
    } else {
        // 使用同步接口
        ret = [self.livePusher resume];
    }
    return ret;
}



/**
 重新推流
 */
- (int)restartPush {
    
    if (!self.livePusher) {
        return -1;
    }
    
    int ret = 0;
    if (self.isUseAsyncInterface) {
        // 使用异步接口
        ret = [self.livePusher restartPushAsync];
        
    } else {
        // 使用同步接口
        ret = [self.livePusher restartPush];
    }
    return ret;
}


- (void)reconnectPush {
    
    if (!self.livePusher) {
        return;
    }
    
    [self.livePusher reconnectPushAsync];
}

#pragma mark - AlivcLivePusherErrorDelegate

- (void)onSystemError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {

    [self showAlertViewWithErrorCode:error.errorCode
                            errorStr:error.errorDescription
                                 tag:kAlivcLivePusherVCAlertTag+11
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"system_error", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"exit", nil)
                   otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
}


- (void)onSDKError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
    [self showAlertViewWithErrorCode:error.errorCode
                            errorStr:error.errorDescription
                                 tag:kAlivcLivePusherVCAlertTag+12
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"sdk_error", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"exit", nil)
                   otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
}



#pragma mark - AlivcLivePusherNetworkDelegate

- (void)onConnectFail:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
    [self showAlertViewWithErrorCode:error.errorCode
                            errorStr:error.errorDescription
                                 tag:kAlivcLivePusherVCAlertTag+23
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"connect_fail", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"reconnect_button", nil)
                   otherButtonTitles:NSLocalizedString(@"exit", nil), nil];

}


- (void)onSendDataTimeout:(AlivcLivePusher *)pusher {
    
    [self showAlertViewWithErrorCode:0
                            errorStr:nil
                                 tag:0
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"senddata_timeout", nil)
                            delegate:nil
                         cancelTitle:NSLocalizedString(@"ok", nil)
                   otherButtonTitles:nil];
}


- (void)onConnectRecovery:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"connectRecovery_log", nil)];
}


- (void)onNetworkPoor:(AlivcLivePusher *)pusher {
    
    [self showAlertViewWithErrorCode:0 errorStr:nil tag:0 title:NSLocalizedString(@"dialog_title", nil) message:@"当前网速较慢，请检查网络状态" delegate:nil cancelTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
}


- (void)onReconnectStart:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"reconnect_start", nil)];
}


- (void)onReconnectSuccess:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"reconnect_success", nil)];
}


- (void)onReconnectError:(AlivcLivePusher *)pusher error:(AlivcLivePushError *)error {
    
    [self showAlertViewWithErrorCode:error.errorCode
                            errorStr:error.errorDescription
                                 tag:kAlivcLivePusherVCAlertTag+22
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"reconnect_fail", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"reconnect_button", nil)
                   otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
}


#pragma mark - AlivcLivePusherInfoDelegate

- (void)onPreviewStarted:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"start_preview_log", nil)];
}


- (void)onPreviewStoped:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"stop_preview_log", nil)];
}

- (void)onPushStarted:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"start_push_log", nil)];
}


- (void)onPushPauesed:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"pause_push_log", nil)];
}


- (void)onPushResumed:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"resume_push_log", nil)];
}


- (void)onPushStoped:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"stop_push_log", nil)];
}


- (void)onFirstFramePreviewed:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"first_frame_log", nil)];
}


- (void)onPushRestart:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"restart_push_log", nil)];
}


#pragma mark - AlivcLivePusherBGMDelegate

- (void)onStarted:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"BGM Start", nil)];
}


- (void)onStoped:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"BGM Stop", nil)];
}


- (void)onPaused:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"BGM Pause", nil)];
}


- (void)onResumed:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"bgm Resume", nil)];
}


- (void)onProgress:(AlivcLivePusher *)pusher progress:(long)progress duration:(long)duration {
    
    [self.publisherView updateMusicDuration:progress totalTime:duration];
}


- (void)onCompleted:(AlivcLivePusher *)pusher {
    
    [self.publisherView updateInfoText:NSLocalizedString(@"BGM Play Complete", nil)];
}


- (void)onOpenFailed:(AlivcLivePusher *)pusher {
    
    [self.publisherView resetMusicButtonTypeWithPlayError];
    [self showAlertViewWithErrorCode:0
                            errorStr:nil
                                 tag:0
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"BGM File Open Failed", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"ok", nil)
                   otherButtonTitles:nil];
}


- (void)onDownloadTimeout:(AlivcLivePusher *)pusher {
    
    [self.publisherView resetMusicButtonTypeWithPlayError];
    [self showAlertViewWithErrorCode:0
                            errorStr:nil
                                 tag:0
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:NSLocalizedString(@"BGM Download Timeout", nil)
                            delegate:self
                         cancelTitle:NSLocalizedString(@"ok", nil)
                   otherButtonTitles:nil];
}



#pragma mark - 退后台停止推流的实现方案

- (void)addBackgroundNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}


- (void)applicationWillResignActive:(NSNotification *)notification {

    if (!self.livePusher) {
        return;
    }
    
    // 如果退后台不需要继续推流，则停止推流
    if ([self.livePusher isPushing]) {
        [self.livePusher stopPush];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {

    if (!self.livePusher) {
        return;
    }
    
    if ([self.publisherView getPushButtonType]) {
        // 当前是推流模式，恢复推流
        [self.livePusher startPushWithURLAsync:self.pushURL];
    }
}

#pragma mark - AlivcPublisherViewDelegate

- (void)publisherOnClickedBackButton {
    
    [self cancelTimer];
    [self destoryPusher];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)publisherOnClickedPreviewButton:(BOOL)isPreview button:(UIButton *)sender {
    
    if (isPreview) {
        int ret = [self startPreview];
        if (ret != 0) {
            [self showPusherStartPreviewErrorAlert:ret isStart:YES];
            [sender setSelected:!sender.selected];
        }
    } else {
        int ret = [self stopPreview];
        if (ret != 0) {
            [self showPusherStartPreviewErrorAlert:ret isStart:NO];
            [sender setSelected:!sender.selected];
        }
    }
}

- (BOOL)publisherOnClickedPushButton:(BOOL)isPush button:(UIButton *)sender {
    _viewType = AlivcPublisherViewTypeLive;
    if (isPush) {
        // 开始推流
        int ret = [self startPush];
        if (ret != 0) {
            [self showPusherStartPushErrorAlert:ret isStart:YES];
            [sender setSelected:!sender.selected];
            return NO;
        }
        
        //预览->直播
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.publisherView removeFromSuperview];
            self.publisherView = nil;
            [self.view addSubview: self.publisherView];
        });
        
        
        return YES;
    } else {
        // 停止推流
        int ret = [self stopPush];
        if (ret != 0) {
            [self showPusherStartPushErrorAlert:ret isStart:NO];
            [sender setSelected:!sender.selected];
            return NO;
        }
        return YES;
    }
}

- (void)publisherOnClickedPauseButton:(BOOL)isPause button:(UIButton *)sender {
    
    if (isPause) {
        int ret = [self pausePush];
        if (ret != 0) {
            [self showPusherPausePushErrorAlert:ret isPause:YES];
            [sender setSelected:!sender.selected];
        }

    } else {
        int ret = [self resumePush];
        if (ret != 0) {
            [self showPusherPausePushErrorAlert:ret isPause:NO];
            [sender setSelected:!sender.selected];
        }
    }
}


- (void)publisherOnClickedRestartButton {
    
    int ret = [self restartPush];
    if (ret != 0) {
        
        [self showAlertViewWithErrorCode:ret
                                errorStr:nil
                                     tag:0
                                   title:NSLocalizedString(@"dialog_title", nil)
                                 message:@"Restart Error"
                                delegate:nil
                             cancelTitle:NSLocalizedString(@"ok", nil)
                       otherButtonTitles:nil];
    }
}

- (void)publisherOnClickedSwitchCameraButton {
    
    if (self.livePusher) {
        [self.livePusher switchCamera];
    }
}

- (void)publisherOnClickedFlashButton:(BOOL)flash button:(UIButton *)sender {
    
    if (self.livePusher) {
        [self.livePusher setFlash:flash?true:false];
    }
}

- (void)publisherOnClickedBeautyButton:(BOOL)beautyOn {
    
    if (self.livePusher) {
        [self.livePusher setBeautyOn:beautyOn?true:false];
    }
}

- (void)publisherOnClickedZoom:(CGFloat)zoom {
    
    if (self.livePusher) {
        CGFloat max = [_livePusher getMaxZoom];
        [self.livePusher setZoom:MIN(zoom, max)];
    }
}


- (void)publisherOnClickedFocus:(CGPoint)focusPoint {
    
    if (self.livePusher) {
        [self.livePusher focusCameraAtAdjustedPoint:focusPoint autoFocus:self.isAutoFocus];
    }
}

- (void)publisherSliderBeautyWhiteValueChanged:(int)value {
    
    if (self.livePusher) {
        [self.livePusher setBeautyWhite:value];
    }
}


- (void)publisherSliderBeautyBuffingValueChanged:(int)value {
 
    if (self.livePusher) {
        [self.livePusher setBeautyBuffing:value];
    }
}

- (void)publisherSliderBeautyCheekPinkValueChanged:(int)value{

    if (self.livePusher) {
        [self.livePusher setBeautyCheekPink:value];
    }
}


- (void)publisherSliderBeautyRubbyValueChanged:(int)value {
    
    if (self.livePusher) {
        [self.livePusher setBeautyRuddy:value];
    }
}

- (void)publisherSliderBeautyThinFaceValueChanged:(int)value{
    
    if (self.livePusher) {
        [self.livePusher setBeautyThinFace:value];
    }
}

- (void)publisherSliderBeautyShortenFaceValueChanged:(int)value{
    
    if (self.livePusher) {
        [self.livePusher setBeautyShortenFace:value];
    }
}

- (void)publisherSliderBeautyBigEyeValueChanged:(int)value{
    
    if (self.livePusher) {
        [self.livePusher setBeautyBigEye:value];
    }
}


- (void)publisherOnBitrateChangedTargetBitrate:(int)targetBitrate {
    
    if (self.livePusher) {
        
        int ret = [self.livePusher setTargetVideoBitrate:targetBitrate];
        if (ret != 0) {
            
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:NSLocalizedString(@"bite_error", nil)
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
        }
    }
}


- (void)publisherOnBitrateChangedMinBitrate:(int)minBitrate {
    
    if (self.livePusher) {
        int ret = [self.livePusher setMinVideoBitrate:minBitrate];
    
        if (ret != 0) {
            [self showAlertViewWithErrorCode:ret
                                    errorStr:nil
                                         tag:0
                                       title:NSLocalizedString(@"dialog_title", nil)
                                     message:NSLocalizedString(@"bite_error", nil)
                                    delegate:nil
                                 cancelTitle:NSLocalizedString(@"ok", nil)
                           otherButtonTitles:nil];
        }
    }
}


- (void)publisherOnClickPushMirrorButton:(BOOL)isPushMirror {
    
    if (self.livePusher) {
        [self.livePusher setPushMirror:isPushMirror?true:false];
    }
}


- (void)publisherOnClickPreviewMirrorButton:(BOOL)isPreviewMorror {
    
    if (self.livePusher) {
        [self.livePusher setPreviewMirror:isPreviewMorror?true:false];
    }
}


- (void)publisherOnClickAutoFocusButton:(BOOL)isAutoFocus {
    
    if (self.livePusher) {
        [self.livePusher setAutoFocus:isAutoFocus?true:false];
        self.isAutoFocus = isAutoFocus;
    }
}


#pragma mark - AlivcMusicViewDelegate

- (void)musicOnClickPlayButton:(BOOL)isPlay musicPath:(NSString *)musicPath {
    
    if (self.livePusher) {
        if (isPlay) {
            [self.livePusher startBGMWithMusicPathAsync:musicPath];
        } else {
            [self.livePusher stopBGMAsync];
        }
    }
}

- (void)musicOnClickPauseButton:(BOOL)isPause {
    
    if (self.livePusher) {
        if (isPause) {
            [self.livePusher pauseBGM];
        } else {
            [self.livePusher resumeBGM];
        }
    }
}


- (void)musicOnClickLoopButton:(BOOL)isLoop {
    
    if (self.livePusher) {
        [self.livePusher setBGMLoop:isLoop?true:false];
    }
}


- (void)musicOnClickDenoiseButton:(BOOL)isDenoiseOpen {
    
    if (self.livePusher) {
        [self.livePusher setAudioDenoise:isDenoiseOpen];
    }
}

- (void)musicOnClickMuteButton:(BOOL)isMute {
    
    if (self.livePusher) {
        [self.livePusher setMute:isMute?true:false];
    }
}

- (void)musicOnClickEarBackButton:(BOOL)isEarBack {
    
    if (self.livePusher) {
        [self.livePusher setBGMEarsBack:isEarBack?true:false];
    }
}

- (void)musicOnSliderAccompanyValueChanged:(int)value {
    
    if (self.livePusher) {
        [self.livePusher setBGMVolume:value];
    }
}

- (void)musicOnSliderVoiceValueChanged:(int)value {
    
    if (self.livePusher) {
        [self.livePusher setCaptureVolume:value];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == kAlivcLivePusherVCAlertTag+11 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+12 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+31 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+32 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+33) {
        
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self publisherOnClickedBackButton];
        }
    }
    
    if (alertView.tag == kAlivcLivePusherVCAlertTag+22 ||
        alertView.tag == kAlivcLivePusherVCAlertTag+23) {
        
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self reconnectPush];
        } else {
            [self publisherOnClickedBackButton];
        }
    }
}


#pragma - UI
- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview: self.previewView];
    [self.view addSubview: self.publisherView];
}


- (void)showPusherInitErrorAlert:(int)error {
    
    [self showAlertViewWithErrorCode:error
                            errorStr:nil
                                 tag:kAlivcLivePusherVCAlertTag+31
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:@"Init AlivcLivePusher Error"
                            delegate:self
                         cancelTitle:NSLocalizedString(@"exit", nil)
                   otherButtonTitles:nil];
}

- (void)showPusherStartPreviewErrorAlert:(int)error isStart:(BOOL)isStart {
    
    NSString *message = @"Stop Preview Error";
    NSInteger tag = 0;
    if (isStart) {
        message = @"Start Preview Error";
        tag = kAlivcLivePusherVCAlertTag+32;
    }
    
    [self showAlertViewWithErrorCode:error
                            errorStr:nil
                                 tag:tag
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:message
                            delegate:self
                         cancelTitle:NSLocalizedString(@"ok", nil)
                   otherButtonTitles:nil];
}


- (void)showPusherStartPushErrorAlert:(int)error isStart:(BOOL)isStart {
    
    NSString *message = @"Stop Push Error";
    if (isStart) {
        message = @"Start Push Error";
    }

    [self showAlertViewWithErrorCode:error
                            errorStr:nil
                                 tag:0
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:message
                            delegate:nil
                         cancelTitle:NSLocalizedString(@"ok", nil)
                   otherButtonTitles:nil];
}


- (void)showPusherPausePushErrorAlert:(int)error isPause:(BOOL)isPause {
    
    NSString *message = @"Pause Error";
    if (isPause) {
        message = @"Resume Error";
    }
    
    [self showAlertViewWithErrorCode:error
                            errorStr:nil
                                 tag:0
                               title:NSLocalizedString(@"dialog_title", nil)
                             message:message
                            delegate:nil
                         cancelTitle:NSLocalizedString(@"ok", nil)
                   otherButtonTitles:nil];
}


- (void)setupDefaultValues {
    
    self.isAutoFocus = self.pushConfig.autoFocus;
}

- (void)showAlertViewWithErrorCode:(NSInteger)errorCode errorStr:(NSString *)errorStr tag:(NSInteger)tag title:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelTitle:(NSString *)cancel otherButtonTitles:(NSString *)otherTitles, ... {
    
    if (errorCode == ALIVC_LIVE_PUSHER_PARAM_ERROR) {
        errorStr = @"接口输入参数错误";
    }
    
    if (errorCode == ALIVC_LIVE_PUSHER_SEQUENCE_ERROR) {
        errorStr = @"接口调用顺序错误";
    }
    
    NSString *showMessage = [NSString stringWithFormat:@"%@: code:%lx message:%@", message, errorCode, errorStr];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:showMessage delegate:delegate cancelButtonTitle:cancel otherButtonTitles: otherTitles,nil];
        if (tag) {
            alert.tag = tag;
        }
        [alert show];
    });
}


#pragma mark - Timer

- (void)setupDebugTimer {
    
    self.noticeTimer = [NSTimer scheduledTimerWithTimeInterval:kAlivcLivePusherNoticeTimerInterval target:self selector:@selector(noticeTimerAction:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.noticeTimer forMode:NSDefaultRunLoopMode];
}

- (void)cancelTimer{
    
    if (self.noticeTimer) {
        [self.noticeTimer invalidate];
        self.noticeTimer = nil;
    }
}


- (void)noticeTimerAction:(NSTimer *)sender {
    
    if (!self.livePusher) {
        return;
    }

    BOOL isPushing = [self.livePusher isPushing];
    NSString *text = @"";
    if (isPushing) {
        text = [NSString stringWithFormat:@"%@:%@|%@:%@",NSLocalizedString(@"ispushing_log", nil), isPushing?@"YES":@"NO", NSLocalizedString(@"push_url_log", nil), [self.livePusher getPushURL]];
    } else {
        text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"ispushing_log", nil), isPushing?@"YES":@"NO"];
    }

    [self.publisherView updateInfoText:text];
}


#pragma mark - 懒加载

- (AlivcPublisherView *)publisherView {
    if (!_publisherView) {
        _publisherView = [[AlivcPublisherView alloc] initWithFrame:[self getFullScreenFrame]
                                                            config:self.pushConfig type:self.viewType];
        [_publisherView setPushViewsDelegate:self];
        _publisherView.backgroundColor = [UIColor clearColor];
    }
    return _publisherView;
}

- (UIView *)previewView {
    
    if (!_previewView) {
        _previewView = [[UIView alloc] init];
        _previewView.backgroundColor = [UIColor clearColor];
        _previewView.frame = [self getFullScreenFrame];
    }
    return _previewView;
}


- (CGRect)getFullScreenFrame {
    
    CGRect frame = self.view.bounds;
    if (kIsIphoneX) {
        // iPhone X UI适配
        frame = CGRectMake(0, 88, KScreenWidth, KScreenHeight-88-57);
    }
    if (self.pushConfig.orientation != AlivcLivePushOrientationPortrait) {
        CGFloat temSize = frame.size.height;
        frame.size.height = frame.size.width;
        frame.size.width = temSize;
        
        CGFloat temPoint = frame.origin.y;
        frame.origin.y = frame.origin.x;
        frame.origin.x = temPoint;

    }
    return frame;
}

//获取推流地址
- (void)getPushAddress{
    [_liveLogic requestPushAddressWithSuccess:^(id response) {
        RLog(@"推流地址==%@",response);
//        self.pushURL = response[@"pd"][@"PUSHADDRESS"];
    }];
    
}

@end
