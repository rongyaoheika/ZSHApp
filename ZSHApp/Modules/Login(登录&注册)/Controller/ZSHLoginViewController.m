//
//  ZSHLoginViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginViewController.h"
#import "ZSHTextFieldCellView.h"
#import "ZSHTextFieldCellView.h"
#import "ZSHLoginLogic.h"
#import "ZSHCardViewController.h"
#import "UserInfo.h"
#import "ZSHMultiInfoViewController.h"
#import "ZSHLoginLogic.h"
@interface ZSHLoginViewController ()

@property (nonatomic, strong) ZSHTextFieldCellView  *userView;
@property (nonatomic, strong) ZSHTextFieldCellView  *pwdView;
@property (nonatomic, strong) UIButton              *loginButton;
@property (nonatomic, strong) UIButton              *signBtn;
@property (nonatomic, strong) UIButton              *forgotPwdBtn;

@end

@implementation ZSHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
}

- (void)createUI{
    UIImageView *bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide1_bg"]];
    bgImage.frame = self.view.bounds;
    [self.view addSubview:bgImage];
    
    UIImageView *logoView = [[UIImageView alloc]init];
    logoView.layer.masksToBounds = YES;
    logoView.image = [UIImage imageNamed:@"login_icon"];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KTopHeight(129));
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(89.5),kRealValue(83)));
    }];
    
    NSDictionary *userParamDic = @{@"placeholder":@"请输入您的黑卡卡号",@"textFieldType":@(ZSHTextFieldViewCardNumer),@"placeholderTextColor":KZSHColor454545,KFromClassType:@(FromLoginVCToTextFieldCellView)};
    _userView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectZero paramDic:userParamDic];
    [self.view addSubview:_userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoView.mas_bottom).offset(kRealValue(50));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(kRealValue(315));
        make.height.mas_equalTo(kRealValue(45));
    }];
    
    NSDictionary *pwdParamDic = @{@"placeholder":@"请输入您的密码",@"textFieldType":@(ZSHTextFieldViewPwd),@"placeholderTextColor":KZSHColor454545, KFromClassType:@(FromLoginVCToTextFieldCellView)};
    _pwdView = [[ZSHTextFieldCellView alloc]initWithFrame:CGRectZero paramDic:pwdParamDic];
    [self.view addSubview:_pwdView];
    [_pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userView.mas_bottom);
        make.centerX.mas_equalTo(_userView);
        make.width.mas_equalTo(_userView);
        make.height.mas_equalTo(_userView);
    }];
    
    kWeakSelf(self);
    NSDictionary *btnDic = @{@"title":@"登录",@"titleColor":KWhiteColor,@"font":kPingFangRegular(17),@"backgroundColor":KZSHColorCD933B};
    _loginButton = [ZSHBaseUIControl  createBtnWithParamDic:btnDic target:self action:@selector(login)];
    _loginButton.layer.cornerRadius = kRealValue(3.0);
    [self.view addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwdView.mas_bottom).offset(kRealValue(71.5));
        make.centerX.mas_equalTo(_userView);
        make.width.mas_equalTo(_userView);
        make.height.mas_equalTo(kRealValue(40));
    }];
    
    
    NSDictionary *signBtnDic = @{@"title":@"在线申请",@"font":kPingFangRegular(12)};
    _signBtn = [ZSHBaseUIControl  createBtnWithParamDic:signBtnDic target:self action:nil];
    [_signBtn addTapBlock:^(UIButton *btn) {
        RLog(@"点击在线申请");
        ZSHCardViewController *cardVC = [[ZSHCardViewController alloc]init];
        RootNavigationController *cardNavi = [[RootNavigationController alloc]initWithRootViewController:cardVC];
        [weakself presentViewController:cardNavi animated:YES completion:nil];
    }];
    [self.view addSubview:_signBtn];
    [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginButton.mas_bottom).offset(kRealValue(15));
        make.left.mas_equalTo(_loginButton);
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(12));
    }];
    
    NSDictionary *forgotPwdBtnDic = @{@"title":@"忘记密码",@"font":kPingFangRegular(12)};
    _forgotPwdBtn = [ZSHBaseUIControl  createBtnWithParamDic:forgotPwdBtnDic target:self action:nil];
    [_forgotPwdBtn addTapBlock:^(UIButton *btn) {
        ZSHMultiInfoViewController *multiInfoVC = [[ZSHMultiInfoViewController alloc] initWithParamDic:@{KFromClassType:@(FromAccountVCToMultiInfoVC),@"title":@"找回登录密码", @"bottomBtnTitle":@"下一步"}];
        [weakself.navigationController pushViewController:multiInfoVC animated:YES];
    }];
    [self.view addSubview:_forgotPwdBtn];
    [_forgotPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginButton.mas_bottom).offset(kRealValue(15));
        make.right.mas_equalTo(_loginButton);
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(12));
    }];
#ifdef DEBUG
    _userView.textField.text = @"10";
    _pwdView.textField.text = @"1";
#endif
}

#pragma action
- (void)login {
    RLog(@"点击登录");
    if (_userView.textField.text.length && _pwdView.textField.text.length) {
        RLog(@"username;%@:password%@", _userView.textField.text,_pwdView.textField.text);
        [userManager login:kUserLoginTypePwd params:@{@"CARDNO":_userView.textField.text,@"PASSWORD":[ZSHBaseFunction md5StringFromString: _pwdView.textField.text]} completion:^(BOOL success, NSString *des) {
            if (success) {
                [self skipAction];
            } else {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号密码错误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
                [ac addAction:cancelAction];
                [self presentViewController:ac animated:YES completion:nil];
            }
        }];
    } else {
#ifdef DEBUG
        [self skipAction];
#else
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入账号密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:cancelAction];
        [self presentViewController:ac animated:YES completion:nil];
#endif
    }
}


-(void)skipAction{
    KPostNotification(KNotificationLoginStateChange, @YES);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
