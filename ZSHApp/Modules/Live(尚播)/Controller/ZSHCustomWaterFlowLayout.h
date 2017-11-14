//
//  ZSHCustomWaterFlowLayout.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSHCustomWaterFlowLayout;

@protocol ZSHCustomWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)heightForItem:(ZSHCustomWaterFlowLayout *)layout heightForItemAtIndex:(NSInteger)index itemWith:(CGFloat)itemWith;

@optional
- (NSInteger)numberOfColums:(ZSHCustomWaterFlowLayout *)layout;
- (CGFloat) lineSpacingOfItems:(ZSHCustomWaterFlowLayout *)layout;
- (UIEdgeInsets)edgeinsetOfItems:(ZSHCustomWaterFlowLayout *)layout;

@end

@interface ZSHCustomWaterFlowLayout : UICollectionViewFlowLayout
/** 段头的size */
@property (nonatomic, assign) CGSize   headerReferenceSize;
@property (nonatomic, weak)id<ZSHCustomWaterFlowLayoutDelegate>delegate;

@end
