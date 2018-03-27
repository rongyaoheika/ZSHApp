//
//  ShareManager.h
//  MiAiApp
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

/**
 分享 相关服务
 */
@interface ShareManager : NSObject


typedef void (^ZSHShareCallback)(BOOL flag);
//单例
SINGLETON_FOR_HEADER(ShareManager)

- (void)shareToPlatform:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr image:(UIImage *)image url:(NSString *)url controller:(UIViewController *)controller callback:(ZSHShareCallback)callback;
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType controller:(UIViewController *)vc;
/**
 展示分享页面
 */
-(void)showShareView;
@end
