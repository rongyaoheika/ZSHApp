//
//  ZSHHotelOrderModel.h
//  ZSHApp
//
//  Created by apple on 2017/12/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHHotelOrderModel : ZSHBaseModel

@property (nonatomic, copy) NSString *ORDERREMARK;
@property (nonatomic, copy) NSString *ORDERUNAME;
@property (nonatomic, copy) NSString *ORDERCHECKDATE;
@property (nonatomic, copy) NSString *ORDERPHONE;
@property (nonatomic, copy) NSString *ORDERROOMNUM;
@property (nonatomic, copy) NSString *ORDERLEAVEDATE;
@property (nonatomic, copy) NSString *ORDERNUMBER;
@property (nonatomic, copy) NSString *ORDERTIME;
@property (nonatomic, copy) NSString *ORDERDAYS;
@property (nonatomic, copy) NSString *ORDERSTATUS;
@property (nonatomic, copy) NSString *HONOURUSER_ID;
@property (nonatomic, copy) NSString *HOTELORDER_ID;
@property (nonatomic, copy) NSString *HOTELDETAIL_ID;
@property (nonatomic, copy) NSString *ORDERMONEY;
@property (nonatomic, copy) NSString *HOTELDETNAME;
@property (nonatomic, copy) NSString *SORTHOTEL_ID;
@property (nonatomic, copy) NSString *SHOWIMAGES;
//HOTELORDER_ID = e4899e9777f447a9b6419abbbf47b81f;
//HOTELDETAIL_ID = 53b4f3c1dfa84ee697469ce762c400c5;
//HOTELDETNAME = 豪华双人间;
//ORDERMONEY = 444;
//SORTHOTEL_ID = 53443f6feed94a1bbce17a65e63dae28;
//HONOURUSER_ID = d6a3779de8204dfd9359403f54f7d27c;
//ORDERSTATUS = 0040001;
//SHOWIMAGES = http://47.104.16.215:8088/sortimgs/sorthotelimgs/sorthotelshowimgs/f849b0edd3264537992a11fd9b093e81.png;
//}

@end
