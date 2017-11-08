//
//  ZSHBaseTableViewSectionModel.m
//  SigmaTableViewModel
//
//  Created by yangke on 8/25/15.
//  Copyright (c) 2015 yangke. All rights reserved.
//

#import "ZSHBaseTableViewSectionModel.h"

@implementation ZSHBaseTableViewSectionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerHeight = 0;
        self.footerHeight = 0;
        self.cellModelArray = [NSMutableArray array];
    }
    return self;
}

@end
