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

- (void)loadNoticeCellData;
- (void)loadServiceCellData;
- (void)loadServiceDetailDataWithParamDic:(NSDictionary *)paramDic;
- (void)loadNewsCellData;
- (void)loadPartyCellData;
- (void)loadMorePrivilege;

@end
