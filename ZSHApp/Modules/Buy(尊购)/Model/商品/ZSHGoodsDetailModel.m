//
//  ZSHGoodsDetailModel.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHGoodsDetailModel.h"
#import "ZSHGoodsDetailSubCell.h"

@implementation ZSHGoodsDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"detailPicture":@"SHOWIMG",
             @"detailText":@"CONTENT"};
}

//惰性初始化是这样写的
-(CGFloat)cellHeight
{
    //只在初始化的时候调用一次就Ok
    if(!_cellHeight){
//        ZSHGoodsDetailSubCell *cell = [[ZSHGoodsDetailSubCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZSHGoodsDetailSubCell"];
        
         ZSHGoodsDetailSubCell *cell = [[ZSHGoodsDetailSubCell alloc]init];
        // 调用cell的方法计算出高度
        _cellHeight = [cell rowHeightWithCellModel:self];
    }
    return _cellHeight;
}

@end
