//
//  ZSHMultiInfoViewController+method.m
//  ZSHApp
//
//  Created by mac on 2018/2/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZSHMultiInfoViewController+method.h"

@implementation ZSHMultiInfoViewController (method)

//创建门店前校验
- (BOOL)createStoreAction{//信息是否输入
    if (!self.text1.length || !self.text2.length || !self.text3.length || !self.text4.length) {//其中一行为空
        UIAlertView *promptAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息填写不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [promptAlert show];
        return NO;
    } else {
        //手机号码校验
        if (![ZSHBaseFunction validateMobile:self.text4]) {
            UIAlertView *phoneAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"门店电话格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [phoneAlert show];
        }
        return [ZSHBaseFunction validateMobile:self.text4];
    }
    return YES;
}

//提交审核
- (void)submitActionWith:(NSDictionary *)paramDic{
    [self.entryLogic loadBusinessInDataWith:paramDic success:^(id responseObject) {
        
    } fail:nil];
}
@end
