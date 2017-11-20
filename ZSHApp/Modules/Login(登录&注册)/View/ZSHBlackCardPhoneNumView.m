//
//  ZSHBlackCardPhoneNumView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBlackCardPhoneNumView.h"
#import "ZSHPhoneNumListView.h"
#import "LXScollTitleView.h"

@interface ZSHBlackCardPhoneNumView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray                   *titleArr;
@property (nonatomic, strong) LXScollTitleView          *titleView;
//@property (nonatomic, strong) UISegmentedControl        *seg;
@property (nonatomic, strong) UIScrollView              *blackCardScrollView;

@end

@implementation ZSHBlackCardPhoneNumView

#pragma getter
- (void)setup{
    NSArray  *btnTitleArr = @[@"300元",@"600元",@"1000元",@"5000元",@"10000元"];
    [self addSubview:self.titleView];
    [self.titleView reloadViewWithTitles:btnTitleArr];
    
    [self addSubview:self.blackCardScrollView];
    for (int i = 0; i<btnTitleArr.count; i++) {
        [self.blackCardScrollView addSubview:[self createPhoneNumListView]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(298));
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(kRealValue(30));
    }];
    
    int i = 0;
    for (UIButton *btn in _titleView.titleButtons) {
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleView).mas_equalTo(kRealValue(59.5)*i);
            make.size.mas_equalTo(CGSizeMake(kRealValue(60), kRealValue(30)));
            make.top.mas_equalTo(_titleView);
        }];
        i++;
    }
    
    NSInteger count = _titleArr.count;
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    _blackCardScrollView.contentSize = CGSizeMake(count*KScreenWidth, viewHeight- kRealValue(33));
    [_blackCardScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleView.mas_bottom).offset(kRealValue(18));
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(viewHeight- kRealValue(33));
    }];
    
    int j = 0;
    for (ZSHPhoneNumListView *numListView in self.blackCardScrollView.subviews) {
        [numListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_blackCardScrollView).offset(KScreenWidth*j);
            make.top.mas_equalTo(_blackCardScrollView);
            make.height.mas_equalTo(kRealValue(150));
            make.width.mas_equalTo(KScreenWidth);
        }];
        j++;
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

- (ZSHPhoneNumListView *)createPhoneNumListView{
    NSArray *titleArr = @[@"1035686866",@"1035686866",@"1035686866",@"1035686866",@"11035686866",@"1035686866",@"1035686866",@"1035686866",];
    NSDictionary *nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"phone_normal",@"selectedImage":@"phone_press"};
    ZSHPhoneNumListView *listView = [[ZSHPhoneNumListView alloc]initWithFrame:CGRectZero paramDic:nextParamDic];
    return listView;
}

#pragma action

#pragma getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, (kScreenWidth-kRealValue(298))/2, kRealValue(298), kRealValue(30))];
        _titleView.selectedBgImage = [UIImage imageNamed:@"seg_five_bg_press"];
        _titleView.normalTitleFont = kPingFangRegular(11);
        _titleView.selectedTitleFont = kPingFangRegular(11);
        _titleView.selectedColor = KZSHColorF29E19;
        _titleView.normalColor = KZSHColor929292;
        _titleView.indicatorHeight = 0;
        __weak typeof(self) weakSelf = self;
        _titleView.selectedBlock = ^(NSInteger index){
            __weak typeof(self) strongSelf = weakSelf;
            [strongSelf.blackCardScrollView setContentOffset:CGPointMake(index * KScreenWidth, 0) animated:YES];
            
        };
        _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"seg_five_bg_normal"] ];
        _titleView.titleWidth = kRealValue(60);
    }
    return _titleView;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    self.titleView.selectedIndex = index;
}

@end
