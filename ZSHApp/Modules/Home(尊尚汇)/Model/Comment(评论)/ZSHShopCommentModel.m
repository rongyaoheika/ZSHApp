//
//  ZSHShopCommentModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHShopCommentModel.h"
#import "ZSHShopCommentCell.h"
@implementation ZSHShopCommentModel

-(CGFloat)cellHeight
{
    if(!_cellHeight){
        ZSHShopCommentCell *cell = [[ZSHShopCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSHShopCommentCellID"];
        // 调用cell的方法计算出高度
        _cellHeight = [cell rowHeightWithCellModel:self];
    }
    return _cellHeight;
}

@end
