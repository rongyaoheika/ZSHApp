//
//  ZSHMultiInfoViewController.h
//  RLJKApp
//
//  Created by zhaoweiwei on 2017/9/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef void(^SaveBlock)(id , NSInteger );

@interface ZSHMultiInfoViewController : RootViewController

@property (nonatomic, copy)   SaveBlock saveBlock;
@property (nonatomic, assign) NSInteger index;

@end
