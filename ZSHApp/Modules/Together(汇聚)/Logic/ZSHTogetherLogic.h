//
//  ZSHTogetherLogic.h
//  ZSHApp
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHLoginLogic.h"
#import "ZSHTogetherModel.h"
#import "ZSHEntertainmentModel.h"
#import "ZSHEnterDetailModel.h"
#import "ZSHEnterDisModel.h"

@interface ZSHTogetherLogic : ZSHLoginLogic


@property (nonatomic, strong) NSArray<ZSHTogetherModel*>          *dataArr;
@property (nonatomic, strong) NSArray<ZSHEntertainmentModel*>     *entertainModelArr;
@property (nonatomic, strong) NSArray<ZSHEnterDetailModel*>       *enterDetilModelArr;
@property (nonatomic, strong) ZSHEnterDisModel                    *enterDisModel;

- (void)requestConvergeList:(void(^)(id response))success;
- (void)requestPartyListWithConvergeID:(NSString *)convergeID success:(void(^)(id response))success;
- (void)requestPartyListWithConvergeDetailID:(NSString *)convergeDetailID success:(void(^)(id response))success;
- (void)requestAddDetailParty:(NSDictionary *)dic success:(void(^)(id response))success;
@end
