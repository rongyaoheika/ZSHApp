//
//  ZSHRadioDetailModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHRadioDetailModel.h"

@implementation ZSHRadioDetailModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"songlist"]) {
        _songlist = [ZSHRadioDetailSubModel mj_objectArrayWithKeyValuesArray:value];
    }
}

@end

@implementation ZSHRadioDetailSubModel
@end
