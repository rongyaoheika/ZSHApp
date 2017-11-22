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


@interface ZSHGuideViewController ()

@property (nonatomic, strong) NSArray              *imageArr;
@property (nonatomic, strong) ZSHGuideView         *midView;
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
    self.imageArr = @[@"guide1",@"guide2",@"guide3",@"guide4"];
}

- (void)createUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide1_bg"]];
    bgImage.frame = self.view.bounds;
    [self.view addSubview:bgImage];
    
    NSDictionary *nextParamDic = @{@"dataArr":self.imageArr,@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
     _midView = [[ZSHGuideView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    [self.view addSubview:_midView];
    [_midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(71.5));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kRealValue(105));
    }];
    
    kWeakSelf(self);
    NSDictionary *applyBtnDic = @{@"title":@"在线申请",@"titleColor":KWhiteColor,@"font":kPingFangRegular(12)};
    _applyBtn = [ZSHBaseUIControl createBtnWithParamDic:applyBtnDic];
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
    _vipLoginBtn = [ZSHBaseUIControl createBtnWithParamDic:vipLoginbtnDic];
    [ZSHSpeedy zsh_chageControlCircularWith:_vipLoginBtn AndSetCornerRadius:0 SetBorderWidth:1.0 SetBorderColor:KWhiteColor canMasksToBounds:YES];
    [_vipLoginBtn addTapBlock:^(UIButton *btn) {
        RLog(@"登录");
        ZSHLoginViewController *loginVC = [[ZSHLoginViewController alloc]init];
        RootNavigationController *loginNavi = [[RootNavigationController alloc]initWithRootViewController:loginVC];
        [weakself presentViewController:loginNavi animated:YES completion:nil];
    }];
    [self.view addSubview:_vipLoginBtn];
    [_vipLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_applyBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(37.5));
        make.width.mas_equalTo(_applyBtn);
        make.height.mas_equalTo(_applyBtn);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
