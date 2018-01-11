//
//  ZSHCabinetHeadReusableView.m
//  ZSHApp
//
//  Created by mac on 11/01/2018.
//  Copyright © 2018 apple. All rights reserved.
//

#import "ZSHCabinetHeadReusableView.h"

@implementation ZSHCabinetHeadReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CabinetHead"]];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self);
            make.height.mas_equalTo(165);
        }];
        
        _contentLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"font":kPingFangMedium(12)}];
        _contentLabel.numberOfLines = 0;
        NSString *string = @"3月1日-3月15日期间，环球黑卡携手GUCCI旗舰店、BURBERRY旗舰店，用户购买旗舰店任何商品，在线购买将获得3%返点，线上下单到店自提顾客返5%！详情请咨询在线客服";
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        NSMutableAttributedString *setString = [[NSMutableAttributedString alloc] initWithString:string];
        [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        CGSize detailLabelSize = [string boundingRectWithSize:CGSizeMake(kScreenWidth-kRealValue(30), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
        [_contentLabel setAttributedText:setString];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KLeftMargin);
            make.top.mas_equalTo(_imageView.mas_bottom).offset(KLeftMargin);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-kRealValue(30), detailLabelSize.height));
        }];
        
        _headLabel = [ZSHBaseUIControl createLabelWithParamDic:@{@"text":@"GUCCI 旗舰店", @"font":kPingFangMedium(15),@"textAlignment":@(NSTextAlignmentCenter)}];
        [self addSubview:_headLabel];
        [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(-17);
            make.height.mas_equalTo(16);
        }];
    }
    return self;
}
@end
