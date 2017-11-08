//
//  ZSHClassCategoryCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHClassCategoryCell.h"
#import "ZSHClassGoodsModel.h"

@interface ZSHClassCategoryCell()

/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 指示View */
@property (strong , nonatomic)UIView *indicatorView;

@end


@implementation ZSHClassCategoryCell

- (void)setup{
    NSDictionary *titleLabelDic = @{@"text":@"名物",@"font":kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    _titleLabel.font = kPingFangRegular(15);
    [self.contentView addSubview:_titleLabel];
    
    _indicatorView = [[UIView alloc] init];
    _indicatorView.hidden = NO;
    _indicatorView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_indicatorView];
    
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(5);
    }];
}

#pragma mark - cell点击
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _indicatorView.hidden = NO;
        _titleLabel.textColor = KZSHColor929292;;
        self.backgroundColor = [UIColor colorWithHexString:@"141414"];
    }else{
        _indicatorView.hidden = YES;
        _titleLabel.textColor = KZSHColor929292;
        self.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Setter Getter Methods
- (void)setTitleItem:(ZSHClassGoodsModel *)titleItem
{
    _titleItem = titleItem;
    self.titleLabel.text = titleItem.title;
}

@end
