//
//  ZSHGuideLogic.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGuideLogic.h"

@implementation ZSHGuideLogic

- (void)requestData{
    kWeakSelf(self);
    [PPNetworkHelper POST:kUrlBootpagelist parameters:nil success:^(id responseObject) {
        RLog(@"引导页图片数据==%@",responseObject);
        NSArray *dataArr = responseObject[@"pd"];
        if (weakself.requestDataCompleted) {
            NSMutableArray *imageArr = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in dataArr) {
                [imageArr addObject:dic[@"SHOWIMG"]];
            }
            weakself.requestDataCompleted(imageArr);
        
        }
        
    } failure:^(NSError *error) {
        if (weakself.requestDataCompleted) {
            weakself.requestDataCompleted(@"fail");
        }
    }];
    
}

@end
