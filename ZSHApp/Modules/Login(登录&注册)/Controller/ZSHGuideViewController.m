//
//  ZSHGuideViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGuideViewController.h"
#import "ZSHGuideView.h"
#import "ZSHLoginViewController.h"
#import "ZSHCardViewController.h"
#import "ZSHGuideLogic.h"

@interface ZSHGuideViewController ()

@property (nonatomic, strong) ZSHGuideView         *midView;
@property (nonatomic, strong) ZSHGuideLogic        *guideLogic;
@property (nonatomic, strong) UIButton             *applyBtn;
@property (nonatomic, strong) UIButton             *vipLoginBtn;


@end

@implementation ZSHGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self createUI];
}

- (void)loadData{
    [self requestGuideImageData];
}

- (void)requestGuideImageData{
    _guideLogic = [[ZSHGuideLogic alloc]init];
    [_guideLogic requestGuideDataSuccess:^(NSMutableArray *imageArr) {
        [_midView updateViewWithParamDic:@{@"dataArr":imageArr}];
    } fail:nil];
}

- (void)createUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide1_bg"]];
    bgImage.frame = self.view.bounds;
    [self.view addSubview:bgImage];
    
    NSDictionary *nextParamDic = @{@"pageViewHeight":@(kRealValue(440)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
     _midView = [[ZSHGuideView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    [self.view addSubview:_midView];
    [_midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KTopHeight(71.5));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kRealValue(105));
    }];    
    
    kWeakSelf(self);
    NSDictionary *applyBtnDic = @{KFromClassType:@(FromGuideVCToGuideView),@"title":@"在线申请",@"titleColor":KWhiteColor,@"font":kPingFangRegular(12)};
    _applyBtn = [ZSHBaseUIControl  createBtnWithParamDic:applyBtnDic target:self action:nil];
    [ZSHSpeedy zsh_chageControlCircularWith:_applyBtn AndSetCornerRadius:0 SetBorderWidth:1.0 SetBorderColor:KWhiteColor canMasksToBounds:YES];
    [_applyBtn addTapBlock:^(UIButton *btn) {
        RLog(@"在线申请");
        ZSHCardViewController *cardVC = [[ZSHCardViewController alloc]init];
        [weakself.navigationController pushViewController:cardVC animated:YES];
        
    }];
    [self.view addSubview:_applyBtn];
    [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_midView.mas_bottom).offset(kRealValue(28));
        make.left.mas_equalTo(self.view).offset(kRealValue(37.5));
        make.width.mas_equalTo(kRealValue(120));
        make.height.mas_equalTo(kRealValue(30));
    }];

    NSDictionary *vipLoginbtnDic = @{@"title":@"会籍登录",@"titleColor":KWhiteColor,@"font":kPingFangRegular(12)};
    _vipLoginBtn = [ZSHBaseUIControl  createBtnWithParamDic:vipLoginbtnDic target:self action:@selector(btnAction)];
    [ZSHSpeedy zsh_chageControlCircularWith:_vipLoginBtn AndSetCornerRadius:0 SetBorderWidth:1.0 SetBorderColor:KWhiteColor canMasksToBounds:YES];
    [self.view addSubview:_vipLoginBtn];
    [_vipLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_applyBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(37.5));
        make.width.mas_equalTo(_applyBtn);
        make.height.mas_equalTo(_applyBtn);
    }];
    
    NSDictionary *chNameDic = @{@"text":@"荣耀黑卡",@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *chName = [ZSHBaseUIControl createLabelWithParamDic:chNameDic];
    [self.view addSubview:chName];
    [chName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_applyBtn.mas_top).offset(-kRealValue(100));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealValue(30));
        make.width.mas_equalTo(self.view);
    }];
    
    NSDictionary *enNameDic = @{@"text":@"Honour Centurion Card",@"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *enName = [ZSHBaseUIControl createLabelWithParamDic:enNameDic];
    [self.view addSubview:enName];
    [enName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(chName.mas_bottom);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(kRealValue(30));
        make.width.mas_equalTo(self.view);
    }];
    
}

- (void)btnAction{
    RLog(@"登录");
    ZSHLoginViewController *loginVC = [[ZSHLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
