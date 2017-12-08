//
//  ZSHRadioModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHRadioModel : ZSHBaseModel

@property (nonatomic, copy)   NSString    *title;
@property (nonatomic, copy)   NSString    *cid;
@property (nonatomic, strong) NSArray     *channellist;

@end


@interface ZSHRadioSubModel : ZSHBaseModel

@property (nonatomic, copy)   NSString    *name;
@property (nonatomic, copy)   NSString    *channelid;
@property (nonatomic, strong) NSArray     *thumb;
@property (nonatomic, copy)   NSString    *ch_name;
@property (nonatomic, strong) NSString    *value;
@property (nonatomic, copy)   NSString    *cate_name;
@property (nonatomic, copy)   NSString    *cate_sname;

@end
