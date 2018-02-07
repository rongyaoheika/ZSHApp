
//
//  ZSHLiveLogic.m
//  ZSHApp
//
//  Created by apple on 2017/12/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLiveLogic.h"


@implementation ZSHLiveLogic
//老接口
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
    [PPNetworkHelper uploadImagesWithURL:kUrlAddCircle parameters:dic names:@[@"fileList"] images:images fileNames:fileNmaes imageScale:1.0 imageType:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {

    }];

}

// 商家发布自媒体广告流-单独上传视频
- (void)requestUpVideoWithDic:(NSDictionary *)dic withFilePath:(NSString *)filePath thumb:(UIImage *)thumb success:(void (^)(id response))success {
    [PPNetworkHelper uploadFileWithURL:kUrlAddSelfMediaad parameters:dic name:@"showfile" filePath:filePath thumb:thumb progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        
    }];
}


// 商家发布自媒体广告流
- (void)requestAddSelfMediaAD:(NSDictionary *)dic images:(NSArray *)images fileNames:(NSArray *)fileNmaes success:(void (^)(id response))success {
    [PPNetworkHelper uploadImagesWithURL:kUrlAddSelfMediaad parameters:dic names:@[@"fileList"] images:images fileNames:fileNmaes imageScale:1.0 imageType:nil progress:^(NSProgress *progress) {
        
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

    [PPNetworkHelper POST:kUrlGetTopicList parameters:@{@"TITLE":title} success:^(id responseObject) {
         NSArray *arr = [ZSHWeiboTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(arr);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 添加话题
- (void)requestAddTopicWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlAddTopic parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

//获取推流地址
- (void)requestPushAddressWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetPushAddress parameters:dic success:^(id responseObject) {
        RLog(@"推流地址==%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"推流地址获取失败%@", error);
    }];
}

//获取推荐分类拉流列表地址
- (void)requestRecommendPushAddressListWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetPushList parameters:dic success:^(id responseObject) {
        
        RLog(@"拉流列表地址==%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"拉流列表地址获取失败%@", error);
    }];
}

//获取附近拉流列表地址
- (void)requestNearPushAddressListWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetNearbyPushList parameters:dic success:^(id responseObject) {
        
        RLog(@"附近拉流列表地址==%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"拉流列表地址获取失败%@", error);
    }];
}

//获取单个拉流地址
- (void)requestPullAddressWithDic:(NSDictionary *)dic Success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetPullAddress parameters:dic success:^(id responseObject) {
        RLog(@"拉流地址==%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"拉流地址获取失败%@", error);
    }];
}

//获取直播分类数据
- (void)requestkUrlGetLiveTypeListWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetLiveTypeList parameters:dic success:^(id responseObject) {
        RLog(@"直播分类==%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"直播分类数据获取失败%@", error);
    }];
}

//附近-筛选直播
- (void)requestScreenListWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetScreenList parameters:dic success:^(id responseObject) {
        RLog(@"附近筛选直播%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"附近筛选直播失败%@", error);
    }];
}

//直播搜索
- (void)requestLiveSearhWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetUserList parameters:dic success:^(id responseObject) {
        RLog(@"附近筛选直播%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"附近筛选直播失败%@", error);
    }];
}

//直播送礼物
- (void)requesGiftToUserWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGiftToUser parameters:dic success:^(id responseObject) {
        RLog(@"直播送礼物数据%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"直播送礼物数据失败%@", error);
    }];
}

//直播用户资料
- (void)requestLiveUserDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetLiveUserData parameters:dic success:^(id responseObject) {
        RLog(@"直播用户资料%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"直播用户资料失败%@", error);
    }];
}

//直播页面点击头像显示的简洁个人资料
- (void)requestLivePithyDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetPithyData parameters:dic success:^(id responseObject) {
        RLog(@"直播用户简介资料%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"直播用户简介资料失败%@", error);
    }];
}

//直播个人资料上部分个人资料
- (void)requestLiveUserTopDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetLiveUserData parameters:dic success:^(id responseObject) {
        RLog(@"直播用户简介资料%@",responseObject);
        success(responseObject[@"pd"]);
    } failure:^(NSError *error) {
        RLog(@"直播用户简介资料失败%@", error);
    }];
}

//直播个人资料下部分个人资料
- (void)requestLiveUserDownDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetDownData parameters:dic success:^(id responseObject) {
        RLog(@"直播用户简介资料%@",responseObject);
        success(responseObject[@"pd"]);
    } failure:^(NSError *error) {
        RLog(@"直播用户简介资料失败%@", error);
    }];
}

//直播-我的资料
- (void)requestLiveMineDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetMineData parameters:dic success:^(id responseObject) {
        RLog(@"直播用户简介资料%@",responseObject);
        success(responseObject[@"pd"]);
    } failure:^(NSError *error) {
        RLog(@"直播用户简介资料失败%@", error);
    }];
}

//直播-微博数据
- (void)requestLiveWeiboDataWithDic:(NSDictionary *)dic success:(void (^)(id response))success{
    [PPNetworkHelper POST:kUrlGetWeiboUser parameters:dic success:^(id responseObject) {
        RLog(@"直播-黑微博数据%@",responseObject);

        NSArray *weiboCellModelArr = [ZSHWeiBoCellModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(weiboCellModelArr);
    } failure:^(NSError *error) {
        RLog(@"直播-黑微博数据失败%@", error);
    }];
}
//泓磊：直播-我的-关注，粉丝接口
// 关注
- (void)requestFocusList:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetFocusList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        weakself.friendListModelArr = [ZSHFriendListModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        RLog(@"%@",responseObject);
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 粉丝
- (void)requestFansList:(void (^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetFansList parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        weakself.friendListModelArr = [ZSHFriendListModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        RLog(@"%@",responseObject);
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 贡献榜
- (void)requestRankWithDic:(NSDictionary *)dic success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlGetRankList parameters:dic success:^(id responseObject) {
//        weakself.friendListModelArr = [ZSHFriendListModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        RLog(@"贡献榜==%@",responseObject);
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

@end
