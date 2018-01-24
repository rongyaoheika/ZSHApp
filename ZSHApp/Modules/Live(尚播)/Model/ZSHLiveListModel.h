//
//  ZSHLiveListModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHLiveListModel : ZSHBaseModel

@property (nonatomic,copy)  NSString *liveName;
@property (nonatomic,copy)  NSString *imageName;
@property (nonatomic,copy)  NSString *loveCount;

@property (nonatomic,copy)  NSString *PublishTime;
@property (nonatomic,copy)  NSString *PublishUrl;
@property (nonatomic,copy)  NSString *UserNumber;

@end
