//
//  ZSHManageAddressListViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/18.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef void (^GetIndex)(NSInteger);

@interface ZSHManageAddressListViewController : RootViewController

@property (nonatomic, copy) GetIndex  getIndex;

@end
