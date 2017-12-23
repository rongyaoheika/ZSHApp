//
//  GYZCityHeaderView.m
//  GYZChooseCityDemo
//
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import "GYZCityHeaderView.h"

@implementation GYZCityHeaderView
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = KZSHColor141414;
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel setFrame:CGRectMake(KLeftMargin, 0, kScreenWidth - 10, self.frame.size.height)];
}
#pragma mark - Getter
- (UILabel *) titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:kPingFangMedium(15)];
        [_titleLabel setTextColor:KZSHColor929292];
    }
    return _titleLabel;
}
@end
