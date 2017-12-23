//
//  ZSHTrainLogic.h
//  ZSHApp
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

@interface ZSHTrainLogic : ZSHBaseLogic

// 根据条件获取火车票列表接口
- (void)requestTrainSelectWithDic:(NSDictionary *)dic success:(void (^)(id response))success;

@end
