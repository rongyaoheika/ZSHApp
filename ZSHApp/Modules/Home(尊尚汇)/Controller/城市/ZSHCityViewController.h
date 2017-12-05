//
//  ZSHCityViewController.h
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef void(^SaveCityBlock)(NSString *city);

@interface ZSHCityViewController : RootViewController

@property (nonatomic, copy) SaveCityBlock saveCityBlock;

@end
