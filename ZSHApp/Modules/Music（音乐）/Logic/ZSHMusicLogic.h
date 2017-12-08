//
//  ZSHMusicLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHRadioModel.h"
@interface ZSHMusicLogic : ZSHBaseLogic

//音乐电台列表
- (void)loadRadioListSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;


//获得歌曲歌词
- (void)loadLryWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

//每日推荐歌曲
- (void)loadkSongListWithParamDic:(NSDictionary *)paramDic Success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;

@end
