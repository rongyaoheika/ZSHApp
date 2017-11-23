//
//  ZSHTogetherLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginLogic.h"
#import "ZSHTogetherModel.h"

@interface ZSHTogetherLogic : ZSHLoginLogic


@property (nonatomic, strong) NSArray<ZSHTogetherModel *> *dataArr;

- (void)requestConvergeList:(void(^)(id response))success;


@end
