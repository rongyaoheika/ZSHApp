//
//  AlivcPublisherView.m
//  AlivcLiveCaptureDev
//
//  Created by TripleL on 17/7/10.
//  Copyright © 2017年 Alivc. All rights reserved.
//

#import "AlivcPublisherView.h"
#import "AlivcDebugChartView.h"
#import "AlivcDebugTextView.h"
#import "AlivcGuidePageView.h"
#import "AlivcMusicSettingView.h"
#import "AlivcPushViewsProtocol.h"
#import <AlivcLivePusher/AlivcLivePusherHeader.h>

#import "XXTextView.h"
#import "ZSHBottomBlurPopView.h"
#import "ZSHLiveMoreView.h"
#import "ZSHBeautyView.h"
#import "ZSHLiveLogic.h"
//定位服务
#import "ZSHBaseFunction.h"
#import "HCLocationManager.h"
#import "GYZCity.h"
#import "ZSHFinishShowViewController.h"

#define viewWidth kRealValue(58)
#define viewHeight viewWidth/4*3
#define topViewButtonSize kRealValue(35)

@interface AlivcPublisherView () <UIGestureRecognizerDelegate,HCLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) id<AlivcPublisherViewDelegate> delegate;

@property (nonatomic, strong) AlivcGuidePageView *guideView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *musicButton;
@property (nonatomic, strong) UIButton *beautySettingButton;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *moreSettingButton;

@property (nonatomic, strong) UISwitch *previewMirrorSwitch;
@property (nonatomic, strong) UISwitch *pushMirrorSwitch;

@property (nonatomic, strong) UIView *beautySettingView;
@property (nonatomic, strong) UIView *moreSettingView;
@property (nonatomic, strong) AlivcMusicSettingView *musicSettingView;

@property (nonatomic, strong) AlivcDebugChartView *debugChartView;
@property (nonatomic, strong) AlivcDebugTextView *debugTextView;

@property (nonatomic, assign) BOOL isBeautySettingShow;
@property (nonatomic, assign) BOOL isMoreSettingShow;
@property (nonatomic, assign) BOOL isMusicSettingShow;
@property (nonatomic, assign) BOOL isKeyboardEdit;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) AlivcLivePushConfig *config;

//自定义界面
@property (nonatomic, strong)  UIButton                 *locateBtn;
@property (nonatomic, strong)  XXTextView               *textView;
@property (nonatomic, strong)  UIButton                 *beginShowBtn;
@property (nonatomic, strong)  UIButton                 *beautyBtn;
@property (nonatomic, strong)  NSMutableArray           *shareBtnArr;
@property (nonatomic, strong)  ZSHBottomBlurPopView     *bottomBlurPopView;
@property (nonatomic, strong)  ZSHLiveLogic             *liveLogic;
@property (nonatomic, strong)  NSString                 *pushURL;
@property (nonatomic, copy)    NSString                 *cityName;
@property (nonatomic, assign)  BOOL                     isMoreViewShow;

//更多功能
@property (nonatomic, strong)  ZSHLiveMoreView          *moreView;
@property (nonatomic, assign)  BOOL                     isLocate;

//美颜设置功能
@property (nonatomic, strong)  ZSHBeautyView            *beautyView;
@property (nonatomic, assign)  BOOL                     isBeautyViewShow;

//类型
@property (nonatomic, assign)  AlivcPublisherViewType   type;

//直播互动
@property (nonatomic, strong) UITableView               *subTab;
@property (nonatomic, strong) ZSHBaseTableViewModel     *tableViewModel;

@end


static NSString *ZSHBaseCellID = @"ZSHBaseCell";
@implementation AlivcPublisherView


- (instancetype)initWithFrame:(CGRect)frame config:(AlivcLivePushConfig *)config type:(AlivcPublisherViewType)type{
    
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _config = config;
        [self setupSubviews];
        [self addNotifications];
    }
    return self;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setPushViewsDelegate:(id)delegate {
    
    self.delegate = delegate;
    [self.musicSettingView setMusicDelegate:delegate];
    [self.beautyView setBeautyDelegate:delegate];

}

#pragma mark - UI

- (void)setupSubviews {
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:AlivcUs                                                                                                                                                                                                                                                                                                                                                                                                                                    erDefaultsIndentifierFirst]) {
//        [self setupGuideView];
//    }
    
    switch (self.type) {
        case AlivcPublisherViewTypeLive:{//主播直播
            [self setupLiveTopViews];
            [self setupLiveChatTabView];
            [self setupLiveBottomViews];
            [self setupInfoLabel];
            if (self.config.audioOnly) {
                [self hiddenVideoViews];
            }
            
            self.currentIndex = 1;
            [self addGesture];
            //    [self setupDebugViews];
            break;
        }
        case AlivcPublisherViewTypePreview:{//预览
           
            [self setupPreviewTopViews];
            [self setupCustomUI];
            [self addGesture];
            [self locateAction:nil];
            break;
        }
        
            
        default:
            break;
    }

}


- (void)setupGuideView {
    
    self.guideView = [[AlivcGuidePageView alloc] initWithFrame:CGRectMake(20, 0, self.bounds.size.width - 40, self.bounds.size.height/6)];
    self.guideView.center = self.center;
    [self addSubview:self.guideView];
}


- (void)setupPreviewTopViews {
    
    self.topView = [[UIView alloc] init];
    self.topView.frame = CGRectMake(0, 20, CGRectGetWidth(self.frame), viewHeight);
    [self addSubview: self.topView];
    
    CGFloat retractX = 5;
    
    self.backButton = [self setupButtonWithFrame:(CGRectMake(retractX, 0, topViewButtonSize, topViewButtonSize))
                                     normalImage:[UIImage imageNamed:@"live_close"] //back
                                     selectImage:nil
                                          action:@selector(backButtonAction:)];
    [self.topView addSubview: self.backButton];
    
    self.switchButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetWidth(self.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                       normalImage:[UIImage imageNamed:@"camera_id"] //record_image_1
                                       selectImage:nil
                                            action:@selector(switchButtonAction:)];
    [self.topView addSubview:self.switchButton];
    
    /*self.flashButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.switchButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                                   normalImage:[UIImage imageNamed:@"camera_flash_close"]
                                                   selectImage:[UIImage imageNamed:@"camera_flash_on"]
                                                   action:@selector(flashButtonAction:)];
    [self.topView addSubview:self.flashButton];
    [self.flashButton setSelected:self.config.flash];
    [self.flashButton setEnabled:self.config.cameraType==AlivcLivePushCameraTypeFront?NO:YES];
    
    self.musicButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.flashButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                     normalImage:[UIImage imageNamed:@"begin_show_00"] //music_button
                                     selectImage:nil
                                          action:@selector(musicButtonAction:)];
    [self.topView addSubview: self.musicButton];
    
    if (self.config.videoOnly) {
        [self.musicButton setHidden:YES];
    }
    
    self.beautySettingButton = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.musicButton.frame) - retractX - topViewButtonSize, 0, topViewButtonSize, topViewButtonSize))
                                              normalImage:[UIImage imageNamed:@"record_beauty_on"]
                                              selectImage:nil
                                                   action:@selector(beautySettingButtonAction:)];
    [self.topView addSubview: self.beautySettingButton];*/
    
    
   
    [self.topView addSubview:self.locateBtn];
    
    //[self setupMusicSettingView];
    self.isBeautySettingShow = NO;
    self.isMusicSettingShow = NO;
    self.isLocate = NO;
}

- (void)setupLiveTopViews{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, kRealValue(60))];
    [self addSubview: self.topView];
    
    UIImageView *anchorHeadImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_room_head1"]];
    anchorHeadImageView.layer.cornerRadius = kRealValue(35)/2;
    [self.topView addSubview:anchorHeadImageView];
    [anchorHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView).offset(kRealValue(18));
        make.centerY.mas_equalTo(self.topView);
        make.width.and.height.mas_equalTo(kRealValue(35));
    }];
    
    NSDictionary *nameLabelDic = @{@"text":@"B-Bro",@"font":kPingFangRegular(12),@"textColor":KWhiteColor};
    UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [self.topView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(anchorHeadImageView.mas_right).offset(kRealValue(8));
        make.top.mas_equalTo(anchorHeadImageView);
        make.width.mas_equalTo(KScreenWidth*0.3);
        make.height.mas_equalTo(kRealValue(20));
    }];
    
    NSDictionary *numLabelDic = @{@"text":@"283075",@"font":kGeorgia(8),@"textColor":KWhiteColor};
    UILabel *numLabel = [ZSHBaseUIControl createLabelWithParamDic:numLabelDic];
    [self.topView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.width.mas_equalTo(nameLabel);
        make.height.mas_equalTo(kRealValue(18));
    }];
    
    
    // 头像点击Button
    UIButton *personBtn = [[UIButton alloc]init];
    [personBtn addTarget:self action:@selector(personInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:personBtn];
    [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView).offset(kRealValue(18));
        make.centerY.mas_equalTo(self.topView);
        make.width.mas_equalTo(kRealValue(75));
        make.height.mas_equalTo(kRealValue(35));
    }];
    
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView).offset(-kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(13.7));
        make.centerY.mas_equalTo(self.topView);
    }];
    
    NSArray *audienceImageArr = @[@"live_room_head5",@"live_room_head4",@"live_room_head3",@"live_room_head2"];
    CGFloat spacing = (KScreenWidth*0.6 - (audienceImageArr.count+1)*kRealValue(35))/(audienceImageArr.count-1);
    for (int i = 0; i < audienceImageArr.count; i++) {
        UIImageView *headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:audienceImageArr[i]]];
        headImageView.layer.cornerRadius = kRealValue(35)/2;
        [self.topView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(closeBtn.mas_left).offset(- (kRealValue(20) + i*(spacing+kRealValue(35))));
            make.centerY.mas_equalTo(self.topView);
            make.width.and.height.mas_equalTo(kRealValue(35));
        }];
    }
   
}

- (void)setupLiveChatTabView{
    self.tableViewModel = [[ZSHBaseTableViewModel alloc] init];
    self.subTab = [ZSHBaseUIControl createTableView];
    self.subTab.backgroundColor = KClearColor;
    [self addSubview: self.subTab];
    self.subTab.delegate = self.tableViewModel;
    self.subTab.dataSource = self.tableViewModel;
    [self.subTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealValue(150));
        make.bottom.mas_equalTo(self).offset(-(kRealValue(49)+ kRealValue(18)));
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    [self.subTab registerClass:[ZSHBaseCell class] forCellReuseIdentifier:ZSHBaseCellID];
    [self initViewModel];
}

- (void)initViewModel {
    [self.tableViewModel.sectionModelArray removeAllObjects];
    [self.tableViewModel.sectionModelArray addObject:[self storeListSection]];
    [self.subTab reloadData];
}

//list
- (ZSHBaseTableViewSectionModel*)storeListSection {
    ZSHBaseTableViewSectionModel *sectionModel = [[ZSHBaseTableViewSectionModel alloc] init];
    for (int i = 0; i < 3; i++) {
        ZSHBaseTableViewCellModel *cellModel = [[ZSHBaseTableViewCellModel alloc] init];
        cellModel.height = kRealValue(44);
        [sectionModel.cellModelArray addObject:cellModel];
        cellModel.renderBlock = ^UITableViewCell *(NSIndexPath *indexPath, UITableView *tableView) {
            ZSHBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ZSHBaseCellID forIndexPath:indexPath];
            cell.textLabel.text = @"李志：三月的艳遇飘摇的南方";
            cell.textLabel.textColor = KWhiteColor;
            return cell;
        };
        
        cellModel.selectionBlock = ^(NSIndexPath *indexPath, UITableView *tableView) {
            
        };
    }
    
    return sectionModel;
}

- (void)setupLiveBottomViews{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(self.frame) -KBottomTabH , CGRectGetWidth(self.frame), KBottomNavH)];
    [self addSubview: self.bottomView];
    
    UIImage *chatImage = [UIImage imageNamed:@"live_room_chat"];
    UIButton *chatBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [chatBtn addTarget:self action:@selector(chatBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:chatBtn];
    [chatBtn setBackgroundImage:chatImage forState:UIControlStateNormal];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView).offset(KLeftMargin);
        make.centerY.mas_equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(kRealValue(32), kRealValue(32)));
    }];
    
//    NSArray *imageArr = @[@"live_room_gift",@"live_room_love",@"live_room_share"];
    NSArray *imageArr = @[@"room_more",@"live_room_share"];
    for (int i = 0; i<imageArr.count; i++) {
        UIImage *btnImage = [UIImage imageNamed:imageArr[i]];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        btn.tag = 11179+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:btn];
        [btn setImage:btnImage forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bottomView).offset(-(15 + i*(btnImage.size.width + kRealValue(10))));
            make.centerY.mas_equalTo(self.bottomView);
            make.width.mas_equalTo(btnImage.size.width);
            make.height.mas_equalTo(btnImage.size.height);
        }];
    }
}


- (void)setupPreviewBottomViews {
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.frame) - viewHeight,
                                       CGRectGetWidth(self.frame),
                                       viewHeight);
    [self addSubview: self.bottomView];
    
    CGFloat buttonCount = 5;
    CGFloat retractX = (CGRectGetWidth(self.bottomView.frame) - viewWidth * 5) / (buttonCount + 1);
    
    self.previewButton = [self setupButtonWithFrame:(CGRectMake(retractX, 0, viewWidth, viewHeight))
                                        normalTitle:NSLocalizedString(@"start_preview_button", nil)
                                        selectTitle:NSLocalizedString(@"stop_preview_button", nil)
                                             action:@selector(previewButtonAction:)];
    [self.bottomView addSubview: self.previewButton];
    [self.previewButton setSelected:YES];
    
    self.pushButton = [self setupButtonWithFrame:(CGRectMake(retractX * 2 + viewWidth, 0, viewWidth, viewHeight))
                                     normalTitle:NSLocalizedString(@"start_button", nil)
                                     selectTitle:NSLocalizedString(@"stop_button", nil)
                                          action:@selector(pushButtonAction:)];
    [self.bottomView addSubview: self.pushButton];
    
    self.pauseButton = [self setupButtonWithFrame:(CGRectMake(retractX * 3 + viewWidth * 2, 0, viewWidth, viewHeight))
                                      normalTitle:NSLocalizedString(@"pause_button", nil)
                                      selectTitle:NSLocalizedString(@"resume_button", nil)
                                           action:@selector(pauseButtonAction:)];
    [self.bottomView addSubview:self.pauseButton];
    
    self.restartButton = [self setupButtonWithFrame:(CGRectMake(retractX * 4 + viewWidth * 3, 0, viewWidth, viewHeight))
                                      normalTitle:NSLocalizedString(@"repush_button", nil)
                                      selectTitle:nil
                                           action:@selector(restartButtonAction:)];
    [self.bottomView addSubview:self.restartButton];

    
    self.moreSettingButton = [self setupButtonWithFrame:(CGRectMake(retractX * 5 + viewWidth * 4, 0, viewWidth, viewHeight))
                                              normalTitle:NSLocalizedString(@"more_setting_button", nil)
                                              selectTitle:nil
                                                   action:@selector(moreSettingButtonAction:)];
    [self.bottomView addSubview: self.moreSettingButton];
    
    self.isMoreSettingShow = NO;
    
}


- (void)setupInfoLabel {
    
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.frame = CGRectMake(20, 100, self.bounds.size.width - 40, 40);
    self.infoLabel.textColor = [UIColor blackColor];
    self.infoLabel.backgroundColor = KZSHColorRGBA(255, 255, 255, 0.5);
    self.infoLabel.font = [UIFont systemFontOfSize:14.f];
    self.infoLabel.layer.masksToBounds = YES;
    self.infoLabel.layer.cornerRadius = 10;
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.infoLabel];
    self.infoLabel.hidden = YES;
}


- (void)setupBeautySettingViews {
    
    CGFloat retractX = 7;
    
    CGFloat sliderCount = 7;
    
    CGFloat height = viewHeight;
    if (self.bounds.size.width > self.bounds.size.height) {
        height = 18.0/375*self.bounds.size.width;
    }
    
    self.beautySettingView = [[UIView alloc] init];
//    self.beautySettingView.frame = CGRectMake(retractX,
//                                              CGRectGetMinY(self.bottomView.frame) - height * sliderCount,
//                                              CGRectGetWidth(self.frame) - retractX * 2,
//                                              height * sliderCount);
    self.beautySettingView.frame = CGRectMake(retractX,
                                              KScreenHeight - height * sliderCount - kRealValue(30),
                                              CGRectGetWidth(self.frame) - retractX * 2,
                                              height * sliderCount + kRealValue(30));
    
    self.beautySettingView.backgroundColor = KZSHColorRGBA(1, 1, 1, 0.3);
    self.beautySettingView.layer.masksToBounds = YES;
    self.beautySettingView.layer.cornerRadius = 10;
    
    UIButton *beautyButton = [self setupButtonWithFrame:(CGRectMake(0, 0, viewWidth, height))
                                       normalTitle:NSLocalizedString(@"beauty_on", nil)
                                       selectTitle:NSLocalizedString(@"beauty_off", nil)
                                            action:@selector(beautyButtonAction:)];
    beautyButton.center = CGPointMake(retractX + viewWidth / 2, CGRectGetHeight(self.beautySettingView.frame) / 2);
    [beautyButton setSelected:YES];
    [self.beautySettingView addSubview:beautyButton];
    [beautyButton setSelected:self.config.beautyOn];
    
    
    CGFloat labelX = CGRectGetMaxX(beautyButton.frame) + retractX;
    CGFloat labelWidth = viewWidth / 2 + 20;
    CGFloat sliderX = CGRectGetMaxX(beautyButton.frame) + labelWidth + retractX * 2;
    CGFloat sliderWidth = CGRectGetWidth(self.beautySettingView.frame) - sliderX - retractX;
    CGFloat adjustHeight = (CGRectGetHeight(self.beautySettingView.frame) - retractX * (sliderCount - 1)) / sliderCount                                                                                                                                                                               ;
    
    
    NSArray *labelNameArray = @[NSLocalizedString(@"beauty_skin_smooth", nil),NSLocalizedString(@"beauty_white", nil),NSLocalizedString(@"beauty_ruddy", nil),NSLocalizedString(@"beauty_cheekpink", nil),NSLocalizedString(@"beauty_thinface", nil),NSLocalizedString(@"beauty_shortenface", nil),NSLocalizedString(@"beauty_bigeye", nil)];
    NSArray *sliderActionArray = @[@"buffingValueChange:",@"whiteValueChange:", @"ruddyValueChange:",@"cheekPinkValueChange:",@"thinfaceValueChange:",@"shortenfaceValueChange:",@"bigeyeValueChange:"];
    NSArray *beautyDefaultValueArray = @[@(self.config.beautyBuffing),@(self.config.beautyWhite),@(self.config.beautyRuddy),@(self.config.beautyCheekPink),@(self.config.beautyThinFace),@(self.config.beautyShortenFace),@(self.config.beautyBigEye)];

    
    for (int index = 0; index < sliderCount; index++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(labelX, retractX * (index + 1) + adjustHeight * index, labelWidth, adjustHeight);
        label.font = [UIFont systemFontOfSize:14.f];
        label.text = labelNameArray[index];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        [self.beautySettingView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(sliderX, retractX * (index + 1) + adjustHeight * index, sliderWidth, adjustHeight);
        [slider addTarget:self action:NSSelectorFromString(sliderActionArray[index]) forControlEvents:(UIControlEventValueChanged)];
        slider.maximumValue = 100;
        slider.minimumValue = 0;
        slider.value = [beautyDefaultValueArray[index] intValue];
        [self.beautySettingView addSubview:slider];
    }
}


- (void)setupMoreSettingViews {
    
    self.moreSettingView = [[UIView alloc] init];
    
    CGFloat retractX = 5;
    
    CGFloat height = viewHeight;
    if (self.bounds.size.width > self.bounds.size.height) {
        height = 45;
    }

    
    self.moreSettingView.frame = CGRectMake(retractX,
                                              CGRectGetHeight(self.frame) - height * 4,
                                              CGRectGetWidth(self.frame) - retractX * 2,
                                              height * 4);
    self.moreSettingView.backgroundColor = [UIColor grayColor];
    self.moreSettingView.layer.masksToBounds = YES;
    self.moreSettingView.layer.cornerRadius = 10;

    
    CGFloat buttonY = CGRectGetHeight(self.moreSettingView.frame) - height * 2;
    CGFloat middleX = CGRectGetMidX(self.moreSettingView.frame);
    
    UIButton *sharedButton = [self setupButtonWithFrame:(CGRectMake(retractX, buttonY, viewWidth, height))
                                        normalTitle:NSLocalizedString(@"share_button", nil)
                                        selectTitle:nil
                                             action:@selector(sharedButtonAction:)];
//    [self.moreSettingView addSubview:sharedButton];
    
    self.previewMirrorSwitch = [[UISwitch alloc] init];
    UIView *previewMirrorView = [self setupSwitchViewsWithFrame:(CGRectMake(middleX, buttonY, middleX, height)) title:NSLocalizedString(@"preview_mirror", nil) switchView:self.previewMirrorSwitch switchOn:self.config.previewMirror switchAction:@selector(previewMirrorSwitchAction:)];
    [self.moreSettingView addSubview:previewMirrorView];
    
    self.pushMirrorSwitch = [[UISwitch alloc] init];
    UIView *pushMirrorView = [self setupSwitchViewsWithFrame:(CGRectMake(retractX, buttonY, middleX, height)) title:NSLocalizedString(@"push_mirror", nil) switchView:self.pushMirrorSwitch switchOn:self.config.pushMirror switchAction:@selector(pushMirrorSwitchAction:)];
    [self.moreSettingView addSubview:pushMirrorView];
    
    UISwitch *autoFocusSwitch = [[UISwitch alloc] init];
    UIView *autoFocusView = [self setupSwitchViewsWithFrame:(CGRectMake(retractX, buttonY+height, middleX, height)) title:NSLocalizedString(@"auto_focus", nil) switchView:autoFocusSwitch switchOn:self.config.autoFocus switchAction:@selector(autoFocusSwitchAction:)];
    [self.moreSettingView addSubview:autoFocusView];

    
    int labelCount = 2;
    CGFloat retract = 5;
    CGFloat labelWidth = 30;
    NSArray *nameArray = @[NSLocalizedString(@"target_bitrate", nil),NSLocalizedString(@"min_bitrate", nil)];
    NSArray *textFieldActionArray = @[@"maxBitrateTextFieldValueChanged:", @"minBitrateTextFieldValueChanged:"];
    NSArray *value =@[@(self.config.targetVideoBitrate),@(self.config.minVideoBitrate)];
    
    for (int index = 0; index < labelCount; index++) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(retract,
                                     10 +(retract*(index+1))+(labelWidth*index),
                                     labelWidth * 2,
                                     labelWidth);
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        nameLabel.text = nameArray[index];
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.numberOfLines = 0;
        
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + retract,
                                     CGRectGetMinY(nameLabel.frame),
                                     CGRectGetWidth(self.moreSettingView.frame) - kRealValue(110),
                                     30);
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = [NSString stringWithFormat:@"%@", value[index]];
        textField.text = [NSString stringWithFormat:@"%@", value[index]];
        textField.font = [UIFont systemFontOfSize:14.f];
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.clearsOnBeginEditing = YES;
        [textField addTarget:self action:NSSelectorFromString(textFieldActionArray[index]) forControlEvents:(UIControlEventEditingDidEnd)];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.frame = CGRectMake(CGRectGetMaxX(textField.frame) + retract,
                                     CGRectGetMinY(nameLabel.frame),
                                     labelWidth * 2,
                                     labelWidth);
        unitLabel.textAlignment = NSTextAlignmentLeft;
        unitLabel.font = [UIFont systemFontOfSize:14.f];
        unitLabel.text = @"Kbps";
        
        [self.moreSettingView addSubview:nameLabel];
        [self.moreSettingView addSubview:textField];
        [self.moreSettingView addSubview:unitLabel];
        
        if (self.config.qualityMode != AlivcLivePushQualityModeCustom) {
            // 非自定义模式下，不允许更改码率
            nameLabel.alpha = 0.5;
            [textField setEnabled:NO];
            textField.alpha = 0.5;
            unitLabel.alpha = 0.5;
        }

    }
}


- (void)setupMusicSettingView {
    
    CGRect frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);
    if (self.bounds.size.width > self.bounds.size.height) {
        frame = CGRectMake(0, self.frame.size.height/3, self.frame.size.width, self.frame.size.height/3*2);
    }
    self.musicSettingView = [[AlivcMusicSettingView alloc] initWithFrame:frame];
    [self.musicSettingView setMusicDelegate:(id)self.delegate];
}


- (UIView *)setupSwitchViewsWithFrame:(CGRect)viewFrame title:(NSString *)labelTitle switchView:(UISwitch *)switcher switchOn:(BOOL)switchOn switchAction:(SEL)switchAction{
    
    UIView *view = [[UIView alloc] initWithFrame:viewFrame];
    
    UILabel *viewLabel = [[UILabel alloc] init];
    viewLabel.frame = CGRectMake(0, 0, CGRectGetWidth(viewFrame)/2, CGRectGetHeight(viewFrame));
    viewLabel.text = labelTitle;
    viewLabel.font = [UIFont systemFontOfSize:14.f];
    viewLabel.numberOfLines = 0;
    [viewLabel sizeToFit];
    viewLabel.center = CGPointMake(viewLabel.center.x, viewFrame.size.height/2);

    [view addSubview:viewLabel];
    
    switcher.frame = CGRectMake(CGRectGetMaxX(viewLabel.frame), 0, CGRectGetWidth(viewFrame)/2, CGRectGetHeight(viewFrame));
    switcher.center = CGPointMake(switcher.center.x, viewFrame.size.height/2);
    switcher.on = switchOn;
    [switcher addTarget:self action:switchAction forControlEvents:(UIControlEventValueChanged)];
    [view addSubview:switcher];
    
    return view;
}


- (void)setupDebugViews {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.debugChartView = [[AlivcDebugChartView alloc] initWithFrame:(CGRectMake(width, 0, width, height))];
    self.debugChartView.backgroundColor = KZSHColorRGBA(255, 255, 255, 0.8);
    [self addSubview:self.debugChartView];
    
    
    self.debugTextView = [[AlivcDebugTextView alloc] initWithFrame:(CGRectMake(-width, 0, width, height))];
    self.debugTextView.backgroundColor = KZSHColorRGBA(255, 255, 255, 0.8);
    [self addSubview:self.debugTextView];
}


- (void)addGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate = self;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:pinch];
    [self addGestureRecognizer:tap];
//    [self addGestureRecognizer:leftSwipeGestureRecognizer];
//    [self addGestureRecognizer:rightSwipeGestureRecognizer];
}



- (UIButton *)setupButtonWithFrame:(CGRect)rect normalTitle:(NSString *)normal selectTitle:(NSString *)select action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = rect;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitle:normal forState:(UIControlStateNormal)];
    [button setTitle:select forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button.titleLabel.font = [UIFont systemFontOfSize:13.f];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = rect.size.height / 5;
    return button;
}


- (UIButton *)setupButtonWithFrame:(CGRect)rect normalImage:(UIImage *)normal selectImage:(UIImage *)select action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = rect;
    [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    [button setImage:normal forState:(UIControlStateNormal)];
    [button setImage:select forState:(UIControlStateSelected)];
    return button;
}


#pragma mark - Button Actions

- (void)backButtonAction:(UIButton *)sender {

    if (self.delegate) {
        [self.delegate publisherOnClickedBackButton:self.type];
    }

}


- (void)previewButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    
    if (self.delegate) {
        [self.delegate publisherOnClickedPreviewButton:sender.selected button:sender];
    }
    
    self.pushMirrorSwitch.enabled = sender.selected;
    self.previewMirrorSwitch.enabled = sender.selected;
}


- (void)pushButtonAction:(UIButton *)sender {
    //开始推流
    [sender setSelected:!sender.selected];
    if (!self.textView.text.length) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未给直播起标题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {

         RLog(@"textView的内容是%@",self.textView.text);
        
        _liveLogic = [[ZSHLiveLogic alloc]init];
        NSDictionary *paramDic = @{@"LIVE_TITLE":self.textView.text,@"HONOURUSER_ID":HONOURUSER_IDValue};
        [_liveLogic requestPushAddressWithDic:paramDic success:^(id response) {
            RLog(@"推流地址==%@",response);
            if (self.delegate) {
                BOOL ret = [self.delegate publisherOnClickedPushButton:sender.selected button:sender pushURL:response[@"pd"][@"PUSHADDRESS"]];
                if (ret) {
                    [self.pauseButton setSelected:NO];
                }
            }
        }];
    }
   
}


- (void)musicButtonAction:(UIButton *)sender {
    
    if (!self.musicSettingView) {
        [self setupMusicSettingView];
    }
    [self addSubview:self.musicSettingView];
    self.isMusicSettingShow = YES;
}


- (void)beautySettingButtonAction:(UIButton *)sender {
    
    if (!self.beautySettingView) {
        [self setupBeautySettingViews];
    }
    [self addSubview:self.beautySettingView];
    self.isBeautySettingShow = YES;
}

- (void)moreSettingButtonAction:(UIButton *)sender {
    
    if (!self.moreSettingView) {
        [self setupMoreSettingViews];
    }
    [self addSubview:self.moreSettingView];
    self.isMoreSettingShow = YES;
}

- (void)switchButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedSwitchCameraButton];
    }
    
    [self.flashButton setEnabled:!self.flashButton.enabled];
}


- (void)flashButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedFlashButton:sender.selected button:sender];
    }
}


- (void)pauseButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedPauseButton:sender.selected button:sender];
    }
}


- (void)restartButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickedRestartButton];
    }
}

- (void)beautyButtonAction:(UIButton *)sender {
    
    [sender setSelected:!sender.selected];
    if (self.delegate) {
        [self.delegate publisherOnClickedBeautyButton:sender.selected];
    }
}


- (void)sharedButtonAction:(UIButton *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickSharedButon];
    }
}


- (void)autoFocusSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickAutoFocusButton:sender.on];
    }
}

- (void)pushMirrorSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickPushMirrorButton:sender.on];
    }
}

- (void)previewMirrorSwitchAction:(UISwitch *)sender {
    
    if (self.delegate) {
        [self.delegate publisherOnClickPreviewMirrorButton:sender.on];
    }
}


#pragma mark - Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch.view class] isEqual:[self class]]) {
        return YES;
    }
    return  NO;
}


- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    kWeakSelf(self);
    if (self.isBeautySettingShow) {
        
        [self.beautySettingView removeFromSuperview];
        self.isBeautySettingShow = NO;
    } else if (self.isKeyboardEdit) {
        
        [self endEditing:YES];
    } else if (self.isMoreSettingShow) {
        
        [self.moreSettingView removeFromSuperview];
        self.isMoreSettingShow = NO;
    } else if (self.isMusicSettingShow) {
        
        [self.musicSettingView removeFromSuperview];
        self.isMusicSettingShow = NO;
        
    } else if (self.isMoreViewShow) {
        [self dismissPopView:self.moreView block:^{
            [weakself.moreView removeFromSuperview];
            weakself.isMoreViewShow = NO;
        }];
       
    }else if (self.isBeautyViewShow) {
        [self dismissPopView:self.beautyView block:^{
            [weakself.beautyView removeFromSuperview];
            weakself.isBeautyViewShow = NO;
        }];
        
    }else {
        
        CGPoint point = [gesture locationInView:self];
        CGPoint percentPoint = CGPointZero;
        percentPoint.x = point.x / CGRectGetWidth(self.bounds);
        percentPoint.y = point.y / CGRectGetHeight(self.bounds);
//        NSLog(@"聚焦点  - x:%f y:%f", percentPoint.x, percentPoint.y);
        if (self.delegate) {
            [self.delegate publisherOnClickedFocus:percentPoint];
        }
    }
    
}

static CGFloat lastPinchDistance = 0;
- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    if (gesture.numberOfTouches != 2) {
        return;
    }
    CGPoint p1 = [gesture locationOfTouch:0 inView:self];
    CGPoint p2 = [gesture locationOfTouch:1 inView:self];
    CGFloat dx = (p2.x - p1.x);
    CGFloat dy = (p2.y - p1.y);
    CGFloat dist = sqrt(dx*dx + dy*dy);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        lastPinchDistance = dist;
    }
    
    CGFloat change = dist - lastPinchDistance;

    NSLog(@"zoom - %f", change);

    if (self.delegate) {
        [self.delegate publisherOnClickedZoom:change/3000];
    }
}


- (void)leftSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.guideView) {
        [self.guideView removeFromSuperview];
        self.guideView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlivcUserDefaultsIndentifierFirst];
    }
    
    if (self.currentIndex == 0) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugTextInfo:NO];
            [self animationWithView:self.debugTextView x:-self.bounds.size.width];
        }
        self.currentIndex++;
        return;
    }
    
    if (self.currentIndex == 1) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugChartInfo:YES];
            [self animationWithView:self.debugChartView x:0];
        }
        self.currentIndex++;
        return;
    }
    
    if (self.currentIndex == 2) {
        // 无效
        return;
    }
}


- (void)rightSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (self.guideView) {
        [self.guideView removeFromSuperview];
        self.guideView = nil;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AlivcUserDefaultsIndentifierFirst];
    }
    
    if (self.currentIndex == 0) {
        // 无效
        return;
    }
    
    if (self.currentIndex == 1) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugTextInfo:YES];
            [self animationWithView:self.debugTextView x:0];
        }
        self.currentIndex--;
        return;
    }
    
    if (self.currentIndex == 2) {
        if (self.delegate) {
            [self.delegate publisherOnClickedShowDebugChartInfo:NO];
            [self animationWithView:self.debugChartView x:self.bounds.size.width];
        }
        self.currentIndex--;
        return;
    }

}


#pragma mark - Slider Actions

- (void)buffingValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyBuffingValueChanged:(int)slider.value];
    }
}

- (void)whiteValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyWhiteValueChanged:(int)slider.value];
    }
}



- (void)ruddyValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyRubbyValueChanged:(int)slider.value];
    }
}

- (void)cheekPinkValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyCheekPinkValueChanged:(int)slider.value];
    }
}

- (void)thinfaceValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyThinFaceValueChanged:(int)slider.value];
    }
}

- (void)shortenfaceValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyShortenFaceValueChanged:(int)slider.value];
    }
}

- (void)bigeyeValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyBigEyeValueChanged:(int)slider.value];
    }
}

#pragma mark - Animation

- (void)animationWithView:(UIView *)view x:(CGFloat)x {
    
    [UIView animateWithDuration:0.5 animations:^{
       
        CGRect frame = view.frame;
        frame.origin.x = x;
        view.frame = frame;
    }];
    
}


#pragma mark - TextField Actions

- (void)maxBitrateTextFieldValueChanged:(UITextField *)sender {
    
    if (!sender.text.length) {
        sender.text = sender.placeholder;
    }
    
    if (self.delegate) {
        [self.delegate publisherOnBitrateChangedTargetBitrate:[sender.text intValue]];
    }
}

- (void)minBitrateTextFieldValueChanged:(UITextField *)sender {
    
    if (!sender.text.length) {
        sender.text = sender.placeholder;
    }
    
    if (self.delegate) {
        [self.delegate publisherOnBitrateChangedMinBitrate:[sender.text intValue]];
    }
}


#pragma mark - Public

- (void)updateInfoText:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoLabel setHidden:NO];
        self.infoLabel.text = text;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(hiddenInfoLabel) withObject:nil afterDelay:2.0];

    });
}

- (void)hiddenInfoLabel {
    
    [self.infoLabel setHidden:YES];
}


- (void)updateDebugChartData:(AlivcLivePushStatsInfo *)info {
    
    [self.debugChartView updateData:info];
}

- (void)updateDebugTextData:(AlivcLivePushStatsInfo *)info {
    
    [self.debugTextView updateData:info];
}


- (void)hiddenVideoViews {
    
    self.beautySettingButton.hidden = YES;
    self.flashButton.hidden = YES;
    self.switchButton.hidden = YES;
    self.moreSettingButton.hidden = YES;
}

- (void)updateMusicDuration:(long)currentTime totalTime:(long)totalTime {
    
    [self.musicSettingView updateMusicDuration:currentTime totalTime:totalTime];
}

- (void)resetMusicButtonTypeWithPlayError {
    
    [self.musicSettingView resetButtonTypeWithPlayError];
}


- (BOOL)getPushButtonType {
    
    return self.pushButton.selected;
}

#pragma mark - Notification

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)sender {
    
    self.isKeyboardEdit = YES;
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.moreSettingView.frame;
        frame.origin.y = keyboardFrame.origin.y - frame.size.height;
        self.moreSettingView.frame = frame;
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)sender {
    self.isKeyboardEdit = NO;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.moreSettingView.frame;
        frame.origin.y = self.bounds.size.height - frame.size.height;
        self.moreSettingView.frame = frame;
    }];
}

- (void)onAppDidEnterBackGround:(NSNotification *)notification
{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];

}

- (void)setupCustomUI {
    
    // 标题
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(30));
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(kRealValue(-75));
        make.height.mas_equalTo(kRealValue(40));
    }];
    
    _shareBtnArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) {
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.tag = i+1;
        typeBtn.clipsToBounds = YES;
        [typeBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"begin_show_normal_%d",i+1]] forState:UIControlStateNormal];
        [typeBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"begin_show_pressed_%d",i+1]] forState:UIControlStateSelected];
        [typeBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:typeBtn];
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(kRealValue(81.5+i%5*(22.5+25)));
            make.bottom.mas_equalTo(self).offset(kRealValue(-173.5+i/5*(13+25)));
            make.size.mas_equalTo(CGSizeMake(kRealValue(25), kRealValue(25)));
        }];
        [_shareBtnArr addObject:typeBtn];
    }

    _beginShowBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"开启直播",@"titleColor":KWhiteColor,@"font":kPingFangLight(17),@"backgroundColor":KZSHColorFF2068}];
    _beginShowBtn.layer.cornerRadius = 20;
    [_beginShowBtn addTarget:self action:@selector(pushButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_beginShowBtn];
    [_beginShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(kRealValue(-83.5));
        make.left.mas_equalTo(self).offset(kRealValue(120));
        make.size.mas_equalTo(CGSizeMake(kRealValue(166), kRealValue(36)));
    }];
    
    _beautyBtn = [[UIButton alloc]init];
    _beautyBtn.titleLabel.font = kPingFangRegular(14);
    [_beautyBtn addTarget:self action:@selector(beautySettingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_beautyBtn setTitle:@"美颜" forState:UIControlStateNormal];
    [_beautyBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    [_beautyBtn setImage:[UIImage imageNamed:@"begin_show_0"] forState:UIControlStateNormal];
   
    [self addSubview:_beautyBtn];
    [_beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_beginShowBtn);
        make.right.mas_equalTo(_beginShowBtn.mas_left).offset(-kRealValue(10));
        make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(50)));
    }];
     [_beautyBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleTop imageTitleSpace:kRealValue(20)];
    
    UILabel *noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"开启直播即代表同意《尚播用户协议》",@"font":kPingFangRegular(11),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentCenter)}];
    [self addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(kRealValue(-50));
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kRealValue(200), kRealValue(12)));
    }];
}

- (XXTextView *)textView {
    if (!_textView) {
        _textView  = [[XXTextView alloc] initWithFrame:CGRectMake(15, 9.5, KScreenWidth-80, 30)];
        _textView.backgroundColor = KWhiteColor;
        _textView.textColor = [UIColor blackColor];
        _textView.font = kPingFangRegular(20);
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
        _textView.xx_placeholder = @"给直播写个标题吧！";
        _textView.xx_placeholderFont = kPingFangRegular(20);
        _textView.xx_placeholderColor = [UIColor blackColor];
        _textView.layer.cornerRadius = 15;
        _textView.layer.masksToBounds = true;
        _textView.layer.borderColor = KWhiteColor.CGColor;
    }
    return _textView;
}


#pragma setter 懒加载
//定位按钮
- (UIButton *)locateBtn{
    if (!_locateBtn) {
        _locateBtn = [self setupButtonWithFrame:(CGRectMake(CGRectGetMinX(self.switchButton.frame) - kRealValue(110), 0, kRealValue(100), topViewButtonSize))
                                        normalImage:[UIImage imageNamed:@"begin_show_locate"]
                                        selectImage:nil
                                             action:@selector(locateAction:)];
        [_locateBtn setTitle:@"" forState:UIControlStateNormal];
        _locateBtn.titleLabel.font = kPingFangRegular(12);
        [_locateBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(5.0)];
    }
    return _locateBtn;
}

- (ZSHLiveMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[ZSHLiveMoreView alloc]initWithFrame:CGRectMake(0, KScreenHeight, kScreenWidth, KScreenHeight*0.4) paramDic:@{@"config":self.config}];
    }
    return _moreView;
}

- (ZSHBeautyView *)beautyView{
    if (!_beautyView) {
        _beautyView = [[ZSHBeautyView alloc]initWithFrame:CGRectMake(0, KScreenHeight, kScreenWidth, KScreenHeight*0.4) paramDic:@{@"config":self.config}];
    }
    return _beautyView;
}

//直播action
- (ZSHBottomBlurPopView *)createBottomBlurPopViewWith:(ZSHFromVCToBottomBlurPopView)fromClassType{
    if (!_bottomBlurPopView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(fromClassType)};
        _bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:kAppDelegate.window.bounds paramDic:nextParamDic];
        _bottomBlurPopView.blurRadius = 20;
        _bottomBlurPopView.dynamic = NO;
        _bottomBlurPopView.tintColor = KClearColor;
        _bottomBlurPopView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [_bottomBlurPopView setBlurEnabled:NO];
    }
    return _bottomBlurPopView;
}

#pragma mark - Event
- (void)thirdLogin:(UIButton *)send{
    [_shareBtnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn == send) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }];
}

- (void)chatBtnAction:(UIButton *)chatBtn{
   
}

- (void)btnAction:(UIButton *)btn {
    switch (btn.tag - 11179) {
        case 0:{//更多
            [self moreAction:btn];
            break;
        }
        case 1:{//分享
            [self addSubview:self.bottomBlurPopView];
            break;
        }
        default:
            break;
    }
}

//更多功能
- (void)moreAction:(UIButton*)moreBtn{
    kWeakSelf(self);
    [self addSubview:self.moreView];
    self.isMoreViewShow = YES;
    [self showPopView:self.moreView];
    
    self.moreView.btnClickBlock = ^(UIButton *btn) {
        switch (btn.tag) {
            case 0:{//反转
                [weakself switchButtonAction:btn];
                break;
            }
            case 1:{//闪光灯
                [btn setSelected:!btn.selected];
                [weakself flashButtonAction:btn];
                break;
            }
            case 2:{//背景音乐
                [btn setSelected:!btn.selected];
                [weakself flashButtonAction:btn];
                break;
            }
            case 3:{//美颜
                [weakself dismissPopView:weakself.moreView block:^{
                    [weakself.moreView removeFromSuperview];
                    weakself.isMoreViewShow = NO;
                    
                    [weakself addSubview:weakself.beautyView];
                    weakself.isBeautyViewShow = YES;
                    [weakself showPopView:weakself.beautyView];
                    
                    weakself.beautyView.btnClickBlock = ^(UIButton *btn) {
                        [weakself beautyBtnSetAction:btn];
                    };
                }];
                break;
            }
                
            default:
                break;
        }
    };
}

- (void)beautyBtnSetAction:(UIButton *)btn{
    
    
}

- (void)showPopView:(UIView *)customView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect customViewFrame = customView.frame;
        customViewFrame.origin.y = KScreenHeight - customViewFrame.size.height;
        customView.frame = customViewFrame;
    } completion:nil];
}

- (void)dismissPopView:(UIView *)customView block:(void(^)())completion{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect moreViewFrame = self.moreView.frame;
        moreViewFrame.origin.y = KScreenHeight;
        self.moreView.frame = moreViewFrame;
    } completion:^(BOOL finished) {
        completion();
    }];
}

//点击主播头像
- (void)personInfo {
    NSDictionary *nextParamDic = @{KFromClassType:@(ZSHFromPersonInfoVCToBottomBlurPopView)};
    ZSHBottomBlurPopView *bottomBlurPopView = [[ZSHBottomBlurPopView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) paramDic:nextParamDic];
    bottomBlurPopView.blurRadius = 20;
    bottomBlurPopView.dynamic = NO;
    bottomBlurPopView.tintColor = KClearColor;
    [ZSHBaseUIControl setAnimationWithHidden:NO view:bottomBlurPopView completedBlock:nil];
}

- (void)locateAction:(UIButton *)btn{
    if (!_isLocate) {
        HCLocationManager *locationManager = [HCLocationManager sharedManager];
        locationManager.delegate = self;
        [locationManager startLocate];
        self.isLocate = YES;
    } else {
        self.isLocate = NO;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"关闭定位后，直播间不会出现在附近直播和同城直播中，会减少入场观众，确认关闭吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.locateBtn setTitle:@"未知星球" forState:UIControlStateNormal];
        _cityName = nil;
    }
}

#pragma mark - <HCLocationManagerDelegate>
- (void)loationMangerSuccessLocationWithCity:(NSString *)city{
    NSLog(@"city = %@",city);
    [self.locateBtn setTitle:city forState:UIControlStateNormal];
}
- (void)loationMangerSuccessLocationWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    NSLog(@"latitude = %f , longitude = %f",latitude,longitude);
}
- (void)loationMangerFaildWithError:(NSError *)error{
    NSLog(@"%@",error);
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

@end
