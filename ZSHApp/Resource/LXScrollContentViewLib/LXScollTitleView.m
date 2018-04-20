//
//  LXScollTitleView.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXScollTitleView.h"

@interface LXScollTitleView()

@property (nonatomic, strong) NSArray             *titles;
@property (nonatomic, copy)   NSString            *imageName;
@property (nonatomic, strong) UIView              *indicatorView;

@end

@implementation LXScollTitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
//        [self setupUI];
    }
    return self;
}

- (void)initData{
    self.normalColor = KZSHColor929292;
    self.selectedColor = KZSHColorF29E19;
    self.normalTitleFont = kPingFangRegular(15);
    self.selectedTitleFont = kPingFangMedium(15);
    self.titleWidth = 85.f;
    self.indicatorHeight = 0.f;
    self.titleButtons = [[NSMutableArray alloc] init];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    if (self.titleButtons.count == 0) {
        return;
    }
    
    self.scrollView.contentSize = CGSizeEqualToSize(self.svContentSize,CGSizeZero)?CGSizeMake(self.titleButtons.count * self.titleWidth, self.frame.size.height):self.svContentSize;
    NSInteger i = 0;
    for (UIButton *btn in self.titleButtons) {
        btn.frame = CGRectMake(self.titleWidth * i++, 0, self.titleWidth, self.frame.size.height);
        [btn layoutButtonWithEdgeInsetsStyle:self.imageStyle imageTitleSpace:self.imageTitleSpace];
    }
    [self setSelectedIndicator:NO];
    [self.scrollView bringSubviewToFront:self.indicatorView];
}

- (void)reloadViewWithTitles:(NSArray *)titles {
    [self.titleButtons makeObjectsPerformSelector:@selector(removeAllObjects)];
    self.titleButtons = nil;
    NSInteger i = 0;
    for (NSString *title in titles) {
       
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        
        [btn setBackgroundImage:self.normalBgImage?self.normalBgImage:self.normalBgImageArr[i] forState:UIControlStateNormal];
        [btn setBackgroundImage:self.selectedBgImage?self.selectedBgImage:self.selectedBgImageArr[i] forState:UIControlStateSelected];
        
        //小图片可以
        [btn setImage:self.normalImage?self.normalImage:self.normalImageArr[i] forState:UIControlStateNormal];
        [btn setImage:self.selectedImage?self.selectedImage:self.selectedImageArr[i] forState:UIControlStateSelected];

        btn.titleLabel.font = btn.selected?self.selectedTitleFont:self.normalTitleFont;
        btn.tag = 100 + i++;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:btn.titleLabel.font,NSFontAttributeName,nil]];
        self.indicatorWidth = titleSize.width;
        
        [self.scrollView addSubview:btn];
        [self.titleButtons addObject:btn];
    }
    self.selectedIndex = 0;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)btnClick:(UIButton *)titleBtn{
    NSInteger btnIndex = titleBtn.tag - 100;
    self.selectedIndex = btnIndex;
    if (self.selectedBlock) {
        self.selectedBlock(btnIndex);
    }
}

-(void)updateConstraints{
    
    [super updateConstraints];
}


- (void)setSelectedIndicator:(BOOL)animated {
    self.indicatorView.backgroundColor = self.selectedColor;
    CGFloat leftW = (self.titleWidth - self.indicatorWidth)/2;
    [UIView animateWithDuration:(animated? 0.02 : 0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.indicatorView.frame = CGRectMake(leftW + (self.selectedIndex)*self.titleWidth, self.frame.size.height - self.indicatorHeight, self.indicatorWidth, self.indicatorHeight);
    } completion:^(BOOL finished) {
        [self scrollRectToVisibleCenteredOn:self.indicatorView.frame animated:YES];
    }];
}

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect animated:(BOOL)animated {
    CGRect centeredRect = CGRectMake(visibleRect.origin.x + visibleRect.size.width / 2.0 - self.scrollView.frame.size.width / 2.0,
                                     visibleRect.origin.y + visibleRect.size.height / 2.0 - self.scrollView.frame.size.height / 2.0,
                                     self.scrollView.frame.size.width,
                                     self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:centeredRect animated:animated];
}

#pragma mark - setter

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    
    [self.titleButtons enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn.tag-100 == selectedIndex) {
            btn.selected = YES;
            btn.titleLabel.font = self.selectedTitleFont;
            
            if (self.selectedBorderColor) {
                btn.layer.borderWidth = 1.0;
                btn.layer.borderColor = self.selectedBorderColor.CGColor;
            }
            
        } else {
            btn.selected = NO;
            btn.titleLabel.font = self.normalTitleFont;
            if (self.normalBorderColor) {
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = self.normalBorderColor.CGColor;
            }
        }
    }];
    
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    [self setSelectedIndicator:YES];
}

#pragma mark - getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.scrollsToTop = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)indicatorView{
    if (!_indicatorView) {
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.scrollView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (NSMutableArray<UIButton *> *)titleButtons{
    if (!_titleButtons) {
        _titleButtons = [[NSMutableArray alloc] init];
    }
    return _titleButtons;
}

#pragma mark - setter
- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
}

- (void)setTitleWidth:(CGFloat)titleWidth{
    _titleWidth = titleWidth;
    [self setNeedsLayout];
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight{
    _indicatorHeight = indicatorHeight;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setNormalTitleFont:(UIFont *)normalTitleFont{
    _normalTitleFont = normalTitleFont;
}

- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont{
    _selectedTitleFont = selectedTitleFont;
}

- (void)setIndicatorWidth:(CGFloat)indicatorWidth{
    _indicatorWidth = indicatorWidth;
    
}

- (void)setSvContentSize:(CGSize)svContentSize{
    _svContentSize = svContentSize;
}

@end

