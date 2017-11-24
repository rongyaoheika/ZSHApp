//
//  ZSHHotelLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
@class ZSHHotelModel;
@class ZSHHotelDetailModel;

@interface ZSHHotelLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray <ZSHHotelModel *>   *hotelListArr;
@property (nonatomic, strong) ZSHHotelDetailModel         *hotelDetailModel;

- (void)loadHotelListDataWithParamDic:(NSDictionary *)paramDic;
- (void)loadHotelDetailDataWithParamDic:(NSDictionary *)paramDic;
@end
