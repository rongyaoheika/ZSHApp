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
@property (nonatomic, strong) NSArray       *partyArr;
@property (nonatomic, strong) NSArray       *musicArr;
@property (nonatomic, strong) NSArray       *magzineArr;

//新闻推荐列表
- (void)loadNoticeCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
//荣耀服务列表
- (void)loadServiceCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
//新闻轮播数据
- (void)loadNewsCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
//汇聚玩趴图片
- (void)loadPartyCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
//音乐列表
- (void)loadMusicCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
//更多特权列表
- (void)loadMorePrivilege;
//杂志列表
- (void)loadMagzineCellDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail;
// 杂志详情
- (void)loadMagzineOneWithDic:(NSDictionary *)dic success:(void(^)(id response))success;
//搜索推荐数据
- (void)loadSearchListWithDic:(NSDictionary *)dic success:(void(^)(id response))success;
// 杂志列表
- (void)loadMagzineListSubMenuWithMenuID:(NSDictionary *)dic success:(void(^)(id response))success;
//蒲公英更新
- (void)loadUpdateWithDic:(NSDictionary *)dic success:(void(^)(id response))success;
@end
