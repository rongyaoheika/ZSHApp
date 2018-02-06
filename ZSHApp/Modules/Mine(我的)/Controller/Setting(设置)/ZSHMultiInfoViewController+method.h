//
//  ZSHMultiInfoViewController+method.h
//  ZSHApp
//
//  Created by mac on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHMultiInfoViewController.h"

@interface ZSHMultiInfoViewController (method)
//创建门店前校验
- (BOOL)createStoreAction;
//提交审核前校验
- (BOOL)submitCheckAction;
//提交审核
- (void)submitActionWithDic:(NSDictionary *)paramDic;
@end
