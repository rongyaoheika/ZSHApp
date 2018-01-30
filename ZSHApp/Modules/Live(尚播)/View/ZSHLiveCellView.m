//
//  ZSHLiveCellView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveCellView.h"
#import "ZSHLiveListModel.h"

@interface ZSHLiveCellView()

@property (nonatomic, strong)UIView         *bottomLoveView;
@property (nonatomic, strong)UILabel        *nameLabel;
@property (nonatomic, strong)UIImageView    *bgImage;
@property (nonatomic, strong)UIButton       *loveBtn;

@end

@implementation ZSHLiveCellView

- (void)setup{
    _bottomLoveView = [[UIView alloc]init];
    [self addSubview:_bottomLoveView];
    
     NSDictionary *nameLabelDic = @{@"text":@"夏天",@"font":kPingFangMedium(12),@"textColor":KWhiteColor,@"textAlignment":@(NSTextAlignmentLeft)};
    _nameLabel = [ZSHBaseUIControl createLabelWithParamDic:nameLabelDic];
    [_bottomLoveView addSubview:_nameLabel];
    
    _loveBtn = [[UIButton alloc]init];
    [_loveBtn setImage:[UIImage imageNamed:@"live_love_normal"] forState:UIControlStateNormal];
    [_loveBtn setImage:[UIImage imageNamed:@"live_love_press"] forState:UIControlStateSelected];
    [_loveBtn setTitle:@"234" forState:UIControlStateNormal];
    [_loveBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
    _loveBtn.titleLabel.font = kPingFangLight(12);
    [_loveBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:-kRealValue(25)];
    [_loveBtn addTarget:self action:@selector(loveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomLoveView addSubview:_loveBtn];

    _bgImage = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:_bgImage];
}

#pragma action
- (void)loveBtnAction:(UIButton *)loveBtn{
    
    loveBtn.selected = !loveBtn.selected;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_bottomLoveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(22));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomLoveView).offset(kRealValue(4));
        make.width.mas_equalTo(kRealValue(90));
        make.height.mas_equalTo(kRealValue(12));
        make.centerY.mas_equalTo(_bottomLoveView);
    }];
    
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bottomLoveView).offset(-kRealValue(10));
        make.width.mas_equalTo(kRealValue(50));
        make.height.mas_equalTo(kRealValue(12));
        make.centerY.mas_equalTo(_nameLabel);
    }];
    [_loveBtn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleLeft imageTitleSpace:kRealValue(10)];
    
    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(_bottomLoveView.mas_top).offset(-kRealValue(10));
    }];
}

- (void)updateCellWithModel:(ZSHLiveListModel *)model{

    [self.loveBtn setTitle:[NSString stringWithFormat:@"%ld",[model.UserNumber integerValue]]  forState:UIControlStateNormal];
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.LiveCover]];
    self.nameLabel.text = model.LiveTitle;
    
}

@end
