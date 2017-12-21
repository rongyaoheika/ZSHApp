
//
//  ZSHVideoRecViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHVideoRecViewController.h"

@interface ZSHVideoRecViewController ()

@end

@implementation ZSHVideoRecViewController

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
    [closeBtn addTarget:self action:@selector(closeVideoRec) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(22));
        make.left.mas_equalTo(self.view).offset(kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(14));
    }];
    
    UIButton *refreshBtn = [[UIButton alloc]init];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"record_image_1"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refresAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(18.7));
    }];
    
    
    NSArray *titleArr = @[@"萌颜", @"音乐", @"", @"美颜", @"图片"];
    for (int i = 0; i < titleArr.count; i++) {
        if (i == 2) continue;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"record_image_%d", i+2]]];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(kRealValue(34.5+i*(38+30)));
            make.bottom.mas_equalTo(self.view).offset(kRealValue(-71.5));
            make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(30)));
        }];
        
        UILabel *label = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":titleArr[i],@"font":kPingFangRegular(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)}];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(kRealValue(34 + i*(40+28)));
            make.bottom.mas_equalTo(self.view).offset(kRealValue(-53.5));
            make.size.mas_equalTo(CGSizeMake(kRealValue(30), kRealValue(15)));
        }];
    }
    
    UIImageView *centerBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_mid"]];
    [self.view addSubview:centerBtn];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(kRealValue(-49.5));
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), kRealValue(50)));
    }];

}

- (void)closeVideoRec {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)refresAction {
    
}


@end
