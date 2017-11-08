//
//  ZSHWeiBoModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHWeiBoCellModel.h"

@implementation ZSHWeiBoCellModel

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    ZSHWeiBoCellModel *model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
