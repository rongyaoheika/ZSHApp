//
//  ZSHMusicLryViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"
#import "QQLrcModel.h"
@interface ZSHMusicLryViewController : UITableViewController

/** 数据源*/
@property (nonatomic, strong) NSArray<QQLrcModel *> *datasource;

/** 指定歌词滚动到某一行*/
@property (nonatomic, assign) NSInteger scrollRow;

/** 当前歌词的播放进度*/
@property (nonatomic, assign) CGFloat progress;

@end
