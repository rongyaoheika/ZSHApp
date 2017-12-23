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

//酒店评论详情
- (void)requestHotelShopCommentListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
//美食评论详情
- (void)requestFoodShopCommentListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
//KTV评论详情
- (void)requestKTVShopCommentListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//酒吧评论详情
- (void)requestBarShopCommentListDataWithParamDic:(NSDictionary *)paramDic success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
@end
