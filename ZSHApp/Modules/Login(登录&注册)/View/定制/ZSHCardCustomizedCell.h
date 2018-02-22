//
//  ZSHCardCustomizedCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellHeightChanged) (NSInteger selectIndex);

@interface ZSHCardCustomizedCell : ZSHBaseCell

@property (nonatomic, copy) CellHeightChanged   cellHeightBlock;
@property (nonatomic, assign) NSInteger         selectIndex;
@end
