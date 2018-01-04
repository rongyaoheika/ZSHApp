//
//  ZSHTopicViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger,ZSHTopicVC){
    FromWeiboVCToTopicVC,                             // 尚播-微博
    FromTogetherToTopicVC,                            // 汇聚-吃喝玩乐
    FromNoneToTopicVC
};


typedef void (^DidSelectRowBlock)(NSString *topicTitle, NSString *);

@interface ZSHTopicViewController : RootViewController

@property (nonatomic, copy) DidSelectRowBlock   didSelectRow;

@end
