//
//  TLMenuButtonView.m
//  MiShu
//
//  Created by tianlei on 16/6/24.
//  Copyright © 2016年 Qzy. All rights reserved.
//

#import "TLMenuButtonView.h"

@interface TLMenuButtonView ()

@property (nonatomic, strong) UIButton *menu1;
@property (nonatomic, strong) UIButton *menu2;
@property (nonatomic, strong) UIButton *menu3;

@end

static TLMenuButtonView *instanceMenuView;

@implementation TLMenuButtonView
- (instancetype)init{
    if (self = [super init]) {
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)showItems{
    CGPoint center = self.centerPoint;
    CGFloat r = 90;
    CGPoint point1 = CGPointMake(center.x - r*cos(M_PI /5), center.y - r*sin(M_PI / 5));
    CGPoint point2 = CGPointMake(center.x, center.y - r);
    CGPoint point3 = CGPointMake(center.x + r*cos(M_PI /5), center.y - r*sin(M_PI / 5));
    
    NSDictionary *menu1Dic = @{@"title":@"黑微博",@"font":kPingFangLight(11),@"backgroundColor":KClearColor,@"withImage":@(YES),@"normalImage":@"live_weibo"};
    _menu1 = [ZSHBaseUIControl createBtnWithParamDic:menu1Dic];
    _menu1.frame = CGRectMake(0, 0, kRealValue(55), kRealValue(55));
    _menu1.center = center;
    _menu1.layer.cornerRadius = kRealValue(55)/2;
    [_menu1 layoutButtonWithEdgeInsetsStyle:(XYButtonEdgeInsetsStyleTop) imageTitleSpace:kRealValue(4)];
    _menu1.tag = 1;
    _menu1.alpha = 0;
    [_menu1 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *menu2Dic = @{@"title":@"开播吧",@"font":kPingFangLight(11),@"withImage":@(YES),@"normalImage":@"live_video"};
    _menu2 = [ZSHBaseUIControl createBtnWithParamDic:menu2Dic];
    _menu2.frame = CGRectMake(0, 0, kRealValue(55), kRealValue(55));
    _menu2.center = center;
    _menu2.layer.cornerRadius = kRealValue(55)/2;
    [_menu2 layoutButtonWithEdgeInsetsStyle:(XYButtonEdgeInsetsStyleTop) imageTitleSpace:kRealValue(4)];
    _menu2.tag = 2;
    _menu2.alpha = 0;
    [_menu2 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *menu3Dic = @{@"title":@"小视频",@"font":kPingFangLight(11),@"withImage":@(YES),@"normalImage":@"live_photo"};
    _menu3 = [ZSHBaseUIControl createBtnWithParamDic:menu3Dic];
    _menu3.frame = CGRectMake(0, 0, kRealValue(55), kRealValue(55));
    _menu3.center = center;
    _menu3.layer.cornerRadius = kRealValue(55)/2;
    [_menu3 layoutButtonWithEdgeInsetsStyle:(XYButtonEdgeInsetsStyleTop) imageTitleSpace:kRealValue(4)];
    _menu3.tag = 3;
    _menu3.alpha = 0;
    [_menu3 addTarget:self action:@selector(_addExamApprovel:) forControlEvents:UIControlEventTouchUpInside];
    
     [self addSubview:_menu1];
     [self addSubview:_menu2];
     [self addSubview:_menu3];
    
    [UIView animateWithDuration:0.2 animations:^{
        _menu1.alpha = 1;
        _menu2.alpha = 1;
        _menu3.alpha = 1;

        _menu1.center = point1;
        _menu2.center = point2;
        _menu3.center = point3;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        _menu1.center = self.centerPoint;
        _menu2.center = self.centerPoint;
        _menu3.center = self.centerPoint;

        _menu1.alpha = 0;
        _menu2.alpha = 0;
        _menu3.alpha = 0;

    } completion:^(BOOL finished) {
        [_menu1 removeFromSuperview];
        [_menu2 removeFromSuperview];
        [_menu3 removeFromSuperview];
    }];
}

- (void)dismissAtNow{

    [_menu1 removeFromSuperview];
    [_menu2 removeFromSuperview];
    [_menu3 removeFromSuperview];
}

- (void)_addExamApprovel:(UIButton *)sender{
//    [self dismiss];
    NSLog( @"%@", sender );
    if (self.clickLiveSubButton) {
        self.clickLiveSubButton(sender.tag);
    }
}

@end
