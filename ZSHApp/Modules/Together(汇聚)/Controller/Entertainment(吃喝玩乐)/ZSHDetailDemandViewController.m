//
//  ZSHDetailDemandViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHDetailDemandViewController.h"
#import "XXTextView.h"

@interface ZSHDetailDemandViewController ()

@end

@implementation ZSHDetailDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"详细要求";
    
    [self addNavigationItemWithTitles:@[@"发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(1)]];
    
    XXTextView *contentTextView = [[XXTextView alloc] init];
    contentTextView.backgroundColor = KZSHColor181818;
    contentTextView.textColor = [UIColor whiteColor];
    contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    contentTextView.xx_placeholder = @"请输入内容";
    contentTextView.xx_placeholderFont = [UIFont systemFontOfSize:15];
    contentTextView.xx_placeholderColor = KZSHColor454545;
    [self.view addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(79));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.right.mas_equalTo(self.view).offset(kRealValue(-15));
        make.height.mas_equalTo(kRealValue(177));
    }];
}


- (void)initViewModel {
    
}

#pragma action
- (void)distributeAction{
    
}

@end
