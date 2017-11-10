//
//  ZSHBaseCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

@interface ZSHBaseCell()

@property (nonatomic, strong) UIImageView *arrowImage;
@end

@implementation ZSHBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = kPingFangRegular(15);
        self.textLabel.textColor = KZSHColor929292;
        self.detailTextLabel.font = kPingFangRegular(12);
        self.detailTextLabel.textColor = KZSHColor929292;
        self.backgroundColor = KClearColor;
        
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.arrowImageName) {
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-kRealValue(35));
            make.height.mas_equalTo(self);
            make.top.mas_equalTo(self);
        }];
    }
}

//加载UI
- (void)setup{
    
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        [self.contentView addSubview:self.arrowImage];
       
         UIImage *image = [UIImage imageNamed:self.arrowImageName];
         [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-kRealValue(15));
            make.size.mas_equalTo(image.size);
            make.centerY.mas_equalTo(self);
        }];
    }
}

+ (CGFloat)getCellHeightWithModel:(ZSHBaseModel *)model{
    return 30;
}

//更新cell内容
- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
}

- (void)updateCellWithModel:(ZSHBaseModel *)model{
    
}

- (void)setModel:(ZSHBaseModel *)model{
    
}

#pragma getter
- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        self.arrowImageName = (self.arrowImageName?self.arrowImageName:@"mine_next");
        UIImage *image = [UIImage imageNamed:self.arrowImageName];
        _arrowImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImage.image = image;
    }
    return _arrowImage;
}

@end
