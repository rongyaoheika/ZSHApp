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
@interface ZSHMusicLogic : ZSHBaseLogic

//音乐电台列表
- (void)loadRadioListSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//音乐排行榜
- (void)loadRankListWithParamDic:(NSDictionary *)paramDic Success:(RequestMoreDataCompleted)success fail:(ResponseFailBlock)fail;

//音乐详细数据
- (void)loadSongDetailtWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//获得歌曲歌词
- (void)loadLryWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//每日推荐歌曲
- (void)loadkSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

@end
