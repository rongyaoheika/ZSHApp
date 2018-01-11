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

- (void)updateCellWithDataArr:(NSArray *)dataArr paramDic:(NSDictionary *)paramDic{
    [self.scrollView removeAllSubviews];
    
    ZSHButtonView *lastBtnView = nil;
    NSDictionary *titleLabelDic = @{@"text":@"2.4.6.8娱乐吧",@"font":kPingFangRegular(12),@"textAlignment":@(NSTextAlignmentCenter)};
    int i = 0;
    for (NSDictionary *subParamDic in dataArr) {
        ZSHButtonView *btnView = [[ZSHButtonView alloc]initWithFrame:CGRectZero paramDic:titleLabelDic];
        btnView.tag = i++;
        [btnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnViewAction:)]];
        if ([paramDic[KFromClassType]integerValue] == FromHomeNoticeVCToNoticeView) {
            btnView.label.text = subParamDic[@"SHOPNAME"];
            [btnView.imageView sd_setImageWithURL:[NSURL URLWithString:subParamDic[@"IMAGES"]]];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(95));
            }];
        } else if ([paramDic[KFromClassType]integerValue] == FromHomeServiceVCToNoticeView) {
            btnView.label.text = subParamDic[@"SERVICETYPE"];
            [btnView.imageView sd_setImageWithURL:[NSURL URLWithString:subParamDic[@"SERVICEIMGS"]]];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(130));
            }];
        } else if ([paramDic[KFromClassType]integerValue] == FromHomeMusicVCToNoticeView) {
            btnView.label.text = subParamDic[@"MUSICTYPE"];
            [btnView.imageView sd_setImageWithURL:[NSURL URLWithString:subParamDic[@"MUSICIMAGE"]]];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(130));
            }];
        } else if ([paramDic[KFromClassType]integerValue] == FromHomeMagazineVCToNoticeView) {
            btnView.showLabel = NO;
            [btnView.imageView sd_setImageWithURL:[NSURL URLWithString:subParamDic[@"SHOWIMG"]]];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(95));
            }];
        } else if ([paramDic[KFromClassType]integerValue] == FromMusicMenuToNoticeView) {
            btnView.label.text = subParamDic[@"imageTitle"];
            [btnView.imageView setImage:[UIImage imageNamed:subParamDic[@"imageName"]]];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(120));
            }];
        } else if ([paramDic[KFromClassType]integerValue] == FromMusicLibraryToNoticeView) {
            btnView.showLabel = NO;
            [btnView.imageView setImage:[UIImage imageNamed:subParamDic[@"imageName"]]];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(120));
            }];
        } else if ([paramDic[KFromClassType]integerValue] == FromMusicRankToNoticeView) {
            btnView.showLabel = NO;
            [btnView.imageView setImage:[UIImage imageNamed:subParamDic[@"imageName"]]];
            [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRealValue(110));
            }];
        }
        
        [_scrollView addSubview:btnView];
        
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
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
