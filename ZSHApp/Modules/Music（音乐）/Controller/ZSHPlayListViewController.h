//
//  ZSHPlayListViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger, ZSHToPlayListVC) {
    ZSHFromRankVCToPlayListVC,         //排行榜-播放列表
    ZSHFromRadioVCToPlayListVC,        //电台-播放列表
    ZSHFromSingerVCToPlayListVC,       //歌手-播放列表
    ZSHFromLibraryVCToPlayListVC,      //曲库-播放列表
    ZSHFromOtherVCToPlayListVC,        //其他
};

@interface ZSHPlayListViewController : RootViewController


@end
