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
#import "ZSHWeiboTopicModel.h"

@interface ZSHLiveLogic : ZSHBaseLogic


@property (nonatomic, strong) NSArray<ZSHWeiBoCellModel *>    *weiboCellModelArr;

// 发布内容到我的圈子
- (void)requestAddCircle:(NSDictionary *)dic images:(NSArray *)images fileNames:(NSArray *)fileNmaes success:(void (^)(id response))success;
// 商家发布自媒体广告流-单独上传视频
- (void)requestUpVideoWithDic:(NSDictionary *)dic withFilePath:(NSString *)filePath thumb:(UIImage *)thumb success:(void (^)(id response))success;
// 商家发布自媒体广告流
- (void)requestAddSelfMediaAD:(NSDictionary *)dic images:(NSArray *)images fileNames:(NSArray *)fileNmaes success:(void (^)(id response))success;
// 获取我和我关注的好友的所有圈子并根据时间排序
- (void)requestCircleList:(void (^)(id response))success;
// 点赞
- (void)requestDotAgreeWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 通过圈子ID获取所有评论
- (void)requestCommentListWithCircleID:(NSString *)circleID success:(void (^)(id response))success;
// 通过圈子ID评论
- (void)requestAddCommentWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 获取话题列表(含模糊查询)
- (void)requestGetTopicListWithTitle:(NSString *)title success:(void (^)(id response))success;
// 添加话题
- (void)requestAddTopicWithDic:(NSDictionary *)dic success:(void (^)(id response))success;




// 获取推流地址
- (void)requestPushAddressWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 获取推荐拉流列表地址
- (void)requestRecommendPushAddressListWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
// 获取附近拉流列表地址
- (void)requestNearPushAddressListWithDic:(NSDictionary *)dic success:(void (^)(id response))success;

//获取拉流地址
- (void)requestPullAddressWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//获取直播分类数据
- (void)requestkUrlGetLiveTypeListWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//附近-筛选直播
- (void)requestScreenListWithDic:(NSDictionary *)dic success:(void (^)(id response))success;

//直播搜索
- (void)requestLiveSearhWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//直播送礼物
- (void)requesGiftToUserWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//直播用户资料
- (void)requestLiveUserDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//直播页面点击头像显示的简洁个人资料
- (void)requestLivePithyDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//直播个人资料上部分个人资料
- (void)requestLiveUserTopDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//直播个人资料下部分个人资料
- (void)requestLiveUserDownDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//直播-我的资料
- (void)requestLiveMineDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//直播-黑微博数据
- (void)requestLiveWeiboDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//泓磊：直播-我的-关注，粉丝接口
// 关注
- (void)requestFocusList:(void (^)(id response))success;
// 粉丝
- (void)requestFansList:(void (^)(id response))success;
// 贡献榜
- (void)requestRankWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//用户点进直播间时请先调用该接口
- (void)requestNumOfTimesWithDic:(NSDictionary *)dic success:(void (^)(id response))success;
//查看任务中心任务完成情况
- (void)requestTaskStatusWithDic:(NSDictionary *)dic success:(void (^)(id response))success;

@end
