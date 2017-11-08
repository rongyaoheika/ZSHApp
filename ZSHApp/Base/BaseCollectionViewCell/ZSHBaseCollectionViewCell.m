//
//  ZSHBaseCollectionViewCell.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCollectionViewCell.h"
#import "ZSHBaseModel.h"

@implementation ZSHBaseCollectionViewCell

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

- (void)updateCellWithParamDic:(NSDictionary *)dic{
    
}

- (void)updateCellWithModel:(ZSHBaseModel *)model{
    
}

@end
