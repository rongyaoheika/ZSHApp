//
//  ZSHBeautyView.m
//  ZSHApp
//
//  Created by mac on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHBeautyView.h"
#import <AlivcLivePusher/AlivcLivePusherHeader.h>
#import "AlivcPushViewsProtocol.h"

@interface ZSHBeautyView ()
@property (nonatomic, weak) id<AlivcPublisherViewDelegate> delegate;
@property (nonatomic, strong) UIView                *beautySettingView;
@property (nonatomic, strong) UIView                *setView;
@property (nonatomic, strong) UIButton              *defaultBtn;
@property (nonatomic, strong) NSMutableArray        *btnArr;
@property (nonatomic, strong) NSMutableArray        *sliderArr;
@property (nonatomic, strong) AlivcLivePushConfig   *config;
@property (nonatomic, strong) NSArray               *beautyDefaultValueArr;

@end

@implementation ZSHBeautyView

- (void)setup{
    self.config = self.paramDic[@"config"];
    
    _btnArr = [[NSMutableArray alloc]init];
    _sliderArr = [[NSMutableArray alloc]init];
    
    _beautySettingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(150))];
    _beautySettingView.backgroundColor = KZSHColorRGBA(1, 1, 1, 0.3);
    //    _beautyView.hidden = YES;
    [self addSubview:_beautySettingView];
    [self setupBeautySettingViews];
    
    _setView = [[UIView alloc]initWithFrame:CGRectMake(0, kRealValue(150), KScreenWidth, kRealValue(140))];
    _setView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.90];
    [self addSubview:_setView];
    
    NSDictionary *titleLabelDic = @{@"text":@"美颜",@"font":kPingFangRegular(15)};
    UILabel *titleLB = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [_setView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_setView).offset(kRealValue(25));
        make.height.mas_equalTo(kRealValue(44));
        make.width.mas_equalTo(kRealValue(100));
        make.top.mas_equalTo(_setView);
    }];
    
    NSDictionary *btnDic = @{@"title":@"恢复默认",@"font":kPingFangRegular(12),@"backgroundColor":KZSHColor454545};
    _defaultBtn = [ZSHBaseUIControl createBtnWithParamDic:btnDic];
    [_defaultBtn addTarget:self action:@selector(defaultBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _defaultBtn.layer.cornerRadius = kRealValue(12.5);
    [_setView addSubview:_defaultBtn];
    [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealValue(70), kRealValue(25)));
        make.right.mas_equalTo(_setView).offset(-KLeftMargin);
        make.centerY.mas_equalTo(titleLB);
    }];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kRealValue(44), KScreenWidth, kRealValue(1))];
    lineView.backgroundColor = KLightWhiteColor;;
    [_setView addSubview:lineView];
    
    CGFloat space = (KScreenWidth - kRealValue(200))/6;
    for (int i = 0; i <5; i++) {
        NSDictionary *setBtnDic = @{@"title":[NSString stringWithFormat:@"%d",i],@"titleColor":KWhiteColor,@"font":kPingFangRegular(30)};
        UIButton *setBtn = [ZSHBaseUIControl createBtnWithParamDic:setBtnDic];
        setBtn.tag = i + 1;
        setBtn.layer.cornerRadius = kRealValue(20);
        setBtn.clipsToBounds = YES;
        [setBtn setBackgroundImage:[UIImage imageWithColor:KClearColor size:CGSizeMake(kRealValue(40), kRealValue(40))] forState:UIControlStateSelected];
        [setBtn setBackgroundImage:[UIImage imageWithColor:KWhiteColor size:CGSizeMake(kRealValue(40), kRealValue(40))] forState:UIControlStateSelected];
        [_setView addSubview:setBtn];
        [setBtn addTarget:self action:@selector(setBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealValue(40), kRealValue(40)));
            make.left.mas_equalTo(_setView).offset((i+1)*space + i*kRealValue(40));
            make.top.mas_equalTo(lineView.mas_bottom).offset(kRealValue(28));
        }];
        [_btnArr addObject:setBtn];
    }
}

- (void)setBeautyDelegate:(id)delegate{
    self.delegate = delegate;
}

- (void)setupBeautySettingViews {
    NSArray *titleArr = @[@[@"磨皮",@"美白"],
                          @[@"红润",@"腮红"],
                          @[@"瘦脸",@"大眼"],
                          @[@"收下巴"]];
    
    NSArray *sliderActionArr = @[@[@"buffingValueChange:",@"whiteValueChange:"],
                                 @[@"ruddyValueChange:",@"cheekPinkValueChange:"],
                                 @[@"thinfaceValueChange:",@"bigeyeValueChange:"],
                                 @[@"shortenfaceValueChange:"]];
    
    _beautyDefaultValueArr = @[@[@(self.config.beautyBuffing),@(self.config.beautyWhite)],
                               @[@(self.config.beautyRuddy),@(self.config.beautyCheekPink)],
                               @[@(self.config.beautyThinFace),@(self.config.beautyBigEye)],
                               @[@(self.config.beautyShortenFace)]
                               ];
    
    for (int i = 0; i<titleArr.count; i++) {
        for (int j = 0; j<[titleArr[i]count]; j++) {
            NSDictionary *beautyLBDic = @{@"text":titleArr[i][j],@"font":kPingFangRegular(15),@"textColor":KWhiteColor};
            UILabel *beautyLB = [ZSHBaseUIControl createLabelWithParamDic:beautyLBDic];
            beautyLB.frame = CGRectMake(kRealValue(25)+(j%2)*kRealValue(200), kRealValue(15)+i*(kRealValue(15)+kRealValue(15)) , kRealValue(40), kRealValue(15));
            [self.beautySettingView addSubview:beautyLB];
            
            CGFloat sliderX = CGRectGetMaxX(beautyLB.frame)+ kRealValue(5);
            CGFloat sliderY = CGRectGetCenter(beautyLB.frame).y;
            
            UISlider *slider = [[UISlider alloc] init];
            slider.tag = i+j;
            slider.minimumTrackTintColor = KZSHColorA61CE7;
            slider.maximumTrackTintColor = KZSHColor929292;
            
            [slider setThumbImage:[UIImage imageNamed:@"age_icon"] forState:UIControlStateNormal];
            slider.frame = CGRectMake(sliderX,sliderY, kRealValue(100), kRealValue(2));
            [slider addTarget:self action:NSSelectorFromString(sliderActionArr[i][j]) forControlEvents:(UIControlEventValueChanged)];
            slider.maximumValue = 100;
            slider.minimumValue = 0;
            slider.value = [_beautyDefaultValueArr[i][j] intValue];
            [self.beautySettingView addSubview:slider];
            [_sliderArr addObject:slider];
        }
    }
}


#pragma mark - Slider Actions

- (void)buffingValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyBuffingValueChanged:(int)slider.value];
    }
}

- (void)whiteValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyWhiteValueChanged:(int)slider.value];
    }
}

- (void)ruddyValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyRubbyValueChanged:(int)slider.value];
    }
}

- (void)cheekPinkValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyCheekPinkValueChanged:(int)slider.value];
    }
}

- (void)thinfaceValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyThinFaceValueChanged:(int)slider.value];
    }
}

- (void)shortenfaceValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyShortenFaceValueChanged:(int)slider.value];
    }
}

- (void)bigeyeValueChange:(UISlider *)slider {
    
    if (self.delegate) {
        [self.delegate publisherSliderBeautyBigEyeValueChanged:(int)slider.value];
    }
}

//恢复默认
- (void)defaultBtnAction{
    for (UISlider *slider in _sliderArr) {
        NSInteger tag = slider.tag;
        slider.value = [_beautyDefaultValueArr[tag/2][tag%2] intValue];
    }
}

//按钮设置美颜value
- (void)setBtnAction:(UIButton *)sender{
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn == sender) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }];
    
    if (sender.tag-1 == 0) {//关闭美颜
        self.beautySettingView.hidden = YES;
        if (self.delegate) {
            [self.delegate publisherOnClickedBeautyButton:false];
        }
        
    } else {
        self.beautySettingView.hidden = NO;
        if (self.delegate) {
            [self.delegate publisherOnClickedBeautyButton:true];
        }
        for (UISlider *slider in _sliderArr) {
            CGFloat defaultValue = [_beautyDefaultValueArr[slider.tag/2][slider.tag%2] intValue];
            slider.value = defaultValue + (sender.tag -1)*10;
        }
    }
}



@end
