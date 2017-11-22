//
//  ZSHNotCycleScrollView.m
//  ZSHApp
//
//  Created by Apple on 2017/8/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHNotCycleScrollView.h"
#import "ZSHHotelDetailViewController.h"
@interface ZSHNotCycleScrollView()

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UIView         *selectionIndicator;
//宽度不一致时，记录前个button的maxX
@property (nonatomic, strong) UIButton        *temBtn;

@end

#define  leftSpacing 15
#define  midSpacing 7.5
@implementation ZSHNotCycleScrollView

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
    self.normalColor = [UIColor blackColor];
    self.selectedColor = [UIColor redColor];
    self.itemWidth = 95.f;
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
    self.selectionIndicator.backgroundColor = self.selectedColor;
    [self.scrollView addSubview:self.selectionIndicator];
}

- (void)reloadViewWithDataArr:(NSMutableArray *)dataArr{
    for (UIButton *btn in self.titleButtons) {
        [btn removeFromSuperview];
    }
    [self.titleButtons removeAllObjects];
    
    for (int i = 0; i<dataArr.count; i++) {
        UIButton *btn = dataArr[i];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.selectedIndex) {
            btn.selected = YES;
            if (self.fromClassType == FromKTVCalendarVCToNoticeView) {
                for (UILabel *subLabel in btn.subviews) {
                        subLabel.textColor = KZSHColorF29E19;
                }
            }
            
            if (self.fromClassType == FromKTVRoomTypeVCToNoticeView && btn.layer.borderWidth) {
                btn.layer.borderColor = KZSHColorF29E19.CGColor;
            }
        }
        
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
            if (self.fromClassType == FromKTVCalendarVCToNoticeView) {
                for (UILabel *subLabel in btn.subviews) {
                    subLabel.textColor = KZSHColorF29E19;
                }
            }

            if (self.fromClassType == FromKTVRoomTypeVCToNoticeView && btn.layer.borderWidth) {
                btn.layer.borderColor = KZSHColorF29E19.CGColor;
            }
        } else {
            btn.selected = NO;
            btn.titleLabel.font = self.normalTitleFont;
            if (self.fromClassType == FromKTVCalendarVCToNoticeView) {
                for (UILabel *subLabel in btn.subviews) {
                    subLabel.textColor = KZSHColor929292;
                }
            }
            if (self.fromClassType == FromKTVRoomTypeVCToNoticeView && btn.layer.borderWidth) {
                btn.layer.borderColor = KZSHColor929292.CGColor;
            }
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
    self.temBtn = nil;
    
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.titleButtons.count * self.itemWidth+2*leftSpacing + (self.titleButtons.count-1)*midSpacing, self.frame.size.height);
    NSInteger i = 0;

    for (UIButton *btn in self.titleButtons) {
        if (self.fromClassType == FromKTVCalendarVCToNoticeView||self.fromClassType == FromEnergyValueVCToNoticeView) { //KTV日历
            
             btn.frame = CGRectMake(_itemWidth*i++, 0, _itemWidth, self.frame.size.height);
            
        } else if (self.fromClassType == FromKTVRoomTypeVCToNoticeView) {//KTV房间型号
            
            CGSize titleSize = [btn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:btn.titleLabel.font,NSFontAttributeName,nil]];
            _itemWidth = titleSize.width+kRealValue(5);
            CGFloat leftX = 0;
            if (i!=0) {
                _temBtn = self.titleButtons[i - 1];
                leftX = CGRectGetMaxX(_temBtn.frame)+kRealValue(6);
            } else {
                leftX = KLeftMargin;
            }
            btn.frame = CGRectMake(leftX, (CGRectGetHeight(self.frame)-kRealValue(25))/2, _itemWidth, kRealValue(25));
            i++;
        } else {
            
            btn.frame = CGRectMake(leftSpacing + (midSpacing + _itemWidth)*i++, 0, _itemWidth, CGRectGetHeight(self.frame));
        }
    
        if (btn.titleLabel.text&&btn.imageView.image) {
            [btn layoutButtonWithEdgeInsetsStyle:XYButtonEdgeInsetsStyleTop imageTitleSpace:kRealValue(10)];
        }
    }
   
    [self setSelectedIndicator:NO];
    [self.scrollView bringSubviewToFront:self.selectionIndicator];
}

- (void)setSelectedIndicator:(BOOL)animated {
    [UIView animateWithDuration:(animated? 0.02 : 0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.selectionIndicator.frame = CGRectMake(self.selectedIndex * self.itemWidth, self.frame.size.height - self.indicatorHeight, self.itemWidth, self.indicatorHeight);
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

#pragma mark - setter

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    [self setSelectedIndicator:YES];
}

- (void)setFromClassType:(ZSHFromVCToHotelDetailVC)fromClassType{
    _fromClassType = fromClassType;
    [self setNeedsLayout];
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
}

- (void)setItemWidth:(CGFloat)itemWidth{
    _itemWidth = itemWidth;
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

@end
