//
//  ZSHGoodsDetailViewController.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"
@class ZSHGoodModel;
@interface ZSHGoodsDetailViewController : RootViewController

/* 商品标题 */
@property (strong , nonatomic)NSString *goodTitle;
/* 商品价格 */
@property (strong , nonatomic)NSString *goodPrice;
/* 商品小标题 */
@property (strong , nonatomic)NSString *goodSubtitle;
/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;

/* 商品轮播图 */
@property (strong , nonatomic)NSArray *shufflingArray;

@property (nonatomic, strong) ZSHGoodModel   *goodModel;

@end
