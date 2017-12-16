//
//  ZSHRankModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHRankModel.h"

@implementation ZSHRankModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    RLog(@"执行songid转换");
    return @{@"artist": @"author"};
}

@end
