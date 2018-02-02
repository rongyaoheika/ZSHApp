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

@end
