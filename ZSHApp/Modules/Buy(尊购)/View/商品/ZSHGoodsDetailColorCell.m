//
//  ZSHGoodsDetailColorCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailColorCell.h"

@interface ZSHGoodsDetailColorCell()

@property (nonatomic,strong)  NSMutableArray  *btnArr;

@end


@implementation ZSHGoodsDetailColorCell

#pragma mark - UI
- (void)setup
{
    _btnArr = [[NSMutableArray alloc]init];
     NSDictionary *titleLabelDic = @{@"text":@"颜色分类",@"font":kPingFangRegular(15),@"textColor":KZSHColor929292,@"textAlignment":@(NSTextAlignmentLeft)};
    UILabel *titleLabel = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(15));
        make.width.mas_equalTo(kRealValue(65));
    }];
    NSArray *colorArr = @[KWhiteColor,[UIColor colorWithHexString:@"0072CA"],[UIColor colorWithHexString:@"FFCB3C"],[UIColor colorWithHexString:@"232323"]];
    for (int i = 0; i<4; i++) {
        UIButton *colorBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        colorBtn.tag = i+1;
        colorBtn.layer.cornerRadius = kRealValue(20)/2;
        [colorBtn setBackgroundColor:colorArr[i]];
        [colorBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:colorBtn];
        [colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kRealValue(20), kRealValue(20)));
            make.left.mas_equalTo(titleLabel.mas_right).offset(kRealValue(55)+i*(kRealValue(20)+kRealValue(10)));
            make.centerY.mas_equalTo(self);
        }];
        [_btnArr addObject:colorBtn];
    }
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma
- (void)colorBtnClick:(UIButton *)colorBtn{
    [_btnArr enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag == colorBtn.tag) {
            btn.selected = YES;
            UIImage *image = [UIImage imageNamed:@"goods_color_selected"];
            UIImageView *selectedImageView = [[UIImageView alloc]initWithImage:image];
            selectedImageView.backgroundColor = [UIColor redColor];
            selectedImageView.tag = 11;
            selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
            [colorBtn addSubview:selectedImageView];
            [colorBtn bringSubviewToFront:selectedImageView];
            [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(20));
                make.height.mas_equalTo(kRealValue(20));
                make.centerX.mas_equalTo(colorBtn);
                make.centerY.mas_equalTo(colorBtn);
            }];
        } else {
            btn.selected = NO;
            for (UIView *subView in colorBtn.subviews) {
                if (subView.tag == 11) {
                    [subView removeFromSuperview];
                }
            }
        }
    }];
    
}


@end
