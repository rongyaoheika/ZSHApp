//
//  ZSHGuideLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"

@interface ZSHGuideLogic : ZSHBaseLogic

-(void)requestGuideDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

@end
