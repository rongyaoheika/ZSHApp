//
//  ZSHUploadIDCardController.m
//  ZSHApp
//
//  Created by mac on 13/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHUploadIDCardController.h"

@interface ZSHUploadIDCardController ()

@end

@implementation ZSHUploadIDCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    self.title = @"身份证";
    
    UIImageView *positiveIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uploadID1"]];
    [self.view addSubview:positiveIV];
    [positiveIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(KNavigationBarHeight+25);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(250), 158));
    }];
    
    UIImageView *negativeIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uploadID2"]];
    [self.view addSubview:negativeIV];
    [negativeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(positiveIV.mas_bottom).offset(21);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kRealValue(250), 158));
    }];
}

@end
