//
//  ZSHHomeLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHomeLogic.h"

@implementation ZSHHomeLogic

- (void)loadNoticeCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlUserHome parameters:nil success:^(id responseObject) {
        RLog(@"新闻推荐数据%@",responseObject);
        weakself.noticeArr = responseObject[@"pd"];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"新闻推荐数据获取失败");
        
    }];
}

//荣耀服务列表
- (void)loadServiceCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlServerDo parameters:nil success:^(id responseObject) {
        RLog(@"荣耀服务首页数据==%@",responseObject);
        weakself.serviceArr = responseObject[@"pd"];
        success(nil);
    } failure:^(NSError *error) {
         RLog(@"荣耀服务首页数据获取失败");
    }];
}

//新闻头条轮播信息
- (void)loadNewsCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetNewsList parameters:nil success:^(id responseObject) {
        RLog(@"新闻头条轮播信息%@",responseObject);
        weakself.newsArr = responseObject[@"pd"];
        success(nil);
        
    } failure:^(NSError *error) {
        RLog(@"新闻头条轮播数据获取失败");
    }];
}

//汇聚玩趴
- (void)loadPartyCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlPartyimg parameters:nil success:^(id responseObject) {
        RLog(@"汇聚玩趴%@",responseObject);
        weakself.partyArr = responseObject[@"pd"];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"汇聚玩趴数据获取失败");
    }];
}



//更多特权
- (void)loadMorePrivilege{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlPrivilegelist parameters:nil success:^(id responseObject) {
        RLog(@"更多特权%@",responseObject);
        NSArray *privledgeModelArr = [ZSHPrivlegeModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(privledgeModelArr);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//音乐
- (void)loadMusicCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlMusicreclist parameters:nil success:^(id responseObject) {
        RLog(@"音乐列表%@",responseObject);
        weakself.musicArr = responseObject[@"pd"];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"音乐列表请求失败");
    }];
}
//杂志
- (void)loadMagzineCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlMagazineList parameters:nil success:^(id responseObject) {
        RLog(@"杂志列表%@",responseObject);
        weakself.magzineArr = responseObject[@"pd"];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"音乐列表请求失败");
    }];
}

// 杂志详情
- (void)loadMagzineOneWithDic:(NSDictionary *)dic success:(void(^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlMagazineOne parameters:dic success:^(id responseObject) {
        RLog(@"杂志详情%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"音乐列表请求失败");
    }];
}

@end
