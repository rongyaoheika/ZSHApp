//
//  ZSHShopCommentLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHShopCommentLogic.h"

@implementation ZSHShopCommentLogic

- (void)requestShopCommentListDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlHotelevalist parameters:paramDic success:^(id responseObject) {
        RLog(@"评论详情== %@",responseObject);
       NSArray *shopCommentArr = [ZSHShopCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(shopCommentArr);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

@end
