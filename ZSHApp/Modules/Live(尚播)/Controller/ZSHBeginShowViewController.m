//
//  ZSHBeginShowViewController.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBeginShowViewController.h"
#import "XXTextView.h"

@interface ZSHBeginShowViewController ()

@property (nonatomic, strong)  XXTextView     *textView;
@property (nonatomic, strong)  UIButton       *beginShowBtn;
@property (nonatomic, strong)  UIButton       *cameraBtn;


@end

@implementation ZSHBeginShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.isHidenNaviBar = true;
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
    closeBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closeBtn addTarget:self action:@selector(closeBeginShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kRealValue(22));
        make.left.mas_equalTo(self.view).offset(kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(44));
    }];
    
    
    _cameraBtn = [[UIButton alloc]init];
    [_cameraBtn setImage:[UIImage imageNamed:@"record_image_1"] forState:UIControlStateNormal];
    [_cameraBtn addTarget:self action:@selector(refresAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];
    [_cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(18));
        make.width.and.height.mas_equalTo(kRealValue(44));
    }];
    
    UIButton *locationBtn = [[UIButton alloc]init];
    [locationBtn setImage:[UIImage imageNamed:@"begin_show_00"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(closeBtn);
        make.right.mas_equalTo(self.view).offset(-kRealValue(42.5));
        make.width.and.height.mas_equalTo(kRealValue(44));
    }];

    // 标题
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kRealValue(30));
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).offset(kRealValue(-75));
        make.height.mas_equalTo(kRealValue(40));
    }];
    
    for (int i = 0; i < 5; i++) {
        
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.clipsToBounds = YES;
        [typeBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"begin_show_normal_%d",i+1]] forState:UIControlStateNormal];
        [typeBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"begin_show_pressed_%d",i+1]] forState:UIControlStateSelected];
        [typeBtn addTarget:self action:@selector(thirdLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:typeBtn];
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    _beginShowBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"开启直播",@"titleColor":KWhiteColor,@"font":kPingFangLight(17),@"backgroundColor":KZSHColorFF2068}];
    _beginShowBtn.layer.cornerRadius = 20;
    [_beginShowBtn addTarget:self action:@selector(beginShowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_beginShowBtn];
    [_beginShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
}

- (XXTextView *)textView {
    if (!_textView) {
        _textView  = [[XXTextView alloc] initWithFrame:CGRectMake(15, 9.5, KScreenWidth-80, 30)];
        _textView.backgroundColor = KZSHColor181818;
        _textView.textColor = KZSHColor929292;
        _textView.font = kPingFangRegular(20);
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
        _textView.xx_placeholder = @"给直播写个标题吧！";
        _textView.xx_placeholderFont = kPingFangRegular(20);
        _textView.xx_placeholderColor = KZSHColor929292;
        _textView.layer.cornerRadius = 15;
        _textView.layer.masksToBounds = true;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = KZSHColor929292.CGColor;
    }
    return _textView;
}

#pragma mark - Event
- (void)locationAction {
    
}

- (void)closeBeginShow {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)beginShowAction {
    RLog(@"开始直播");
    
//    AlivcLivePushConfigViewController *pushConfigVC = [[AlivcLivePushConfigViewController alloc] init];
//    [self.navigationController pushViewController:pushConfigVC animated:YES];
}


- (void)thirdLogin:(UIButton *)btn{
    RLog(@"点击第三方");
    btn.selected = !btn.selected;
}


@end
