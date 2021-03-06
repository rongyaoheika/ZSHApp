//
//  ZSHTogetherLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHTogetherModel.h"
#import "ZSHEntertainmentModel.h"
#import "ZSHEnterDisModel.h"

@interface ZSHTogetherLogic : ZSHBaseLogic


@property (nonatomic, strong) NSArray<ZSHTogetherModel*>          *togertherDataArr;
@property (nonatomic, strong) NSArray<ZSHEntertainmentModel*>     *entertainModelArr;
// 发布和详情
@property (nonatomic, strong) ZSHEnterDisModel                    *enterDisModel;

// 获取汇聚列表
- (void)requestConvergeList:(void(^)(id response))success;
// 获得指定汇聚下所有聚会列表 (我发布,我参与)
- (void)requestPartyListWithDic:(NSDictionary *)dic success:(void(^)(id response))success;
// 获得指定某个类型下汇聚下所有聚会列表 (我发布,我参与)
- (void)requestSinglePartyListWithDic:(NSDictionary *)dic success:(void(^)(id response))success;
// 获取聚会详情
- (void)requestPartyListWithConvergeDetailID:(NSString *)convergeDetailID success:(void(^)(id response))success;
// 发布聚会
- (void)requestAddDetailParty:(NSDictionary *)dic success:(void(^)(id response))success;
// 加入聚会
- (void)requestAddOtherPartyWithConvergeDetailID:(NSString *)convergeDetailID success:(void(^)(id response))success;
// 添加朋友
- (void)requestAddFriendWithReHonouruserID:(NSString *)reHonouruserID success:(void (^)(id response))success;
// 删除好友
- (void)requestDelFriendWithReHonouruserID:(NSString *)reHonouruserID success:(void (^)(id response))success;
// 发布聚会
- (void)requestAddDetailParty:(NSDictionary *)dic images:(NSArray *)images fileNames:(NSArray *)fileNmaes  success:(void(^)(id response))success;
// 根据广告栏位置查询广告
- (void)requestAdvertiseListWithAdPosition:(NSString *)AD_POSITION success:(void (^)(id response))success;
// 修改点击广告的次数
- (void)requestEditClickCountWithADVERTISEMENT_ID:(NSString *)ADVERTISEMENT_ID success:(void (^)(id response))success;

//吃喝玩乐类型
- (void)requestTogetherDataTypeWithACONVERGE_ID:(NSString *)CONVERGE_ID success:(void (^)(id response))success;

@end
