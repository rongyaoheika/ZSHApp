//
//  ZSHMusicLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHRadioModel.h"
#import "ZSHRankModel.h"
#import "ZSHSingerModel.h"
@interface ZSHMusicLogic : ZSHBaseLogic

//音乐电台列表
- (void)loadRadioListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//某个音乐电台音乐列表
- (void)loadRadioDetailWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//音乐排行榜
- (void)loadTotalRankListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//音乐排行榜详情
- (void)loadRankListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//音乐详细数据
- (void)loadSongDetailtWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//每日推荐歌曲
- (void)loadkSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//歌手列表
- (void)loadSingerListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//歌手歌曲列表
- (void)loadSingerSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

// 音乐中心-歌手推荐-获取歌手歌曲列表
- (void)loadSingerSongList:(NSDictionary *)dic success:(void (^)(id response))success;

// 音乐中心-首页：歌手推荐和广告
- (void)loadGetSongRecommend:(NSDictionary *)dic success:(void (^)(id response))success;

// 音乐中心-电台
- (void)loadGetRadioStationList:(NSDictionary *)dic success:(void (^)(id response))success;

// 音乐中心-曲库推荐
- (void)loadGetMusicLibrary:(NSDictionary *)dic success:(void (^)(id response))success;

// 音乐中心-歌单推荐
- (void)loadGetSongsRecommend:(NSDictionary *)dic success:(void (^)(id response))success;

@end
