//
//  ZSHFindArticleCell.m
//  ZSHApp
//
//  Created by apple on 2017/11/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFindArticleCell.h"
#import "ZSHFindModel.h"

@interface ZSHFindArticleCell()

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIImageView   *picView;
@property (nonatomic, strong) UILabel       *pageviewLabel;



@end

@implementation ZSHFindArticleCell

- (void)setup {
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"",@"font":kPingFangMedium(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    _titleLabel.numberOfLines = 0;
    _titleLabel.contentMode = UIViewContentModeTop;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(220), kRealValue(44)));
    }];
    
    _picView = [[UIImageView alloc] init];
    [self addSubview:_picView];
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(7.5));
        make.trailing.mas_equalTo(self).offset(kRealValue(-KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(kRealValue(115), kRealValue(90)));
    }];
    
    _pageviewLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"2.2万人浏览",@"font":kPingFangMedium(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self addSubview:_pageviewLabel];
    [_pageviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_picView);
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-kRealValue(70), kRealValue(16)));
    }];
    
}

- (void)updateCellWithModel:(ZSHFindModel *)model {
    _titleLabel.text = model.TITLE;
    [_picView sd_setImageWithURL:[NSURL URLWithString:model.VIDEOBACKIMAGE.firstObject]];
    
    if ([model.DIS_TYPE isEqualToString:@"2002"]) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(KScreenWidth-30, 44));
        }];
    } else {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealValue(220), 44));
        }];
    }
    _pageviewLabel.text = NSStringFormat(@"%@人浏览", model.PAGEVIEWS);
}

@end



@interface ZSHFindThreePics()

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *pageviewLabel;

@end

@implementation ZSHFindThreePics

- (void)setup {
    _titleLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"",@"font":kPingFangMedium(14),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    _titleLabel.numberOfLines = 0;
    _titleLabel.contentMode = UIViewContentModeTop;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kRealValue(-3));
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-30, 44));
    }];
    
    CGFloat space = (KScreenWidth - 30 - 100*3)/2;
    for (int i = 0; i < 4; i++) {
        UIImageView *picView = [[UIImageView alloc] init];
        picView.tag = i+18011513;
        [self addSubview:picView];
        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(kRealValue(-8));
            make.left.mas_equalTo(self).offset(KLeftMargin+i*(100+space));
            make.size.mas_equalTo(CGSizeMake(kRealValue(100), kRealValue(80)));
        }];
    }
    
    _pageviewLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"2.2万人浏览",@"font":kPingFangMedium(11),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)}];
    [self addSubview:_pageviewLabel];
    [_pageviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(kRealValue(8));
        make.left.mas_equalTo(self).offset(kRealValue(KLeftMargin));
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-kRealValue(70), kRealValue(16)));
    }];

}

- (void)updateCellWithModel:(ZSHFindModel *)model {
    _titleLabel.text = model.TITLE;
    for (int i = 0; i < model.VIDEOBACKIMAGE.count; i++) {
        UIImageView *imageView = [self viewWithTag:i+18011513];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.VIDEOBACKIMAGE[i]]];
    }
    for (NSInteger j = model.VIDEOBACKIMAGE.count; j < 4; j++) {
        UIImageView *imageView = [self viewWithTag:j+18011513];
        [imageView setImage:[UIImage new]];
    }
    _pageviewLabel.text = NSStringFormat(@"%@人浏览", model.PAGEVIEWS);
}

@end
