//
//  ZSHBaseModel.h
//  ZSHApp
//
//  Created by Apple on 2017/8/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSHBaseModel : NSObject

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
