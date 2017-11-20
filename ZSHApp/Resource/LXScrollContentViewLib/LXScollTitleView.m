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
@property (nonatomic, strong) UIScrollView        *scrollView;
//@property (nonatomic, strong) NSMutableArray      *titleButtons;
@property (nonatomic, strong) UIView              *selectionIndicator;


@end

@implementation LXScollTitleView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
    [self setupUI];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self setupUI];
    }
    return self;
}

- (void)initData{
    self.selectedIndex = 0;
    self.normalColor = KZSHColor929292;
    self.selectedColor = KWhiteColor;
    self.titleWidth = 85.f;
    self.indicatorHeight = 2.f;
    self.normalTitleFont = kPingFangMedium(15);
    self.selectedTitleFont = kPingFangRegular(15);
    self.titleButtons = [[NSMutableArray alloc] init];
}

- (void)setupUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    self.selectionIndicator = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:self.selectionIndicator];
}

- (void)reloadViewWithTitles:(NSArray *)titles{
    for (UIButton *btn in self.titleButtons) {
        [btn removeFromSuperview];
    }
    [self.titleButtons removeAllObjects];
  
    NSInteger i = 0;
    for (NSString *title in titles) {
       
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [btn setBackgroundImage:self.normalBgImage forState:UIControlStateNormal];
        [btn setBackgroundImage:self.selectedBgImage forState:UIControlStateSelected];
        [btn setImage:self.normalImage forState:UIControlStateNormal];
        [btn setImage:self.selectedImage forState:UIControlStateSelected];
        
        btn.selected = (i == self.selectedIndex);
        btn.titleLabel.font = btn.selected?self.selectedTitleFont:self.normalTitleFont;
        btn.tag = 100 + i++;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:btn.titleLabel.font,NSFontAttributeName,nil]];
        self.indicatorWidth = titleSize.width;
        
        [self.scrollView addSubview:btn];
        [self.titleButtons addObject:btn];
    }
    [self layoutSubviews];
}


- (void)btnClick:(UIButton *)titleBtn{
    [self.titleButtons enumerateObjectsUsingBlock:^(UIButton *btn , NSUInteger idx, BOOL * _Nonnull stop) {
        if (btn == titleBtn) {
            btn.selected = !btn.selected;
            btn.titleLabel.font = self.selectedTitleFont;
        } else {
            btn.selected = NO;
            btn.titleLabel.font = self.normalTitleFont;
        }
    }];

    NSInteger btnIndex = titleBtn.tag - 100;
    self.selectedIndex = btnIndex;
    if (self.selectedBlock) {
        self.selectedBlock(btnIndex);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.titleButtons.count * self.titleWidth, self.frame.size.height);
    NSInteger i = 0;
    for (UIButton *btn in self.titleButtons) {
        btn.frame = CGRectMake(self.titleWidth * i++, 0, self.titleWidth, self.frame.size.height);
        if (self.normalImage) {
            [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleRight imageTitleSpace:kRealValue(6)];
        }
    }
    [self setSelectedIndicator:NO];
    [self.scrollView bringSubviewToFront:self.selectionIndicator];
}

- (void)setSelectedIndicator:(BOOL)animated {
    self.selectionIndicator.backgroundColor = self.selectedColor;
    CGFloat leftW = (self.titleWidth - self.indicatorWidth)/2;
    [UIView animateWithDuration:(animated? 0.02 : 0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.selectionIndicator.frame = CGRectMake(leftW + (self.selectedIndex)*self.titleWidth, self.frame.size.height - self.indicatorHeight, self.indicatorWidth, self.indicatorHeight);
    } completion:^(BOOL finished) {
        [self scrollRectToVisibleCenteredOn:self.selectionIndicator.frame animated:YES];
    }];
}

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect animated:(BOOL)animated {
    CGRect centeredRect = CGRectMake(visibleRect.origin.x + visibleRect.size.width / 2.0 - self.scrollView.frame.size.width / 2.0,
                                     visibleRect.origin.y + visibleRect.size.height / 2.0 - self.scrollView.frame.size.height / 2.0,
                                     self.scrollView.frame.size.width,
                                     self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:centeredRect animated:animated];
}

//按钮左侧图片旋转
-(void)changeButtonObject:(UIButton *)button TransformAngle:(CGFloat)angle
{
    [UIView animateWithDuration:0.5 animations:^{
        button.imageView.transform =CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark - setter

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    [self setSelectedIndicator:YES];
}

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

@end

