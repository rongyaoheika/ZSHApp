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

//提交审核前校验
- (BOOL)submitCheckAction{
    if (!self.text1.length || !self.text2.length || !self.text3.length || !self.text4.length || !self.text5.length || !self.text6.length) {//其中一行为空
        UIAlertView *promptAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息填写不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [promptAlert show];
        return NO;
    } else {
     if (![ZSHBaseFunction validateIdentityCard:self.text1]) {
        //身份证号校验
        UIAlertView *phoneAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [phoneAlert show];
        return NO;
    } else if (![ZSHBaseFunction validateMobile:self.text6]) {
        //手机号码校验
        UIAlertView *phoneAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"门店电话格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [phoneAlert show];
        return NO;
    } else if ([self.imageText1 isEqualToString:@"待完善"]||[self.imageText2 isEqualToString:@"待完善"]||[self.imageText3 isEqualToString:@"待完善"]){
        //手机号码校验
        UIAlertView *imagAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片上传不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [imagAlert show];
    }
    }
    return YES;
}

//提交审核
- (void)submitActionWithDic:(NSDictionary *)paramDic{
    [self.entryLogic loadBusinessInDataWith:paramDic success:^(id responseObject) {
        RLog(@"提交审核结果%@",responseObject);
    } fail:nil];
}
@end
