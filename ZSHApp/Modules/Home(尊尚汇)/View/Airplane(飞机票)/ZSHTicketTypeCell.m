//
//  ZSHTicketTypeCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTicketTypeCell.h"

@interface ZSHTicketTypeCell ()

@property (nonatomic, strong) UIButton      *leftBtn;
@property (nonatomic, strong) UIButton      *rightBtn;

@end

@implementation ZSHTicketTypeCell

- (void)setup{
    
    NSDictionary *childBtnDic = @{@"title":@"携带儿童",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"airplane_press"};
    _leftBtn = [ZSHBaseUIControl createBtnWithParamDic:childBtnDic];
    [self.contentView addSubview:_leftBtn];
    
    NSDictionary *rightBtnDic = @{@"title":@"只看高铁／动车",@"font":kPingFangRegular(12),@"withImage":@(YES),@"normalImage":@"airplane_press"};
    _rightBtn = [ZSHBaseUIControl createBtnWithParamDic:childBtnDic];
    [self.contentView addSubview:_leftBtn];
    

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(KLeftMargin);
        make.height.mas_equalTo(self).offset(KLeftMargin);
        make.width.mas_equalTo(kRealValue(65));
        make.top.mas_equalTo(self);
    }];
    
     [_leftBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(5)];
}

@end
