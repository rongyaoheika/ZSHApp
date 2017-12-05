//
//  ZSHKTVLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHKTVModel.h"

@interface ZSHKTVLogic : ZSHBaseLogic

//KTV列表
- (void)loadKTVListDataWithParamDic:(NSDictionary *)paramDic;

//KTV详情
- (void)loadKTVDetailDataWithParamDic:(NSDictionary *)paramDic;

//KTV套餐列表
- (void)loadKTVDetailSetDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)successBlock fail:(ResponseFailBlock)failBlock;

//KTV更多商家列表
- (void)loadKTVDetailListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)successBlock fail:(ResponseFailBlock)failBlock;
@end
