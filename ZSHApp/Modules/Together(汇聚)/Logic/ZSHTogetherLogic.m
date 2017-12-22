//
//  ZSHTogetherLogic.m
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHTogetherLogic.h"


@implementation ZSHTogetherLogic
- (instancetype)init {
    if (self == [super init]) {
        _enterDisModel = [[ZSHEnterDisModel alloc] init];
    }
    return self;
}


// 获取汇聚列表
- (void)requestConvergeList:(void(^)(id ))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlConvergeList parameters:@{} success:^(id responseObject) {
        weakself.togertherDataArr = [ZSHTogetherModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 获得指定汇聚下所有聚会列表 (我发布,我参与) 
- (void)requestPartyListWithDic:(NSDictionary *)dic success:(void(^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetPartyList parameters:dic success:^(id responseObject) {
        weakself.entertainModelArr = [ZSHEntertainmentModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}


// 获取聚会详情
- (void)requestPartyListWithConvergeDetailID:(NSString *)convergeDetailID success:(void(^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetDetaiByID parameters:@{@"CONVERGEDETAIL_ID":convergeDetailID} success:^(id responseObject) {
        weakself.enterDisModel = [ZSHEnterDisModel mj_objectWithKeyValues:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

// 发布聚会
- (void)requestAddDetailParty:(NSDictionary *)dic images:(NSArray *)images fileNames:(NSArray *)fileNmaes  success:(void(^)(id response))success {
    [PPNetworkHelper uploadImagesWithURL:kUrlAddDetailParty parameters:dic name:@"fileList" images:images fileNames:fileNmaes imageScale:1.0 imageType:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        
    }];

//    [PPNetworkHelper POST:kUrlAddDetailParty parameters:dic success:^(id responseObject) {
//        success(responseObject);
//    } failure:^(NSError *error) {
//        RLog(@"请求失败");
//    }];
}
// 加入聚会
- (void)requestAddOtherPartyWithConvergeDetailID:(NSString *)convergeDetailID success:(void(^)(id response))success {
    [PPNetworkHelper POST:kUrlAddOtherParty parameters:@{@"CONVERGEDETAIL_ID":convergeDetailID, @"HONOURUSER_ID":HONOURUSER_IDValue} success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
    
}


// 添加朋友
- (void)requestAddFriendWithReHonouruserID:(NSString *)reHonouruserID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlAddFriend parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"REHONOURUSER_ID":reHonouruserID} success:^(id responseObject) {
        RLog(@"%@",responseObject);
        //responseObject[@"pd"];
        success(nil);
        
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

// 删除好友
- (void)requestDelFriendWithReHonouruserID:(NSString *)reHonouruserID success:(void (^)(id response))success {
    [PPNetworkHelper POST:kUrlDelFriend parameters:@{@"HONOURUSER_ID":HONOURUSER_IDValue, @"REHONOURUSER_ID":@"382890302907613184"} success:^(id responseObject) {
        RLog(@"%@",responseObject);
        //responseObject[@"pd"];
        success(nil);
        
    } failure:^(NSError *error) {
        RLog(@"%@", error);
    }];
}

@end
