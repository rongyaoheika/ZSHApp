//
//  ZSHBaseLogic.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestDataCompleted) (id);

@interface ZSHBaseLogic : NSObject

@property (nonatomic, strong) NSArray                  *dataArr;
@property (nonatomic, strong) NSMutableArray           *mDataArr;
@property (nonatomic, copy)   RequestDataCompleted     requestDataCompleted;
- (void)requestData;

@end
