//
//  ZSHBlackCardPhoneNumView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBlackCardPhoneNumView.h"
#import "ZSHPhoneNumListView.h"

@interface ZSHBlackCardPhoneNumView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray                   *titleArr;
@property (nonatomic, strong) UISegmentedControl        *seg;
@property (nonatomic, strong) UIScrollView              *blackCardScrollView;

@end

@implementation ZSHBlackCardPhoneNumView

#pragma getter
- (void)setup{
    _titleArr = @[@"300元",@"600元",@"1000元",@"5000元",@"10000元"];
    [self addSubview:self.seg];
    [self addSubview:self.blackCardScrollView];
    for (int i = 0; i<_titleArr.count; i++) {
        [self.blackCardScrollView addSubview:[self createPhoneNumListView]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(kRealValue(22));
        make.right.mas_equalTo(self).offset(-kRealValue(22));
        make.height.mas_equalTo(kRealValue(25));
    }];
    
    NSInteger count = _titleArr.count;
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    _blackCardScrollView.contentSize = CGSizeMake(count*KScreenWidth, viewHeight- kRealValue(33));
    [_blackCardScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_seg.mas_bottom).offset(kRealValue(18));
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(viewHeight- kRealValue(33));
    }];
    
    int i = 0;
    for (ZSHPhoneNumListView *numListView in self.blackCardScrollView.subviews) {
        [numListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_blackCardScrollView).offset(KScreenWidth*i);
            make.top.mas_equalTo(_blackCardScrollView);
            make.height.mas_equalTo(kRealValue(150));
            make.width.mas_equalTo(KScreenWidth);
        }];
        i++;
    }
    
}

- (UIScrollView *)blackCardScrollView{
    if (!_blackCardScrollView) {
        _blackCardScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _blackCardScrollView.scrollsToTop = NO;
        _blackCardScrollView.scrollEnabled = YES;
        _blackCardScrollView.pagingEnabled = YES;
        _blackCardScrollView.delegate = self;
        _blackCardScrollView.showsHorizontalScrollIndicator = NO;
        _blackCardScrollView.showsVerticalScrollIndicator = NO;
    }
    return _blackCardScrollView;
}

- (UISegmentedControl *)seg{
    if (!_seg) {
        _seg = [[UISegmentedControl alloc]initWithItems:_titleArr];
        _seg.frame = CGRectZero;
        _seg.selectedSegmentIndex = 0;
        [_seg addTarget:self action:@selector(selectChanged:) forControlEvents:UIControlEventValueChanged];
        _seg.tintColor = KZSHColor929292;
        [_seg setTitleTextAttributes:@{NSForegroundColorAttributeName:KZSHColorF29E19,NSFontAttributeName:kPingFangRegular(11)} forState:UIControlStateSelected];
        [_seg setTitleTextAttributes:@{NSForegroundColorAttributeName:KZSHColor929292,NSFontAttributeName:kPingFangRegular(11)} forState:UIControlStateNormal];
        
    }
    return _seg;
}

- (ZSHPhoneNumListView *)createPhoneNumListView{
    NSArray *titleArr = @[@"1035686866",@"1035686866",@"1035686866",@"1035686866",@"11035686866",@"1035686866",@"1035686866",@"1035686866",];
    NSDictionary *nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"phone_normal",@"selectedImage":@"phone_press"};
    ZSHPhoneNumListView *listView = [[ZSHPhoneNumListView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    return listView;
}

#pragma action

- (void)selectChanged:(UISegmentedControl*)s{
    RLog(@"点击了");
    [self.blackCardScrollView setContentOffset:CGPointMake(s.selectedSegmentIndex * KScreenWidth, 0) animated:YES];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger tag = scrollView.contentOffset.x/kScreenWidth;
    [self.seg setSelectedSegmentIndex:tag];
}

@end
