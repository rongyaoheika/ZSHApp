//
//  ZSHEnergyHeadCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEnergyHeadCell.h"
#import "ZSHNotCycleScrollView.h"

@interface ZSHEnergyHeadCell()

@property (nonatomic, strong) ZSHNotCycleScrollView     *itemScrollView;
@property (nonatomic, strong) UIImageView               *bgImageView;
@property (nonatomic ,strong) NSMutableArray            *btnArr;

@end

@implementation ZSHEnergyHeadCell

- (void)setup{
    UIImage *bgImage = [UIImage imageNamed:@"mine_energy_bg"];
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _bgImageView.image = bgImage;
    [self.contentView addSubview:_bgImageView];
    
    kWeakSelf(self);
    [self.contentView addSubview:self.itemScrollView];
    self.itemScrollView.selectedBlock = ^(NSInteger index){
        if (weakself.itemClickBlock) {
            weakself.itemClickBlock(index);
        }
    };
    
    _btnArr = [[NSMutableArray alloc]init];
    NSArray *topTitleArr = @[@"99",@"99",@"99",@"99",@"99"];
    NSArray *bottomTitleArr = @[@"购物分",@"活动分",@"互动分",@"基础分",@"荣耀分"];
    NSArray *colorArr = @[[UIColor colorWithHexString:@"D48B32"],[UIColor colorWithHexString:@"4B70C5"],[UIColor colorWithHexString:@"E34C4C"],[UIColor colorWithHexString:@"EBE758"],[UIColor colorWithHexString:@"69E2D3"]];
    _itemScrollView.fromClassType = FromEnergyValueVCToNoticeView;
    for (int i = 0; i<topTitleArr.count; i++) {
        NSDictionary *topTitleDic = @{@"text":topTitleArr[i],@"font":kPingFangMedium(30),@"textColor":colorArr[i], @"height":@(40),@"textAlignment":@(NSTextAlignmentCenter)};
        NSDictionary *bottomTitleDic = @{@"text":bottomTitleArr[i], @"font":kPingFangRegular(14),@"textColor":colorArr[i],@"height":@(30),@"textAlignment":@(NSTextAlignmentCenter)};
        UIButton *labelBtn = [ZSHBaseUIControl createLabelBtnWithTopDic:topTitleDic bottomDic:bottomTitleDic];
        [_btnArr addObject:labelBtn];
    }
    
    [self.itemScrollView reloadViewWithDataArr:_btnArr];
}

- (void)layoutSubviews{
    [super layoutSubviews];

     UIImage *bgImage = [UIImage imageNamed:@"mine_energy_bg"];
    _bgImageView.frame = CGRectMake(0, 0, bgImage.size.width,bgImage.size.height);
    
    [_itemScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(kRealValue(20));
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(KScreenWidth);
        make.bottom.mas_equalTo(self);
    }];
}

#pragma getter
- (ZSHNotCycleScrollView *)itemScrollView{
    if (!_itemScrollView) {
        _itemScrollView = [[ZSHNotCycleScrollView alloc] init];
        _itemScrollView.selectedColor = KClearColor;
        _itemScrollView.indicatorHeight = 0.0;
        _itemScrollView.itemWidth = kRealValue(108);
    }
    return _itemScrollView;
}

@end
