//
//  ZSHBeginShowViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBeginShowViewController.h"
#import "ZegoAVKitManager.h"

@interface ZSHBeginShowViewController ()<ZegoDeviceEventDelegate>

@property (nonatomic, strong)  UIView         *preView;

@end

@implementation ZSHBeginShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData {
}

- (void)createUI {
    self.isHidenNaviBar = true;
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBeginShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(22));
        make.left.mas_equalTo(self.view).offset(kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(14));
    }];
    
    
    UIButton *cameraBtn = [[UIButton alloc]init];
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"record_image_1"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(refresAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(18.7));
    }];
    
    UIButton *locationBtn = [[UIButton alloc]init];
    [locationBtn setBackgroundImage:[UIImage imageNamed:@"begin_show_00"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(42.5));
        make.width.and.height.mas_equalTo(kRealValue(20));
    }];

    // 标题
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"给直播写个标题吧！",@"font":kPingFangRegular(20),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)}];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(kRealValue(-75));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth, kRealValue(21)));
    }];
    
    
    for (int i = 0; i < 10; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"begin_show_%d", i+1]]];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    UIButton *beginShowBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"开启直播",@"titleColor":KWhiteColor,@"font":kPingFangLight(17),@"backgroundColor":KZSHColorFF2068}];
    beginShowBtn.layer.cornerRadius = 20;
    [self.view addSubview:beginShowBtn];
    [beginShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)addPreview
{
    _preView = [[UIView alloc] init];
    self.preView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.preView];
    [self.view sendSubviewToBack:self.preView];
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

- (void)refresAction {
    
}

@end
