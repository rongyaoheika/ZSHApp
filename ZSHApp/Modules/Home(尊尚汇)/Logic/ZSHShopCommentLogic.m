//
//  ZSHShopCommentLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHShopCommentLogic.h"

@implementation ZSHShopCommentLogic

- (void)requestHotelShopCommentListDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlHotelEvaList parameters:paramDic success:^(id responseObject) {
        RLog(@"酒店评论列表== %@",responseObject);
       NSArray *shopCommentArr = [ZSHShopCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(shopCommentArr);
        }
        
    } failure:^(NSError *error) {
       
    }];
}

- (void)requestFoodShopCommentListDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlFoodEvaList parameters:paramDic success:^(id responseObject) {
        RLog(@"美食评论列表== %@",responseObject);
        NSArray *shopCommentArr = [ZSHShopCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(shopCommentArr);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestKTVShopCommentListDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlKtvEvaList parameters:paramDic success:^(id responseObject) {
        RLog(@"KTV评论列表== %@",responseObject);
        NSArray *shopCommentArr = [ZSHShopCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(shopCommentArr);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
