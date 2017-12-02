//
//  ZSHMoreLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

@interface ZSHMoreLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray *horseDicArr;
@property (nonatomic, strong) NSArray *golfDicArr;

//马术
- (void)requestHorseListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//游艇
- (void)requestYachtListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//高尔夫
- (void)requestGolfListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//豪车
- (void)requestLuxcarListWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//马术详情
- (void)requestHorseDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//游艇详情
- (void)requestYachtDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//高尔夫详情
- (void)requestGolfDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//豪车详情
- (void)requestLuxcarDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//飞机详情
- (void)requestPlaneDetailWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
@end
