//
//  ZSHBuyOrderModel.h
//  ZSHApp
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHBuyOrderModel : ZSHBaseModel

//订单地址
@property (nonatomic, copy) NSString *ORDERADDRESS;
//订单总金额
@property (nonatomic, copy) NSString *ORDERMONEY;
//配送方式
@property (nonatomic, copy) NSString *ORDERDELIVERY;
//用户id
@property (nonatomic, copy) NSString *HONOURUSER_ID;
//生成订单的商品id
@property (nonatomic, copy) NSString *PRODUCT_ID;
//商品数量
@property (nonatomic, copy) NSString *PRODUCTCOUNT;


@end
