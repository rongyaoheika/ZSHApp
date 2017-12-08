//
//  ZSHMusicLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicLogic.h"

@implementation ZSHMusicLogic

- (void)loadRadioListSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlRadioStation parameters:nil success:^(id responseObject) {
        RLog(@"音乐电台列表数据%@",responseObject);

        NSArray *modelArr = [ZSHRadioModel mj_objectArrayWithKeyValuesArray:responseObject[@"result"]];
        
        RLog(@"音乐电台model列表数据%@",modelArr);
        success(modelArr);
        
    } failure:^(NSError *error) {
        RLog(@"音乐电台列表数据获取失败");
    }];
}

- (void)loadLryWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlLry parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐歌词列表数据%@",responseObject);
        
    } failure:^(NSError *error) {
        RLog(@"音乐电台列表数据获取失败");
    }];
}


- (void)loadkSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSongList parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐歌词列表数据%@",responseObject);
        
    } failure:^(NSError *error) {
        RLog(@"音乐电台列表数据获取失败");
    }];
}

@end
