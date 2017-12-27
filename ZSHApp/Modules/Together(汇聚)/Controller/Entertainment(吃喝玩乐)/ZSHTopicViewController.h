//
//  ZSHTopicViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/12/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef void (^DidSelectRowBlock)(NSString *topicTitle);

@interface ZSHTopicViewController : RootViewController

@property (nonatomic, copy) DidSelectRowBlock   didSelectRow;

@end
