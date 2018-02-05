//
//  ZSHEntryLogic.h
//  ZSHApp
//
//  Created by mac on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

@interface ZSHEntryLogic : ZSHBaseLogic

//商家入驻
- (void)loadBusinessInDataWith:(NSDictionary *)dic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

@end
