//
//  ZSHFoodModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHFoodModel : ZSHBaseModel

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *comment;

//详情
@property (nonatomic, copy) NSString *detailImageName;
@property (nonatomic, copy) NSString *foodName;
@property (nonatomic, assign) CGFloat    cellHeight;
@end
