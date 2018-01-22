//
//  ZSHCreateStoreGuideView.m
//  ZSHApp
//
//  Created by mac on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHCreateStoreGuideView.h"

#define contentW kRealValue(240)


@interface ZSHCreateStoreGuideView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView       *popView;

@property (nonatomic, strong) UIScrollView      *titleScrollView;
@property (nonatomic, strong) UIPageControl     *pageControl;
@property (nonatomic, strong) UILabel           *titleLB;
@property (nonatomic, strong) UIButton          *nextBtn;

@end

@implementation ZSHCreateStoreGuideView

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    //弹框
    _popView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"popup_image"]];
    _popView.userInteractionEnabled = YES;
    _popView.tag = 2;
    [self addSubview:_popView];
    [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(contentW, kRealValue(317)));
        make.center.mas_equalTo(self);
    }];
    
    //创建门店
    NSDictionary *titleLBDic = @{@"text":@"创建门店",@"font":kPingFangMedium(20),@"textAlignment":@(NSTextAlignmentCenter)};
    UILabel *titleLB = [ZSHBaseUIControl createLabelWithParamDic:titleLBDic];
    [_popView addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_popView);
        make.width.mas_equalTo(_popView);
        make.top.mas_equalTo(_popView).offset(kRealValue(85));
        make.height.mas_equalTo(kRealValue(20));
    }];
    self.titleLB = titleLB;
    
    //滑动字体
    self.titleScrollView.contentSize = CGSizeMake(3*kRealValue(240), 0);
    [_popView addSubview:self.titleScrollView];
    [self.titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(contentW, kRealValue(120)));
        make.top.mas_equalTo(titleLB.mas_bottom).offset(kRealValue(30));
        make.left.mas_equalTo(_popView);
    }];
    
    NSArray *contentArr = @[
  @[@"1、 填写门店名称",@"2、填写门店详细地址",@"3、填写门店电话"],
  @[@"1、 填写联系人及联系方式",@"2、上传联系人身份证件",@"3、上传店铺照片及店铺照片"],
  @[@"提交资质后3-5个工作日审核完成",@"",@""]
  ];
    
    NSDictionary *titleLabelDic = @{@"text":@"",@"font":kPingFangRegular(12)};
    for (int i = 0; i<3; i++) {
        for (int j = 0; j<3; j++) {
            UILabel *contentLB = [ZSHBaseUIControl createLabelWithParamDic:titleLabelDic];
            contentLB.frame = CGRectMake(kRealValue(25)+i*contentW, j*(kRealValue(12)+kRealValue(22.5)), contentW, kRealValue(12));
            contentLB.text = contentArr[i][j];
            [self.titleScrollView addSubview:contentLB];
        }
        
    }
    
    //下一步按钮
    NSDictionary *nextBtnDic = @{@"title":@"下一步",@"font":kPingFangMedium(15)};
    UIButton *nextBtn = [ZSHBaseUIControl createBtnWithParamDic:nextBtnDic];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.borderColor = KZSHColor929292.CGColor;
    nextBtn.layer.borderWidth = 0.5;
    nextBtn.layer.cornerRadius = 2.5;
    [_popView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_popView).offset(-kRealValue(20));
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.centerX.mas_equalTo(_popView);
    }];
    self.nextBtn = nextBtn;
    
    //page
    [_popView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(nextBtn.mas_top).offset(kRealValue(10));
        make.centerX.mas_equalTo(_popView);
        make.width.mas_equalTo(_popView);
    }];
    
    
    //关闭按钮
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"popup_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePopview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_bottom).offset(kRealValue(25));
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.mas_equalTo(self);
    }];

    
}

#pragma mark <UIScrollViewDelegate>
//手动滑动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) return;
    [self dealPageEnableWithScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self dealPageEnableWithScrollView:scrollView];
}

#pragma mark 处理scrollView翻页效果
- (void)dealPageEnableWithScrollView:(UIScrollView *)scrollView{
    NSInteger page = (NSInteger)(fabs((scrollView.contentOffset.x/contentW))+0.5);
    
    if (page == 2) {
        [self.nextBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        self.titleLB.text = @"资质审核";
    } else {
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.titleLB.text = @"创建门店";
    }
    self.pageControl.currentPage = page;
    [UIView animateWithDuration:0.5 animations:^{
        [scrollView setContentOffset:CGPointMake(contentW * page,0)];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)nextBtnAction{
    NSInteger page = self.pageControl.currentPage;
    NSInteger nextPage = page+1;
    RLog(@"self.pageControl.currentPage == %ld",page);
    if (nextPage >= 3) {
        return;
    } else {
        [self.titleScrollView setContentOffset:CGPointMake(contentW * nextPage,0)];
        self.pageControl.currentPage = nextPage;
    }
}

- (void)closePopview{
    [ZSHBaseUIControl setAnimationWithHidden:YES view:self completedBlock:nil];
}

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc]init];
        _titleScrollView.pagingEnabled = YES;
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.delegate = self;
    }
    return _titleScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = KZSHColor1A1A1A;
        _pageControl.pageIndicatorTintColor = KZSHColorD8D8D8;
    }
    return _pageControl;
}

@end
