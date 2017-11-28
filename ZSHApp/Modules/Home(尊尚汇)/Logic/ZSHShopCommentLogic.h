//
//  ZSHShopCommentLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHShopCommentModel.h"
@interface ZSHShopCommentLogic : ZSHBaseLogic

- (void)requestShopCommentListDataWithParamDic:(NSDictionary *)paramDic;

@end
