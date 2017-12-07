//
//  ZSHWeiBoCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
#import "ZSHWeiBoCellModel.h"

typedef NS_ENUM(NSUInteger,ZSHFromVCToWeiBoCell){
    ZSHWeiboVCToWeiBoCell,           //黑微博-自定义cell
    ZSHGoodsCommentSubVCToWeiBoCell,  //商品评价-自定义cell
    ZSHFromNoneVCToWeiBoCell,
};

@interface ZSHWeiBoCell : ZSHBaseCell


- (CGFloat)getCellHeightWithModel:(ZSHWeiBoCellModel *)model;

@end
