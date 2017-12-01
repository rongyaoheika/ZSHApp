//
//  ZSHHomeLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHHomeMainModel.h"
#import "ZSHPrivlegeModel.h"

@interface ZSHHomeLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray       *newsArr;
@property (nonatomic, strong) NSArray       *noticeArr;
@property (nonatomic, strong) NSArray       *serviceArr;
@property (nonatomic, strong) NSDictionary  *partyDic;
@property (nonatomic, strong) NSArray       *musicArr;

- (void)loadNoticeCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
- (void)loadServiceCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
- (void)loadNewsCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
- (void)loadPartyCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
- (void)loadServiceDetailDataWithParamDic:(NSDictionary *)paramDic;
- (void)loadNewsCellData;
- (void)loadPartyCellData;
- (void)loadMorePrivilege;
- (void)loadMusicCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
@end
