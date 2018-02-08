//
//  ZSHEntryLogic.m
//  ZSHApp
//
//  Created by mac on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHEntryLogic.h"

@implementation ZSHEntryLogic

//商家入驻
- (void)loadBusinessInDataWith:(NSDictionary *)dic names:(NSArray *)names images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames success:(ResponseSuccessBlock)success fail:(ResponseFailBlock)fail{
    RLog(@"请求参数==%@",dic);
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper uploadImagesWithURL:kUrlAppBusinessIn parameters:dic names:names images:images fileNames:fileNames imageScale:1.0 imageType:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        
    }];
}

@end
