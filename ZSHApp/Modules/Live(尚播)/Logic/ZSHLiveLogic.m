
//
//  ZSHLiveLogic.m
//  ZSHApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveLogic.h"


@implementation ZSHLiveLogic

// 关注
- (void)requestFriendList:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlFriendList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        weakself.friendListModelArr = [ZSHFriendListModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        RLog(@"%@",responseObject);
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 粉丝
- (void)requestReFriendList:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlRefriendList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        weakself.friendListModelArr = [ZSHFriendListModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        RLog(@"%@",responseObject);
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 发布内容到我的圈子
- (void)requestAddCircle:(NSDictionary *)dic images:(NSArray *)images fileNames:(NSArray *)fileNmaes success:(void (^)(id response))success {
    [PPNetworkHelper uploadImagesWithURL:kUrlAddCircle parameters:dic name:@"fileList" images:images fileNames:fileNmaes imageScale:1.0 imageType:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {

    }];

}


// 获取我和我关注的好友的所有圈子并根据时间排序
- (void)requestCircleList:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlCircleList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        weakself.weiboCellModelArr = [ZSHWeiBoCellModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(weakself.weiboCellModelArr);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}


// 点赞 
- (void)requestDotAgreeWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlDotAgree parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}


// 通过圈子ID获取所有评论
- (void)requestCommentListWithCircleID:(NSString *)circleID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlCommentList parameters:@{@"CIRCLE_ID":circleID} success:^(id responseObject) {
        NSArray *array = [ZSHCommentListModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(array);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 通过圈子ID评论 
- (void)requestAddCommentWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlAddComment parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 获取话题列表(含模糊查询)
- (void)requestGetTopicListWithTitle:(NSString *)title success:(void (^)(id response))success {

    [PPNetworkHelper POST:kUrGetTopicList parameters:@{@"TITLE":title} success:^(id responseObject) {
         NSArray *arr = [ZSHWeiboTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(arr);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 添加话题
- (void)requestAddTopicWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrAddTopic parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}


@end
