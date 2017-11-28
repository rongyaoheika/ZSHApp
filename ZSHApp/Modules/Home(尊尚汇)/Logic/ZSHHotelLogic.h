//
//  ZSHHotelLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHHotelModel.h"

@interface ZSHHotelLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray <ZSHHotelModel *>   *hotelListArr;
@property (nonatomic, strong) NSDictionary                *hotelDetailParamDic;

//酒店列表
- (void)loadHotelListDataWithParamDic:(NSDictionary *)paramDic;

//酒店详情
- (void)loadHotelDetailDataWithParamDic:(NSDictionary *)paramDic;
@end
