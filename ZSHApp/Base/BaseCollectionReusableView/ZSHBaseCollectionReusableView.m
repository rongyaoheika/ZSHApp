//
//  ZSHBaseCollectionReusableView.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCollectionReusableView.h"

@implementation ZSHBaseCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KClearColor;
        [self setup];
    }
    return self;
}

- (void)setup{
    
}

@end
