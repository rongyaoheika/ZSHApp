//
//  ZSHCommentViewController.m
//  ZSHApp
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCommentViewController.h"
#import "XXTextView.h"
#import "CWStarRateView.h"
#import "ZSHMineLogic.h"

@interface ZSHCommentViewController ()

@property (nonatomic, strong) CWStarRateView            *starView;
@property (nonatomic, assign) CGFloat                   topSpacing;
@property (nonatomic, strong) XXTextView                *contentTextView;
@property (nonatomic, strong) ZSHMineLogic              *mineLogic;
@property (nonatomic, strong) NSString                  *ShowName;

@end

@implementation ZSHCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createUI];
}

- (void)loadData{
    _ShowName = @"1";
    [self initViewModel];
    _mineLogic = [[ZSHMineLogic alloc] init];
}

- (void)createUI{
    self.title = @"发表评价";
    
    [self addNavigationItemWithTitles:@[@"发布"] isLeft:NO target:self action:@selector(distributeAction) tags:@[@(1)]];
    
    switch ([self.paramDic[KFromClassType]integerValue]) {
        case ZSHFromGoodsMineVCToCommentVC:{
            _topSpacing = -50;
        }
            break;
        case ZSHFromShopCommentVCToCommentVC:{
            _topSpacing = 94;
        }
            break;
        default:{
            _topSpacing = 30;
        }
            break;
    }
    
    [self.view addSubview:self.starView];
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kRealValue(_topSpacing));
        make.width.mas_equalTo(kRealValue(134));
        make.height.mas_equalTo(kRealValue(20));
    }];
    
    NSDictionary *noticeLabelDic = @{@"text":@"给店家评分",@"font":kPingFangMedium(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *noticeLabel = [ZSHBaseUIControl createLabelWithParamDic:noticeLabelDic];
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(_starView).offset(kRealValue(35));
        make.width.mas_equalTo(kRealValue(57));
        make.height.mas_equalTo(kRealValue(11));
    }];
    

    [self.view addSubview:self.contentTextView];
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(_topSpacing+111.5));
        make.left.mas_equalTo(self.view).offset(kRealValue(15));
        make.right.mas_equalTo(self.view).offset(kRealValue(-15));
        make.height.mas_equalTo(kRealValue(177));
    }];
    
    
    NSDictionary *conBtnDic = @{@"title":@"匿名评价",@"font":kPingFangRegular(12),@"normalImage":@"airplane_normal",@"selectedImage":@"airplane_press"};
    UIButton *conBtn = [ZSHBaseUIControl  createBtnWithParamDic:conBtnDic target:self action:@selector(conBtnAction:)];
    [self.view addSubview:conBtn];
    [conBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(kRealValue(10));
        make.top.mas_equalTo(self.contentTextView.mas_bottom).offset(15);
        make.height.mas_equalTo(kRealValue(20));
        make.width.mas_equalTo(kRealValue(110));
    }];
    [conBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(5)];
}

- (XXTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[XXTextView alloc] init];
        _contentTextView.backgroundColor = KZSHColor181818;
        _contentTextView.textColor = [UIColor whiteColor];
        _contentTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _contentTextView.font = [UIFont systemFontOfSize:15];
        _contentTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _contentTextView.xx_placeholder = @"请输入内容";
        _contentTextView.xx_placeholderFont = [UIFont systemFontOfSize:15];
        _contentTextView.xx_placeholderColor = KZSHColor454545;
    }
    return _contentTextView;
}

- (CWStarRateView *)starView {
    if(!_starView) {
        _starView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0,0, kRealValue(134), kRealValue(20)) numberOfStars:5];
        _starView.scorePercent = 0.40;
        _starView.allowIncompleteStar = YES;
        _starView.hasAnimation = YES;
        _starView.allowUserTap = YES;
    }
    return _starView;
}


- (void)initViewModel {
    
}

#pragma action
- (void)distributeAction{
    kWeakSelf(self);
    [_mineLogic requestSProductAddEva:@{@"PRODUCT_ID":self.paramDic[@"PRODUCT_ID"],@"HONOURUSER_ID":HONOURUSER_IDValue,@"EVALUATECONTENT":_contentTextView.text,@"EVALUATECOINT":@"0", @"ISSHOW":_ShowName } success:^(id response) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"评价成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakself.navigationController popViewControllerAnimated:true];
        }];
        [ac addAction:cancelAction];
        [weakself presentViewController:ac animated:YES completion:nil];

    }];
}

- (void)conBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _ShowName = @"0";
    } else {
        _ShowName = @"1";
    }
    
}
@end
