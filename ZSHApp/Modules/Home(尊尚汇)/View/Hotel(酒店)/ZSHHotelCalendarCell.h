//
//  ZSHHotelCalendarCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

typedef void(^HotelDateViewTapBlock)(NSInteger);
@interface ZSHHotelCalendarCell : ZSHBaseCell

@property (nonatomic, copy) HotelDateViewTapBlock   dateViewTapBlock;
@end
