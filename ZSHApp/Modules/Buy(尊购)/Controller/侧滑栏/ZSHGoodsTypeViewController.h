//
//  ZSHGoodsTypeViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"


typedef NS_ENUM(NSInteger,ZSHToGoodsTitleVC){
    FromBuyVCToGoodsTitleVC,              // 尊购
    FromGoodsVCToGoodsTitleVC,            // 商品分类
    FromSearchResultVCTOGoodsTitleVC,     // 尊购顶部搜索
    FromNoneToGoogsTitleVC
};

@interface ZSHGoodsTypeViewController : RootViewController

@property (nonatomic,assign) ZSHCellType   cellType;
- (void)reloadUIWithCellType:(ZSHCellType)cellType;

@end
