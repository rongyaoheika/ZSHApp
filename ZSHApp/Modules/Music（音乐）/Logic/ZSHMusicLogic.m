//
//  ZSHMusicLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicLogic.h"

@implementation ZSHMusicLogic

- (void)loadRadioListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlRadioStation parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐电台列表数据%@",responseObject);

        NSArray *modelArr = [ZSHRadioModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"result"][@"channellist"]];
        RLog(@"音乐电台model列表数据%@",modelArr);
        success(modelArr);
        
    } failure:^(NSError *error) {
        RLog(@"音乐电台列表数据获取失败");
    }];
}

- (void)loadRadioDetailWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlChannelSong parameters:paramDic success:^(id responseObject) {
        RLog(@"电台详细歌单列表数据%@",responseObject);
         NSArray *radioDetailModelArr = [ZSHRankModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"result"][@"songlist"]];
        success(radioDetailModelArr);
        
    } failure:^(NSError *error) {
        RLog(@"电台详细歌单列表数据");
    }];
}

- (void)loadTotalRankListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    RLog(@"paramDic == %@",paramDic);
    [PPNetworkHelper POST:kUrlBillListall parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐排行榜列表数据%@",responseObject);;
        NSArray *dataArr = responseObject[@"pd"];
        success(dataArr);
    } failure:^(NSError *error) {
        RLog(@"音乐排行榜列表数据失败");
       
    }];
}

- (void)loadRankListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    RLog(@"paramDic == %@",paramDic);
    [PPNetworkHelper POST:kUrlBillList parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐排行榜列表数据%@",responseObject);
        NSArray *rankModelArr = [ZSHRankModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"song_list"]];
        success(rankModelArr);
    } failure:^(NSError *error) {
        RLog(@"音乐排行榜列表数据失败");
    }];
}

- (void)loadSongDetailtWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    ZSHRankModel *detailModel = paramDic[@"model"];
    NSDictionary *newParamDic = @{@"songid":detailModel.song_id? detailModel.song_id:detailModel.songid};
    [PPNetworkHelper POST:kUrlSongPlay parameters:newParamDic success:^(id responseObject) {
        RLog(@"音乐详细数据%@",responseObject);
        if (![responseObject[@"result"]isEqualToString:@"01"]) {
            return;
        }
        
        NSArray *arr = responseObject[@"pd"][@"bitrate"];
        if (arr.count && responseObject[@"pd"][@"songinfo"]) {//有MP3文件
            detailModel.file_link = responseObject[@"pd"][@"bitrate"][@"file_link"];//MP3
           
            //中间小图片 以@符号截取
            detailModel.pic_radio =  [responseObject[@"pd"][@"songinfo"][@"pic_radio"]componentsSeparatedByString:@"@"][0];
            //背景图片 以@符号截取
            detailModel.pic_huge =  [responseObject[@"pd"][@"songinfo"][@"pic_huge"] componentsSeparatedByString:@"@"][0];
            //歌词
            detailModel.lrcContent =  responseObject[@"pd"][@"songinfo"][@"lrclink"][@"lrcContent"];
            success(detailModel);
        }

    } failure:^(NSError *error) {
        RLog(@"音乐详细数据失败");
    }];
}

- (void)loadkSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSongList parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐推荐列表数据=%@",responseObject);
         NSArray *rankModelArr = [ZSHRankModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"result"][@"list"]];
         success(rankModelArr);
    } failure:^(NSError *error) {
        RLog(@"音乐推荐列表数据获取失败");
    }];
}

- (void)loadSingerListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSingerList parameters:paramDic success:^(id responseObject) {
        RLog(@"歌手列表数据%@",responseObject);
        NSArray *singerModelArr = [ZSHSingerModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"artist"]];
        success(singerModelArr);
    } failure:^(NSError *error) {
        RLog(@"歌手列表获取失败");
    }];
}

- (void)loadSingerSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSingerSongList parameters:paramDic success:^(id responseObject) {
        RLog(@"歌手歌曲列表数据%@",responseObject);
        NSArray *rankModelArr = [ZSHRankModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"songlist"]];
        success(rankModelArr);
    } failure:^(NSError *error) {
        RLog(@"歌手歌曲列表数据获取失败");
    }];
}


@end
