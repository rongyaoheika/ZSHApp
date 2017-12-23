//
//  ZSHBaseTitleButtonCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

typedef void (^ItemClickBlock)(NSInteger);

@interface ZSHBaseTitleButtonCell : ZSHBaseCell


@property (nonatomic, copy) ItemClickBlock  itemClickBlock;
- (void)updateCellWithDataArr:(NSArray *)dataArr paramDic:(NSDictionary *)paramDic;
@end

