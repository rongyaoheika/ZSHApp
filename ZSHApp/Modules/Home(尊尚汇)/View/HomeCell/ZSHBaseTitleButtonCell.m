//
//  ZSHBaseTitleButtonCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseTitleButtonCell.h"
#import "ZSHButtonView.h"
#import "ZSHHomeMainModel.h"

@interface ZSHBaseTitleButtonCell()<UIScrollViewDelegate>

@property (nonatomic,strong)  UIScrollView       *scrollView;
@property (nonatomic ,strong) NSMutableArray     *btnArr;

@end

@implementation ZSHBaseTitleButtonCell

- (void)setup{
    [self.contentView addSubview:self.scrollView];
}

- (void)updateCellWithDataArr:(NSArray *)dataArr{
    ZSHButtonView *lastBtnView = nil;
    int i = 0;
    for (ZSHHomeMainModel *homeMainModel in dataArr) {
        ZSHButtonView *btnView = [[ZSHButtonView alloc]init];
        btnView.tag = i++;
        [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnViewAction:)]];
        btnView.label.text = homeMainModel.SHOPNAME;
        [btnView.imageView sd_setImageWithURL:[NSURL URLWithString:homeMainModel.IMAGES]];
        [_scrollView addSubview:btnView];
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
            make.width.mas_equalTo(kRealValue(95));
            if (lastBtnView) {
                make.left.mas_equalTo(lastBtnView.mas_right).offset(kRealValue(8));
            } else {
                make.left.mas_equalTo(_scrollView).offset(KLeftMargin);
            }
        }];

        lastBtnView = btnView;
    }
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.right.mas_equalTo(lastBtnView).offset(KLeftMargin);
        make.bottom.mas_equalTo(lastBtnView);
    }];
    
}

#pragma getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (void)btnViewAction:(UITapGestureRecognizer *)gesture{
    
    if (self.itemClickBlock) {
        self.itemClickBlock(gesture.view.tag);
    }
    
}
@end
