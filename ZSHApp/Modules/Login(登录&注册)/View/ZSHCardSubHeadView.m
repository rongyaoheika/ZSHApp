//
//  ZSHCardSubHeadView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCardSubHeadView.h"

@interface ZSHCardSubHeadView()

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *rightBtn;
@end

@implementation ZSHCardSubHeadView

- (void)setup{
    
    NSDictionary *titleLabelDic = @{@"text":self.paramDic[@"title"],@"font":kPingFangRegular(15)};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    if ([self.paramDic[@"title"] rangeOfString:@"自选号码"].location !=NSNotFound) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.paramDic[@"title"]];
        NSRange rangel = [[str string] rangeOfString:[self.paramDic[@"title"] substringFromIndex:4]];
        [str addAttribute:NSFontAttributeName value:kPingFangLight(11) range:rangel];
        [_titleLabel setAttributedText:str];
    }
    [self addSubview:_titleLabel];
    
    NSDictionary *rightBtnDic = @{@"title":self.paramDic[@"btnTitle"],@"font":kPingFangLight(11)};
    _rightBtn = [ZSHBaseUIControl createBtnWithParamDic:rightBtnDic];
    _rightBtn.tag = [self.paramDic[@"tag"]integerValue];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];
    
    if (kFromClassTypeValue == FromCustomizedCellToCardSubHeadView) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.paramDic[@"btnTitle"]];
        [str addAttribute:NSForegroundColorAttributeName value:KZSHColorF29E19 range:NSMakeRange(0,1)];
        [_rightBtn setAttributedTitle:str forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        
    } else if (kFromClassTypeValue == FromCardNumCellToCardSubHeadView){
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"refresh_normal"] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kRealValue(12));
        make.height.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(kScreenWidth*0.7);
    }];
    
    if (kFromClassTypeValue == FromCustomizedCellToCardSubHeadView) {
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-kRealValue(12));
            make.height.mas_equalTo(self);
            make.top.mas_equalTo(self);
            make.width.mas_equalTo(kRealValue(50));
        }];
         [_rightBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(3)];
    } else if (kFromClassTypeValue == FromCardNumCellToCardSubHeadView){
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-kRealValue(18));
            make.height.mas_equalTo(kRealValue(18));
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(kRealValue(50));
        }];
    }
}

- (void)rightBtnAction:(UIButton *)rightBtn{
    rightBtn.selected = !rightBtn.selected;
    if (rightBtn.selected) {
         [self changeButtonObject:rightBtn TransformAngle:M_PI];
    } else {
        [self changeButtonObject:rightBtn TransformAngle:0];
    }
    if (self.rightBtnActionBlock) {
        self.rightBtnActionBlock(rightBtn.tag);
    }
}

-(void)changeButtonObject:(UIButton *)button TransformAngle:(CGFloat)angle{
    [UIView animateWithDuration:0.5 animations:^{
        button.imageView.transform =CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
    }];
    
}



@end
