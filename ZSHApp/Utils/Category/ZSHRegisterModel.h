//
//  ZSHRegister.h
//  ZSHApp
//
//  Created by apple on 2017/12/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHRegisterModel : ZSHBaseModel

@property (nonatomic, copy) NSString *CARDNO;
@property (nonatomic, copy) NSString *PHONE;
@property (nonatomic, copy) NSString *REALNAME;
@property (nonatomic, copy) NSString *PROVINCE;
@property (nonatomic, copy) NSString *ADDRESS;
@property (nonatomic, copy) NSString *CUSTOM;
@property (nonatomic, copy) NSString *CUSTOMCONTENT;


@end
