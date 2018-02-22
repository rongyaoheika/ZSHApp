//
//  ZSHCountdowView.m
//  HHCountdown
//
//  Created by chh on 2017/7/27.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "ZSHCountdowView.h"
@interface ZSHCountdowView()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *countLB;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *strArr;

@end

@implementation ZSHCountdowView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        NSDictionary *countLBDic = @{@"text":@"",@"font":kPingFangMedium(50),@"textColor":KZSHColorF29E19,@"textAlignment":@(NSTextAlignmentCenter)};
        _countLB = [ZSHBaseUIControl createLabelWithParamDic:countLBDic];
        _countLB.frame = CGRectMake(0, 0, KScreenWidth, kRealValue(100));
        [self addSubview:_countLB];
        _strArr = @[@"GO",@"1",@"2",@"3"];
        _count =_strArr.count - 1;
        
        NSDictionary *titleLBDic = @{@"text":@"",@"font":kPingFangMedium(15),@"textColor":KZSHColorF29E19,@"textAlignment":@(NSTextAlignmentCenter)};
        _titleLB = [ZSHBaseUIControl createLabelWithParamDic:titleLBDic];
        
        _titleLB.frame = CGRectMake(0, CGRectGetMaxY(_countLB.frame), KScreenWidth, kRealValue(20));
        [self addSubview:_titleLB];
        
    }
    return self;
}
//开始倒计时
- (void)startCount{
    [self initTimer];
}

- (void)initTimer{
    //如果没有设置，则默认为3
    if (self.count == 0){
        self.count = 3;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown{
    if (_count > -1){

        self.countLB.text = _strArr[_count];
        self.titleLB.text = @"观众正在排队，即将入场";
        CAKeyframeAnimation *anima2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        //字体变化大小
        NSValue *value1 = [NSNumber numberWithFloat:3.0f];
        NSValue *value2 = [NSNumber numberWithFloat:2.0f];
        NSValue *value3 = [NSNumber numberWithFloat:0.7f];
        NSValue *value4 = [NSNumber numberWithFloat:1.0f];
        anima2.values = @[value1,value2,value3,value4];
        anima2.duration = 0.5;
        [self.countLB.layer addAnimation:anima2 forKey:@"scalsTime"];
        _count -= 1;
        
    } else {
        [_timer invalidate];
        [self removeFromSuperview];
        [_titleLB removeFromSuperview];
        
        if (self.TimeBlock) {
            self.TimeBlock(_count);
        }
        
    }
}

@end
