//
//  ZSHTopicModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHTopicModel : ZSHBaseModel

//搜索的话题
@property (nonatomic, copy) NSString *title;

//话题拼音
@property (nonatomic, copy) NSString *titlePinYin;

//昵称的拼音首字母
@property (nonatomic, copy) NSString *titleFirstLetter;

@end
