//
//  ZSHLoginLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

typedef void(^LoginSuccess)(id response);

@interface ZSHLoginLogic : ZSHBaseLogic

@property (nonatomic, copy) LoginSuccess loginSuccess;

- (void)loginWithPhone:(NSString *)phone;
- (void)loginWithCardNo:(NSString *)CardNo password:(NSString *)password;

@end
