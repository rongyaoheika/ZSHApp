//
//  ZSHAddrModel.h
//  ZSHApp
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHAddrModel : ZSHBaseModel

/** 手机 */
@property (nonatomic, copy) NSString *ADRPHONE;
/** 地址 */
@property (nonatomic, copy) NSString *ADDRESS;
/** 收货人 */
@property (nonatomic, copy) NSString *CONSIGNEE;
/** 省 */
@property (nonatomic, copy) NSString *PROVINCE;
/** honnouruserID */
@property (nonatomic, copy) NSString *HONOURUSER_ID;
/** addressID */
@property (nonatomic, copy) NSString *ADDRESS_ID;


@end
