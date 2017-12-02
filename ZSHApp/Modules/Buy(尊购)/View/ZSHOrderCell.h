//
//  ZSHOrderCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
#import "ZSHGoodOrderModel.h"
#import "ZSHHotelOrderModel.h"

@interface ZSHOrderCell : ZSHBaseCell


- (void)updateCellWithHotel:(ZSHHotelOrderModel *)model;

@end
