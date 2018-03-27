//
//  ZSHBaseFunction.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseFunction.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZSHBaseFunction

+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)getFKEYWithCommand:(NSString *)cmd {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *string = [formatter stringFromDate:date];
    
    return [ZSHBaseFunction md5StringFromString:[NSString stringWithFormat:@"%@%@,fh,",cmd,string]];
}

+ (NSString *)base64StringFromString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return base64String;
}

//底部弹出框消失
+ (void)dismissPopView:(UIView *)customView block:(void(^)())completion{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect moreViewFrame = customView.frame;
        moreViewFrame.origin.y = KScreenHeight;
        customView.frame = moreViewFrame;
    } completion:^(BOOL finished) {
        [customView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

//底部弹出view
+ (void)showPopView:(UIView *)customView frameY:(CGFloat)frameY{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect customViewFrame = customView.frame;
        if (frameY>0) {
            customViewFrame.origin.y = frameY;
        } else {
            customViewFrame.origin.y = KScreenHeight - customViewFrame.size.height;
        }
       
        customView.frame = customViewFrame;
    } completion:nil];
}

//手机号判断
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13,14,15,18,17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-345-9]|7[013678])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//身份证号判断
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//键盘设置
+ (void)initKeyboard{
    // 获取类库的单例变量
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    //启用自动键盘处理事件
    keyboardManager.enable = YES;
    //点击背景收起键盘
    keyboardManager.shouldResignOnTouchOutside = YES;
    //隐藏键盘上的工具条
    keyboardManager.enableAutoToolbar = NO;
    // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    // 输入框距离键盘的距离
    keyboardManager.keyboardDistanceFromTextField = 10.0f;
    
}




@end
