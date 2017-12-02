//
//  ZSHHotelOrderModel.h
//  ZSHApp
//
//  Created by apple on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"


//酒店
@interface ZSHHotelOrderModel : ZSHBaseModel

@property (nonatomic, copy) NSString *ORDERSTATUS;
@property (nonatomic, copy) NSString *HONOURUSER_ID;
@property (nonatomic, copy) NSString *HOTELORDER_ID;
@property (nonatomic, copy) NSString *HOTELDETAIL_ID;
@property (nonatomic, copy) NSString *ORDERMONEY;
@property (nonatomic, copy) NSString *HOTELDETNAME;
@property (nonatomic, copy) NSString *SORTHOTEL_ID;
@property (nonatomic, copy) NSString *SHOWIMAGES;

@end


// KTV
@interface ZSHKtvOrderModel : ZSHBaseModel

@property (nonatomic, copy) NSString *KTVORDER_ID;
@property (nonatomic, copy) NSString *ORDERMONEY;
@property (nonatomic, copy) NSString *KTVDETAIL_ID;
@property (nonatomic, copy) NSString *SORTKTV_ID;
@property (nonatomic, copy) NSString *ORDERSTATUS;
@property (nonatomic, copy) NSString *SHOWIMAGES;
@property (nonatomic, copy) NSString *HONOURUSER_ID;
@property (nonatomic, copy) NSString *KTVDETTITLE;


@end


// 酒吧
@interface ZSHBarorderOrderModel : ZSHBaseModel

@property (nonatomic, copy) NSString *BARORDER_ID;
@property (nonatomic, copy) NSString *BARDETAIL_ID;
@property (nonatomic, copy) NSString *SORTBAR_ID;
@property (nonatomic, copy) NSString *ORDERMONEY;
@property (nonatomic, copy) NSString *HONOURUSER_ID;
@property (nonatomic, copy) NSString *BARDETTITLE;
@property (nonatomic, copy) NSString *SHOWIMAGES;
@property (nonatomic, copy) NSString *ORDERSTATUS;


@end
