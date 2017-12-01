//
//  ZSHHotelModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHHotelModel.h"
#import "ZSHHotelCell.h"

@implementation ZSHHotelModel

-(CGFloat)cellHeight
{
    //只在初始化的时候调用一次就Ok
    if(!_cellHeight){
        ZSHHotelCell *cell = [[ZSHHotelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSHHotelCellID"];
        // 调用cell的方法计算出高度
        _cellHeight = [cell rowHeightWithCellModel:self];
    }
    return _cellHeight;
}
@end

@implementation ZSHHotelDetailModel

@end

@implementation ZSHHotelDetailListModel
@end


