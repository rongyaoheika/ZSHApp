//
//  ZSHGuideLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGuideLogic.h"

@implementation ZSHGuideLogic

-(void)requestGuideDataSuccess:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    [PPNetworkHelper POST:kUrlBootPageList parameters:nil success:^(id responseObject) {
        RLog(@"引导页数据==%@",responseObject);
        NSArray *dataArr = responseObject[@"pd"];
        NSMutableArray *imageArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in dataArr) {
            [imageArr addObject:dic[@"SHOWIMG"]];
        }
        success(imageArr);
        
    } failure:^(NSError *error) {

    }];
}

@end
