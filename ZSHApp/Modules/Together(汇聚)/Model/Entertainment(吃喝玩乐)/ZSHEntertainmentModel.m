//
//  ZSHEntertainmentModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHEntertainmentModel.h"
#import "ZSHEnterTainmentCell.h"
@implementation ZSHEntertainmentModel

-(CGFloat)cellHeight
{
    //只在初始化的时候调用一次就Ok
    if(!_cellHeight){
        ZSHEnterTainmentCell *cell = [[ZSHEnterTainmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSHEnterTainmentCellID"];
        _cellHeight = [cell rowHeightWithCellModel:self];
    }
    return _cellHeight;
}

@end
