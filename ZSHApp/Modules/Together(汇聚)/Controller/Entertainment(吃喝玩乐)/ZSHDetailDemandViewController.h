//
//  ZSHDetailDemandViewController.h
//  ZSHApp
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef void(^SaveBlock)(id, id, id);

@interface ZSHDetailDemandViewController : RootViewController

@property (nonatomic, copy) SaveBlock saveBlock;

@end
