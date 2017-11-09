//
//  ZSHCommentViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCommentViewController.h"
#import "TggStarEvaluationView.h"
#import "XXTextView.h"

@interface ZSHCommentViewController ()

@property (nonatomic, strong) TggStarEvaluationView     *starView;


@end

@implementation ZSHCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    
    [self initViewModel];
}

- (void)createUI{
    self.title = @"发表评价";
    
    [self addNavigationItemWithTitles:@[@"发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(1)]];
    
    
    _starView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:nil];
    [self.view addSubview:_starView];
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kRealValue(94));
        make.width.mas_equalTo(kRealValue(134));
        make.height.mas_equalTo(kRealValue(21));
    }];
    _starView.starCount = 4;
    _starView.spacing = 0.33/2;
    
    NSDictionary *noticeLabelDic = @{@"text":@"给店家评分",@"font":kPingFangMedium(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:noticeLabelDic];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(_starView).offset(kRealValue(35));
        make.width.mas_equalTo(kRealValue(57));
        make.height.mas_equalTo(kRealValue(11));
    }];
    
    
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
        make.top.mas_equalTo(self.view).offset(kRealValue(177.5));
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
