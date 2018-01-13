//
//  ZSHMagazineReusableView.m
//  ZSHApp
//
//  Created by mac on 11/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHMagazineReusableView.h"
#import "ZSHGuideView.h"


@interface ZSHMagazineReusableView ()

@property (nonatomic, strong) ZSHGuideView *guideView;

@end

@implementation ZSHMagazineReusableView
- (void)drawRect:(CGRect)rect {
    
    [self addSubview:self.guideView];
    [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(120);
    }];
    
    
    UILabel *designerLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"设计师", @"font":kPingFangMedium(15)}];
    [self addSubview:designerLabel];
    [designerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_guideView.mas_bottom).offset(25);
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), 16));
    }];
    
    UIButton *joinBtn = [ZSHBaseUIControl createBtnWithParamDic:@{@"title":@"入驻",@"font":kPingFangRegular(12)}];
    [self addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kRealValue(KLeftMargin));
        make.centerY.mas_equalTo(designerLabel);
        make.size.mas_equalTo(CGSizeMake(kRealValue(25), 13));
    }];
    
    NSArray *namesArr = @[@"Ronald", @"Andrew", @"Herbert", @"Frederick", @"Potter"];
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NSStringFormat(@"designer%d", i+1)]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(designerLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin+(35.5+45)*i));
            make.size.mas_equalTo(CGSizeMake(kRealValue(45), kRealValue(45)));
        }];
        
        UILabel *nameLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":namesArr[i], @"font":kPingFangRegular(14), @"textAlignment":@(NSTextAlignmentCenter)}];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).offset(7.5);
            make.centerX.mas_equalTo(imageView);
            make.size.mas_equalTo(CGSizeMake(kRealValue(70), kRealValue(15)));
        }];
    }
    
    UILabel *magazineLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"杂志", @"font":kPingFangMedium(15)}];
    [self addSubview:magazineLabel];
    [magazineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(designerLabel.mas_bottom).offset(106.5);
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(50), 16));
    }];
}

- (void)updateAd:(NSArray *)arr {
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic  in arr) {
        [imageArr addObject:dic[@"SHOWIMG"]];
    }
    [_guideView updateViewWithParamDic:@{@"dataArr":imageArr}];
}

- (ZSHGuideView *)guideView {
    if(!_guideView) {
        NSDictionary *nextParamDic = @{KFromClassType:@(FromBuyVCToGuideView),@"pageViewHeight":@(kRealValue(120)),@"min_scale":@(0.6),@"withRatio":@(1.8),@"infinite":@(false)};
        _guideView = [[ZSHGuideView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kRealValue(120)) paramDic:nextParamDic];
    }
    return _guideView;
}

@end
