//
//  ZSHBaseCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

@interface ZSHBaseCell()

@property (nonatomic, strong) UIImageView *defaultAccessoryImageView;

@end

@implementation ZSHBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = kPingFangRegular(15);
        self.textLabel.textColor = KZSHColor929292;
        self.detailTextLabel.font = kPingFangRegular(12);
        self.detailTextLabel.textColor = KZSHColor929292;
        self.backgroundColor = KClearColor;

        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    BOOL hasCustomAccessoryEdgeInset = self.accessoryView.superview && !UIEdgeInsetsEqualToEdgeInsets(self.accessoryEdgeInsets, UIEdgeInsetsZero);
    if (hasCustomAccessoryEdgeInset) {
        CGRect accessoryViewOldFrame = self.accessoryView.frame;
        accessoryViewOldFrame.origin.x = CGRectGetMinX(accessoryViewOldFrame) - self.accessoryEdgeInsets.right;
        accessoryViewOldFrame.origin.y = CGRectGetMinY(accessoryViewOldFrame) + self.accessoryEdgeInsets.top - self.accessoryEdgeInsets.bottom;
        self.accessoryView.frame = accessoryViewOldFrame;
        
        CGRect contentViewOldFrame = self.contentView.frame;
        contentViewOldFrame.size.width = CGRectGetMinX(accessoryViewOldFrame) - self.accessoryEdgeInsets.left;
        self.contentView.frame = contentViewOldFrame;
    }
    
    if (self.style == UITableViewCellStyleDefault || self.style == UITableViewCellStyleSubtitle) {
        
        BOOL hasCustomImageEdgeInsets = self.imageView.image && !UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, UIEdgeInsetsZero);
        
        BOOL hasCustomTextLabelEdgeInsets = self.textLabel.text.length > 0 && !UIEdgeInsetsEqualToEdgeInsets(self.textLabelEdgeInsets, UIEdgeInsetsZero);
        
        BOOL shouldChangeDetailTextLabelFrame = self.style == UITableViewCellStyleSubtitle;
        BOOL hasCustomDetailLabelEdgeInsets = shouldChangeDetailTextLabelFrame && self.detailTextLabel.text.length > 0 && !UIEdgeInsetsEqualToEdgeInsets(self.detailTextLabelEdgeInsets, UIEdgeInsetsZero);
        
        CGRect imageViewFrame = self.imageView.frame;
        CGRect textLabelFrame = self.textLabel.frame;
        CGRect detailTextLabelFrame = self.detailTextLabel.frame;
        
        if (hasCustomImageEdgeInsets) {
            imageViewFrame.origin.x += self.imageEdgeInsets.left - self.imageEdgeInsets.right;
            imageViewFrame.origin.y += self.imageEdgeInsets.top - self.imageEdgeInsets.bottom;
            
            textLabelFrame.origin.x += self.imageEdgeInsets.left;
            textLabelFrame.size.width = CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(textLabelFrame);
            
            if (shouldChangeDetailTextLabelFrame) {
                detailTextLabelFrame.origin.x += self.imageEdgeInsets.left;
                detailTextLabelFrame.size.width = CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(detailTextLabelFrame);
            }
        }
        if (hasCustomTextLabelEdgeInsets) {
            textLabelFrame.origin.x += self.textLabelEdgeInsets.left - self.imageEdgeInsets.right;
            textLabelFrame.origin.y += self.textLabelEdgeInsets.top - self.textLabelEdgeInsets.bottom;
            textLabelFrame.size.width = CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(textLabelFrame);
        }
        if (hasCustomDetailLabelEdgeInsets) {
            detailTextLabelFrame.origin.x += self.detailTextLabelEdgeInsets.left - self.detailTextLabelEdgeInsets.right;
            detailTextLabelFrame.origin.y += self.detailTextLabelEdgeInsets.top - self.detailTextLabelEdgeInsets.bottom;
            detailTextLabelFrame.size.width = CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(detailTextLabelFrame);
        }
        
        self.imageView.frame = imageViewFrame;
        self.textLabel.frame = textLabelFrame;
        self.detailTextLabel.frame = detailTextLabelFrame;
        
        // `layoutSubviews`这里不可以拿textLabel的minX来设置separatorInset，如果要设置只能写死一个值
        // 否则会导致textLabel的minX逐渐叠加从而使textLabel被移出屏幕外
    }
    
    // 由于调整 accessoryEdgeInsets 可能会影响 contentView 的宽度，所以几个 subviews 的布局也要保护一下
    if (hasCustomAccessoryEdgeInset) {
        if (CGRectGetMaxX(self.textLabel.frame) > CGRectGetWidth(self.contentView.bounds)) {
            CGRect textLabelOldFrame = self.textLabel.frame;
            textLabelOldFrame.size.width = CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(self.textLabel.frame);
            self.textLabel.frame = textLabelOldFrame;
        }
        if (CGRectGetMaxX(self.detailTextLabel.frame) > CGRectGetWidth(self.contentView.bounds)) {
            CGRect detailTextLabelOldFrame = self.textLabel.frame;
            detailTextLabelOldFrame.size.width = CGRectGetWidth(self.contentView.bounds) - CGRectGetMinX(self.detailTextLabel.frame);
            self.detailTextLabel.frame = detailTextLabelOldFrame;
        }
    }
    
}

- (void)initDefaultAccessoryImageViewIfNeeded {
    if (!self.defaultAccessoryImageView) {
        self.defaultAccessoryImageView = [[UIImageView alloc] init];
        self.defaultAccessoryImageView.contentMode = UIViewContentModeCenter;
    }
}

//加载UI
- (void)setup{
    
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        self.arrowImageName = (self.arrowImageName?self.arrowImageName:@"mine_next");
        UIImage *indicatorImage = [UIImage imageNamed:self.arrowImageName];
        if (indicatorImage) {
            [self initDefaultAccessoryImageViewIfNeeded];
            self.defaultAccessoryImageView.image = indicatorImage;
            [self.defaultAccessoryImageView sizeToFit];
            self.accessoryView = self.defaultAccessoryImageView;
            return;
        }
    }
}

+ (CGFloat)getCellHeightWithModel:(ZSHBaseModel *)model{
    return 30;
}

-(CGFloat)rowHeightWithCellModel:(ZSHBaseModel *)model{
    return 30;
}
//更新cell内容
- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
}

- (void)updateCellWithModel:(id)model{
    
}

@end
