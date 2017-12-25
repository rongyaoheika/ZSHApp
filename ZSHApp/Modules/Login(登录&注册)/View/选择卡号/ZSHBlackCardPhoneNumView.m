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
#import "ZSHLoginLogic.h"
#import "ZSHCardNumModel.h"

@interface ZSHBlackCardPhoneNumView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray                   *titleArr;
@property (nonatomic, strong) UIImageView               *bgIV;
@property (nonatomic, strong) LXScollTitleView          *titleView;
@property (nonatomic, strong) UIScrollView              *blackCardScrollView;

@property (nonatomic, strong) ZSHLoginLogic             *loginLogic;
@property (nonatomic, strong) NSArray                   *cardNumArr;

@end

@implementation ZSHBlackCardPhoneNumView

#pragma getter
- (void)setup{
    _titleArr = @[@"300元",@"600元",@"1000元",@"5000元",@"10000元"];
    [self addSubview:self.titleView];
    
    _bgIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seg_five_bg_normal"]];
    [_titleView addSubview:_bgIV];
    
    [self.titleView reloadViewWithTitles:_titleArr];
    
    [self addSubview:self.blackCardScrollView];
    for (int i = 0; i<_titleArr.count; i++) {
        ZSHPhoneNumListView *listView =[self createPhoneNumListView:NSStringFormat(@"5")];
        [self.blackCardScrollView addSubview:listView];
    }
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.width.mas_equalTo(kRealValue(298));
        make.left.mas_equalTo((KScreenWidth- kRealValue(298))/2);
        make.height.mas_equalTo(kRealValue(30));
    }];
    [_bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_titleView);
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
    
//     [self requestData];
}


- (void)updateConstraints {
    [super updateConstraints];
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
        [numListView mas_remakeConstraints:^(MASConstraintMaker *make) {
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

- (ZSHPhoneNumListView *)createPhoneNumListView:(NSString *)cardType{
    NSArray *titleArr = @[@"ab1035686866",@"1035686866",@"1035686866",@"1035686866",@"11035686866",@"1035686866",@"1035686866",@"1035686866",];
    NSDictionary *nextParamDic = @{@"titleArr":titleArr,@"normalImage":@"phone_normal",@"selectedImage":@"phone_press", @"type":cardType};
    ZSHPhoneNumListView *listView = [[ZSHPhoneNumListView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kRealValue(150)) paramDic:nextParamDic];
    return listView;
}

#pragma getter
- (LXScollTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(0, 0, kRealValue(298), kRealValue(30))];
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
        _titleView.titleWidth = kRealValue(60);
    }
    return _titleView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    self.titleView.selectedIndex = index;
}


- (void)updateViewWithData {
    
}

- (void)requestData {
    //（1 自选号码库 2 贵宾号码库 3 金钻号码库 4荣耀号码库 5 超级黑卡靓号号码库）
    kWeakSelf(self);
    [_loginLogic requestCardNumWithDic:@{@"CARDTYPE_ID":self.paramDic[@"type"]} success:^(id response) {
        weakself.cardNumArr = [ZSHCardNumModel mj_objectArrayWithKeyValuesArray:response[@"pd"]];
        [weakself updateViewWithData];
    }];
}


@end
