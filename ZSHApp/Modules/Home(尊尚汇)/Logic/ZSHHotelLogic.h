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


//酒店列表
- (void)loadHotelListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒店详情
- (void)loadHotelDetailDataWithParamDic:(NSDictionary *)paramDic;

//酒店详情列表
- (void)loadHotelDetailSetDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)successBlock fail:(ResponseFailBlock)failBlock;

//酒店更多商家
- (void)loadHotelDetailListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒店排序
- (void)loadHotelSortWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒吧列表
- (void)loadBarListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒吧详情
- (void)loadBarDetailDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒吧套餐列表
- (void)loadBarDetailSetDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒吧更多商家
- (void)loadBarDetailMoreShopDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒吧排序
- (void)loadBarSortWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

@end
