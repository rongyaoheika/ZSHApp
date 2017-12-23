//
//  ZSHBaseView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/9/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

@interface ZSHBaseView()

@end

@implementation ZSHBaseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = KClearColor;
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame paramDic:(NSDictionary *)paramDic{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KClearColor;
        self.paramDic = paramDic;
        [self setup];
    }
    return self;
}

- (void)setup{

}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setModel:(ZSHBaseModel *)model{
    
}

- (void)updateViewWithParamDic:(NSDictionary *)paramDic{
    
}

- (void)updateViewWithModel:(ZSHBaseModel *)model{
    
}

@end
