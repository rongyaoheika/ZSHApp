//
//  ZSHSelectCardNumCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellHeightChanged) (CGFloat);

@interface ZSHSelectCardNumCell : ZSHBaseCell

@property (nonatomic, assign) CGFloat             cellHeight;
@property (nonatomic, copy)   CellHeightChanged   cellHeightBlock;
@property (nonatomic, strong) UIScrollView        *bottomScrollView;

@end
