//
//  ZSHLiveLogic.h
//  ZSHApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseLogic.h"
#import "ZSHFriendListModel.h"
#import "ZSHWeiBoCellModel.h"
#import "ZSHCommentListModel.h"

@interface ZSHLiveLogic : ZSHBaseLogic

@property (nonatomic, strong) NSArray<ZSHFriendListModel *>   *friendListModelArr;
@property (nonatomic, strong) NSArray<ZSHWeiBoCellModel *>    *weiboCellModelArr;

// 关注
- (void)requestFriendList:(void (^)(id response))success;
// 粉丝
- (void)requestReFriendList:(void (^)(id response))success;
// 发布内容到我的圈子
- (void)requestAddCircle:(NSDictionary *)dic images:(NSArray *)images fileNames:(NSArray *)fileNmaes success:(void (^)(id response))success;
// 获取我和我关注的好友的所有圈子并根据时间排序
- (void)requestCircleList:(void (^)(id response))success;
// 获取我和我关注的好友的所有圈子并根据时间排序
- (void)requestDotAgreeWithCircleID:(NSString *)circleID success:(void (^)(id response))success;
// 通过圈子ID获取所有评论
- (void)requestCommentListWithCircleID:(NSString *)circleID success:(void (^)(id response))success;

// 通过圈子ID评论
- (void)requestAddCommentWithDic:(NSDictionary *)dic success:(void (^)(id response))success;

@end
