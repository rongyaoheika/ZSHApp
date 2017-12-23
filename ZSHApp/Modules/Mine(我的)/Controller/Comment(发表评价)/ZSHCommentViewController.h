//
//  ZSHCommentViewController.h
//  ZSHApp
//
//  Created by Apple on 2017/11/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSUInteger,ZSHFromVCToCommentVC){
    ZSHromAllOrderVCToCommentVC,          //我的订单-售后
    ZSHFromGoodsMineVCToCommentVC,        //我的订单-退款售后
    ZSHFromShopCommentVCToCommentVC,      //酒店详情评论-退款售后
};

@interface ZSHCommentViewController : RootViewController

@end
