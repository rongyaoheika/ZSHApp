//
//  ZSHFoodModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHFoodModel.h"
#import "ZSHFoodCell.h"
@implementation ZSHFoodModel


-(CGFloat)cellHeight
{
    //只在初始化的时候调用一次就Ok
    if(!_cellHeight){
        ZSHFoodCell *cell = [[ZSHFoodCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSHFoodCellID"];
        // 调用cell的方法计算出高度
        _cellHeight = [cell rowHeightWithCellModel:self];
    }
    return _cellHeight;
}

@end

@implementation ZSHFoodDetailModel
@end

