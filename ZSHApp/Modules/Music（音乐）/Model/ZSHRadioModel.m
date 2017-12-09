//
//  ZSHRadioModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHRadioModel.h"

@implementation ZSHRadioModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"channellist"]) {
        _channellist = [ZSHRadioSubModel mj_objectArrayWithKeyValuesArray:value];
    }
}


@end


@implementation ZSHRadioSubModel

@end

