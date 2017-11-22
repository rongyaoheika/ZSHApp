//
//  ZSHHomeLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHHomeMainModel.h"

@interface ZSHHomeLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray                *dataArr;

- (void)loadNoticeCellData;
- (void)loadServiceCellData;
@end
