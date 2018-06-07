//
//  ShareManager.m
//  MiAiApp
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ShareManager.h"


@implementation ShareManager

SINGLETON_FOR_CLASS(ShareManager);

//显示分享面板
-(void)showShareView{
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType controller:nil];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    } else {
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        } else {
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享结果"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

//分享网页
- (void)shareToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr image:(UIImage *)image url:(NSString *)url controller:(UIViewController *)controller callback:(ZSHShareCallback)callback
{
    UMSocialMessageObject *messageObj = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    //设置网页地址
    shareObject.webpageUrl = KRedirectURL;
    
    //分享消息对象设置分享内容对象
    messageObj.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObj currentViewController:controller completion:^(id result, NSError *error) {
        if(!error) {
            RLog(@"response data is %@",result);
            callback(YES);
        } else {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            RLog("分享失败error====%@",error);
            [self alertWithError:error];
        }
    }];
    
}

@end
