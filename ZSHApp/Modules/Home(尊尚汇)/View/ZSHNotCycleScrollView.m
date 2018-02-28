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
//宽度不一致时，记录前个button的maxX
@property (nonatomic, strong) UIButton        *temBtn;
//@property (nonatomic, assign) CGFloat         midSpacing;
@end

#define  midSpacing 7.5
@implementation ZSHNotCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self setupUI];
    }
    return self;
}

- (void)initData{
//    self.midSpacing = 7.5;
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
                [btn setTitleColor:KZSHColorF29E19 forState:UIControlStateSelected];
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
                [btn setTitleColor:KZSHColorF29E19 forState:UIControlStateSelected];
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

    NSInteger i = 0;
    CGFloat contentWidth = 0;
    CGFloat firstLeftX = 0;
    for (UIButton *btn in self.titleButtons) {
        if (self.fromClassType == FromKTVCalendarVCToNoticeView||self.fromClassType == FromEnergyValueVCToNoticeView) { //KTV日历
             btn.frame = CGRectMake(_itemWidth*i++, 0, _itemWidth, self.frame.size.height);
        } else if (self.fromClassType == FromKTVRoomTypeVCToNoticeView) {//KTV房间型号
            firstLeftX = KLeftMargin;
            CGSize titleSize = [btn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:btn.titleLabel.font,NSFontAttributeName,nil]];
            _itemWidth = titleSize.width+kRealValue(5);
            CGFloat leftX = KLeftMargin;
            if (i!=0) {
                _temBtn = self.titleButtons[i-1];
                 leftX = CGRectGetMaxX(_temBtn.frame)+kRealValue(6);
            }
            btn.frame = CGRectMake(leftX, (CGRectGetHeight(self.frame)-kRealValue(25))/2, _itemWidth, kRealValue(25));
            i++;
        } else {
            firstLeftX = KLeftMargin;
            btn.frame = CGRectMake(KLeftMargin + (midSpacing + _itemWidth)*i++, 0, _itemWidth, CGRectGetHeight(self.frame));
        }
        
        if (i == self.titleButtons.count) {
            contentWidth = CGRectGetMaxX(btn.frame) + firstLeftX;
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(contentWidth, 0);

}

#pragma mark - setter

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
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
