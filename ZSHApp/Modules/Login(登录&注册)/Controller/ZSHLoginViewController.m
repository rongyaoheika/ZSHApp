//
//  ZSHLoginViewController.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginViewController.h"
#import "ZSHTextFieldCellView.h"

@interface ZSHLoginViewController ()

@property (nonatomic, strong) ZSHTextFieldCellView  *userView;
@property (nonatomic, strong) ZSHTextFieldCellView  *pwdView;
@property (nonatomic, strong) UIButton              *loginButton;

@end

@implementation ZSHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登录";
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
