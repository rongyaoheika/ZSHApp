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


- (void)loadRankListWithParamDic:(NSDictionary *)paramDic Success:(RequestMoreDataCompleted)success fail:(ResponseFailBlock)fail{
    RLog(@"paramDic == %@",paramDic);
    [PPNetworkHelper POST:kUrlBillList parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐排行榜列表数据%@",responseObject);
        NSString *songTypeImage = responseObject[@"pd"][@"billboard"][@"pic_s640"];
        NSArray *rankModelArr = [ZSHRankModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"][@"song_list"]];
        success(rankModelArr,songTypeImage);
    } failure:^(NSError *error) {
        RLog(@"音乐排行榜列表数据失败");
    }];
}

- (void)loadSongDetailtWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSongPlay parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐详细数据%@",responseObject);
        
        MusicModel *detailModel = [[MusicModel alloc]init];
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
        success(detailModel);
    } failure:^(NSError *error) {
        RLog(@"音乐详细数据失败");
    }];
}

- (void)loadLryWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlLry parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐歌词列表数据%@",responseObject);
        
    } failure:^(NSError *error) {
        RLog(@"音乐歌词列表获取失败");
    }];
}


- (void)loadkSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlSongList parameters:paramDic success:^(id responseObject) {
        RLog(@"音乐列表数据=%@",responseObject);
        
    } failure:^(NSError *error) {
        RLog(@"音乐列表数据获取失败");
    }];
}

@end
