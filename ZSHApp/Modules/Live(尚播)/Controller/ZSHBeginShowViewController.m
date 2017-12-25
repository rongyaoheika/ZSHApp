//
//  ZSHBeginShowViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBeginShowViewController.h"
#import "ZegoAVKitManager.h"
#import "ZegoSettings.h"
#import "XXTextView.h"

@interface ZSHBeginShowViewController ()<ZegoDeviceEventDelegate>

@property (nonatomic, strong)  UIView         *preView;
@property (nonatomic, strong)  XXTextView     *textView;
@property (nonatomic, strong)  UIButton       *beginShowBtn;

@property (nonatomic, strong)  UIButton       *cameraBtn;
@property (nonatomic, assign)  BOOL           headCamera;  //摄像头向前

@property (nonatomic, strong)  UIImageView    *videoView;
@property (nonatomic, strong)  NSTimer        *previewTimer;

@end

@implementation ZSHBeginShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData {
    _headCamera = YES;
}

- (void)createUI {
    self.isHidenNaviBar = true;
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeBtn addTarget:self action:@selector(closeBeginShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(22));
        make.left.mas_equalTo(self.view).offset(kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(44));
    }];
    
    
    _cameraBtn = [[UIButton alloc]init];
    [_cameraBtn setImage:[UIImage imageNamed:@"record_image_1"] forState:UIControlStateNormal];
    [_cameraBtn addTarget:self action:@selector(refresAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(44));
    }];
    
    UIButton *locationBtn = [[UIButton alloc]init];
    [locationBtn setImage:[UIImage imageNamed:@"begin_show_00"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(42.5));
        make.width.and.height.mas_equalTo(kRealValue(44));
    }];

    // 标题
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kRealValue(30));
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(kRealValue(-75));
        make.height.mas_equalTo(kRealValue(40));
    }];
    
    for (int i = 0; i < 5; i++) {
        
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.clipsToBounds = YES;
        [typeBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"begin_show_normal_%d",i+1]] forState:UIControlStateNormal];
        [typeBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"begin_show_pressed_%d",i+1]] forState:UIControlStateSelected];
        [typeBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:typeBtn];
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(kRealValue(83.5+i%5*(24.5+22)));
            make.bottom.mas_equalTo(self.view).offset(kRealValue(-173.5+i/5*(13+22)));
            make.size.mas_equalTo(CGSizeMake(kRealValue(22), kRealValue(22)));
        }];
    }
    
    UIImageView *beautyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"begin_show_0"]];
    [self.view addSubview:beautyImageView];
    [beautyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kRealValue(83.5));
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-105));
        make.size.mas_equalTo(CGSizeMake(kRealValue(18.5), kRealValue(22)));
    }];
    
    UILabel *beautyLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"美颜",@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)}];
    [self.view addSubview:beautyLabel];
    [beautyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kRealValue(83.5));
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-83.5));
        make.size.mas_equalTo(CGSizeMake(kRealValue(29.5), kRealValue(15)));
    }];
    
    _beginShowBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"开启直播",@"titleColor":KWhiteColor,@"font":kPingFangLight(17),@"backgroundColor":KZSHColorFF2068}];
    _beginShowBtn.layer.cornerRadius = 20;
    [_beginShowBtn addTarget:self action:@selector(beginShowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_beginShowBtn];
    [_beginShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-83.5));
        make.centerX.mas_equalTo(self.view).offset(kRealValue(17));
        make.size.mas_equalTo(CGSizeMake(kRealValue(166), kRealValue(36)));
    }];
    
    
    UILabel *noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"开启直播即代表同意《尚播用户协议》",@"font":kPingFangRegular(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)}];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-50));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(200), kRealValue(12)));
    }];
    
    [self addPreview];
    [[ZegoAVKitManager api] setDeviceEventDelegate:self];
}

- (XXTextView *)textView {
    if (!_textView) {
        _textView  = [[XXTextView alloc] initWithFrame:CGRectMake(15, 9.5, KScreenWidth-80, 30)];
        _textView.backgroundColor = KZSHColor181818;
        _textView.textColor = KZSHColor929292;
        _textView.font = kPingFangRegular(20);
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
        _textView.xx_placeholder = @"给直播写个标题吧！";
        _textView.xx_placeholderFont = kPingFangRegular(20);
        _textView.xx_placeholderColor = KZSHColor929292;
        _textView.layer.cornerRadius = 15;
        _textView.layer.masksToBounds = true;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = KZSHColor929292.CGColor;
    }
    return _textView;
}

- (void)addPreview
{
    _preView = [[UIView alloc] init];
    _preView.backgroundColor = [UIColor redColor];
    _preView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_preView];
    [self.view sendSubviewToBack:_preView];
    [self.preView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Event
- (void)locationAction {
    
}

- (void)closeBeginShow {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)beginShowAction {
    RLog(@"开始直播");
}

//
- (void)refresAction {//切换摄像头方向
    _headCamera = !_headCamera;
    
    [self.textView resignFirstResponder];
    [[ZegoAVKitManager api] setFrontCam:_headCamera];
}


- (void)startPreview
{
    ZegoAVConfig *config = [ZegoSettings sharedInstance].currentConfig;
    
    CGFloat height = config.videoEncodeResolution.height;
    CGFloat width = config.videoEncodeResolution.width;
    
    // 如果开播前横屏，则切换视频采集分辨率的宽高
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
    {
        // * adjust width/height for landscape
        config.videoEncodeResolution = CGSizeMake(MAX(height, width), MIN(height, width));
    }
    else
    {
        config.videoEncodeResolution = CGSizeMake(MIN(height, width), MAX(height, width));
    }
    
    config.videoCaptureResolution = config.videoEncodeResolution;
    
    int ret = [[ZegoAVKitManager api] setAVConfig:config];
    assert(ret);
    
    bool b = [[ZegoAVKitManager api] setFrontCam:YES];
    assert(b);
    
    b = [[ZegoAVKitManager api] enableMic:YES];
    assert(b);
    
    b = [[ZegoAVKitManager api] enableTorch:NO];
    assert(b);
    
    b = [[ZegoAVKitManager api] enableBeautifying:2];
    assert(b);
    
    
    [[ZegoAVKitManager api] setPolishFactor:4.0];
    [[ZegoAVKitManager api] setPolishStep:4.0];
    [[ZegoAVKitManager api] setWhitenFactor:0.6];
    
    
    b = [[ZegoAVKitManager api] setFilter:1];
    assert(b);
    
    [[ZegoAVKitManager api] setPreviewViewMode:ZegoVideoViewModeScaleAspectFill];
    
    {
        [[ZegoAVKitManager api] setWaterMarkImagePath:@"asset:watermark"];
        
        [[ZegoAVKitManager api] setPreviewWaterMarkRect:CGRectMake(10, 40, 100, 100)];
        [[ZegoAVKitManager api] setPublishWaterMarkRect:CGRectMake(10, 40, 50, 50)];
    }
    
    [[ZegoAVKitManager api] setPreviewView:self.preView];
    [[ZegoAVKitManager api] setDeviceEventDelegate:self];
    [[ZegoAVKitManager api] startPreview];
    
    if ([ZegoAVKitManager recordTime])
    {
        [[ZegoAVKitManager api] enablePreviewMirror:false];
    }
    
    if ([ZegoAVKitManager usingExternalCapture])
    {
        [self addExternalCaptureView];
    }
}

- (void)addExternalCaptureView
{
    if (self.videoView)
    {
        [self.videoView removeFromSuperview];
        self.videoView = nil;
    }
    
    if (self.previewTimer)
    {
        [self.previewTimer invalidate];
        self.previewTimer = nil;
    }
    
    _videoView = [[UIImageView alloc] init];
    self.videoView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.preView addSubview:self.videoView];
    self.videoView.frame = self.preView.bounds;
    
    //timer
    self.previewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60 target:self selector:@selector(handlePreview) userInfo:nil repeats:YES];
}

- (void)removeExternalCaptureView
{
    [self.previewTimer invalidate];
    self.previewTimer = nil;
    
    if (self.videoView)
    {
        [self.videoView removeFromSuperview];
        self.videoView = nil;
        [self.preView setNeedsLayout];
    }
}

- (void)handlePreview
{
    
}


- (void)stopPreview
{
    if ([ZegoAVKitManager usingExternalCapture]){
        [self removeExternalCaptureView];
    }
    
    [[ZegoAVKitManager api] setPreviewView:nil];
    [[ZegoAVKitManager api] stopPreview];
}

//权限
- (void)showAuthorizationAlert:(NSString *)message title:(NSString *)title
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"设置权限", nil), nil];
        [alertView show];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.beginShowBtn.enabled = NO;
        }];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"设置权限", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openSetting];
        }];
        
        [alertController addAction:settingAction];
        [alertController addAction:cancelAction];
        
        alertController.preferredAction = settingAction;
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        self.beginShowBtn.enabled = NO;
    else
        [self openSetting];
}

- (void)openSetting
{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingURL])
        [[UIApplication sharedApplication] openURL:settingURL];
}

//检查相机权限
- (BOOL)checkVideoAuthorization
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoAuthStatus == AVAuthorizationStatusDenied || videoAuthStatus == AVAuthorizationStatusRestricted){
        return NO;
    }
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted == NO)
                self.beginShowBtn.enabled = NO;
        }];
    }
    return YES;
}

- (BOOL)checkAudioAuthorization
{
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioAuthStatus == AVAuthorizationStatusDenied || audioAuthStatus == AVAuthorizationStatusRestricted){
        return NO;
    }
    if (audioAuthStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted == NO)
                self.beginShowBtn.enabled = NO;
        }];
    }
    
    return YES;
}

#pragma mark - ZegoDeviceEventDelegate

- (void)zego_onDevice:(NSString *)deviceName error:(int)errorCode
{
    NSLog(@"device name: %@, error code: %d", deviceName, errorCode);
}

- (void)thirdLogin:(UIButton *)btn{
    RLog(@"点击第三方");
    btn.selected = !btn.selected;
}

- (void)onTapView:(UIGestureRecognizer *)recognizer
{
    [self.textView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationDeactive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    if (self.preView == nil){
        [self addPreview];
    }
    
    BOOL videoAuthorization = [self checkVideoAuthorization];
    BOOL audioAuthorization = [self checkAudioAuthorization];
    [self startPreview];
    
//    if (videoAuthorization == YES)
//    {
//        [self startPreview];
//        [[ZegoAVKitManager api] setAppOrientation:[UIApplication sharedApplication].statusBarOrientation];
//
//        if (audioAuthorization == NO)
//        {
//            [self showAuthorizationAlert:NSLocalizedString(@"直播视频,访问麦克风", nil) title:NSLocalizedString(@"需要访问麦克风", nil)];
//        }
//    }
//    else
//    {
//        [self showAuthorizationAlert:NSLocalizedString(@"直播视频,访问相机", nil) title:NSLocalizedString(@"需要访问相机", nil)];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.preView){
        [self stopPreview];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)onApplicationActive:(NSNotification *)notification
{
    if (self.preView != nil)
    {
        [self stopPreview];
        [self startPreview];
    }
}


- (void)onApplicationDeactive:(NSNotification *)notification
{
        [self stopPreview];
}


@end
