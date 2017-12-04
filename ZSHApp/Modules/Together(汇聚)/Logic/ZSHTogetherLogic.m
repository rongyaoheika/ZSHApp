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


- (void)requestConvergeList:(void(^)(id ))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlConvergeList parameters:@{} success:^(id responseObject) {
        weakself.dataArr = [ZSHTogetherModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)requestPartyListWithConvergeID:(NSString *)convergeID success:(void(^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetPartyList parameters:@{@"CONVERGE_ID":convergeID, @"HONOURUSER_ID":@"", @"STATUS":@""} success:^(id responseObject) {
        weakself.entertainModelArr = [ZSHEntertainmentModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)requestPartyListWithConvergeDetailID:(NSString *)convergeDetailID success:(void(^)(id response))success {
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlGetDetaiByID parameters:@{@"CONVERGEDETAIL_ID":convergeDetailID} success:^(id responseObject) {
        weakself.enterDetilModelArr = [ZSHEnterDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"pd"]];
        success(nil);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

- (void)requestAddDetailParty:(NSDictionary *)dic success:(void(^)(id response))success {
    [PPNetworkHelper POST:kUrlAddDetailParty parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        RLog(@"请求失败");
    }];
}

@end
