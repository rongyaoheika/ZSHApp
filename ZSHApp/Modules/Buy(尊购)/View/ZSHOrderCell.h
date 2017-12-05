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

// 酒店
- (void)updateCellWithHotel:(ZSHHotelOrderModel *)model;
// 酒吧
- (void)updateCellWithBarorder:(ZSHBarorderOrderModel *)model;
// 美食
- (void)updateCellWithFood:(ZSHFoodOrderModel *)model;
// KTV
- (void)updateCellWithKtv:(ZSHKtvOrderModel *)model;
@end
