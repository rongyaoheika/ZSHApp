//
//  ZSHMusicLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHMusicLogic.h"
#import "MusicModel.h"

@implementation ZSHMusicLogic

- (void)loadRadioListSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlRadioStation parameters:nil success:^(id responseObject) {
        RLog(@"音乐电台列表数据%@",responseObject);

        NSArray *modelArr = [ZSHRadioModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"result"]];
        RLog(@"音乐电台model列表数据%@",modelArr);
        success(modelArr);
        
    } failure:^(NSError *error) {
        RLog(@"音乐电台列表数据获取失败");
    }];
}

- (void)loadRadioDetailWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlChannelSong parameters:paramDic success:^(id responseObject) {
        RLog(@"电台详细歌单列表数据%@",responseObject);
        ZSHRadioDetailModel *radioDetailModel = [ZSHRadioDetailModel mj_objectWithKeyValues:responseObject[@"pd"][@"result"]];
        RLog(@"电台详细歌单列表数据%@",radioDetailModel);
        success(radioDetailModel);
        
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
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlSongPlay parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐详细数据%@",responseObject);
        
        MusicModel *detailModel = [[MusicModel alloc]init];
//        QQMusicModel *detailModel = [[QQMusicModel alloc]init];
        //歌曲 以xcoe截取
        detailModel.file_link = responseObject[@"pd"][@"bitrate"][@"file_link"];
        detailModel.show_link = responseObject[@"pd"][@"bitrate"][@"show_link" ];
        
        detailModel.lrclink = responseObject[@"pd"][@"bitrate"][@"lrclink"];    //歌词文件
        detailModel.author = responseObject[@"pd"][@"songinfo"][@"author"];     //歌手
        detailModel.title = responseObject[@"pd"][@"songinfo"][@"title"]; //歌曲名字
        detailModel.album_title = responseObject[@"pd"][@"songinfo"][@"album_title"];//专辑名字
        //中间小图片 以@符号截取
        detailModel.pic_radio =  [responseObject[@"pd"][@"songinfo"][@"pic_radio"]componentsSeparatedByString:@"@"][0];
        //背景图片 以@符号截取
        detailModel.pic_huge =  [responseObject[@"pd"][@"songinfo"][@"pic_huge"] componentsSeparatedByString:@"@"][0];
        
        [weakself loadLryWithParamDic:paramDic Success:^(id responseObject) {
            detailModel.lrcContent = responseObject;
             success(detailModel);
        } fail:nil];
        
//        success(detailModel);
    } failure:^(NSError *error) {
        RLog(@"音乐详细数据失败");
    }];
}

- (void)loadLryWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlLry parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐歌词列表数据%@",responseObject);
        success(responseObject[@"pd"][@"lrcContent"]);
        
    } failure:^(NSError *error) {
        RLog(@"音乐歌词列表获取失败");
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
