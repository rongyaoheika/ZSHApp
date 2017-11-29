//
//  ZSHHomeLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHomeLogic.h"

@implementation ZSHHomeLogic

- (void)loadNoticeCellData{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlUserHome parameters:nil success:^(id responseObject) {
        RLog(@"请求成功：返回数据&%@",responseObject);
//        weakself.noticeArr = [ZSHHomeMainModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        weakself.noticeArr = responseObject[@"pd"];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(nil);
        }

    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

//荣耀服务列表
- (void)loadServiceCellData{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlServerDo parameters:nil success:^(id responseObject) {
        RLog(@"荣耀服务首页数据==%@",responseObject);
        weakself.serviceArr = responseObject[@"pd"];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(self.serviceArr);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}

//荣耀服务详情
- (void)loadServiceDetailDataWithParamDic:(NSDictionary *)paramDic{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetNewsList parameters:nil success:^(id responseObject) {
        RLog(@"新闻头条轮播信息%@",responseObject);
        weakself.newsArr = responseObject[@"pd"];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(self.serviceArr);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}


//新闻头条轮播信息
- (void)loadNewsCellData{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetNewsList parameters:nil success:^(id responseObject) {
        RLog(@"新闻头条轮播信息%@",responseObject);
        weakself.newsArr = responseObject[@"pd"];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(self.serviceArr);
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
}



@end
