//
//  ZSHHotelLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
@class ZSHHotelDetailModel;
@interface ZSHHotelLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray <ZSHHotelDetailModel *>   *hotelListArr;
- (void)loadHotelListData;
@end
