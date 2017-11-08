//
//  ZSHNoticeViewCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"

typedef void (^ItemClickBlock)(NSInteger);

@interface ZSHNoticeViewCell : ZSHBaseCell 

@property (nonatomic,copy) ItemClickBlock  itemClickBlock;

@end
