//
//  ZSHEnterDisModel.h
//  ZSHApp
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHEnterDisModel : ZSHBaseModel

//NSDictionary *dic = @{@"STARTTIME":@"",
//@"ENDTIME":@"",
//@"PRICEMIN":@"",
//@"PRICEMAX":@"",
//@"CONVERGETYPE":@"",
//@"CONVERGEPER":@"",
//@"CONVERGESEX":@"",
//@"AGEMIN":@"",
//@"AGEMAX":@"",
//@"CONVERGEDET":@"",
//@"CONVERGETITLE":@"",
//@"HONOURUSER_ID":@""};

@property (nonatomic, copy) NSString *STARTTIME;
@property (nonatomic, copy) NSString *ENDTIME;
@property (nonatomic, copy) NSString *PRICEMIN;
@property (nonatomic, copy) NSString *PRICEMAX;
@property (nonatomic, copy) NSString *CONVERGETYPE;
@property (nonatomic, copy) NSString *CONVERGEPER;
@property (nonatomic, copy) NSString *CONVERGESEX;
@property (nonatomic, copy) NSString *AGEMIN;
@property (nonatomic, copy) NSString *AGEMAX;
@property (nonatomic, copy) NSString *CONVERGEDET;
@property (nonatomic, copy) NSString *CONVERGETITLE;
@property (nonatomic, copy) NSString *HONOURUSER_ID;


@end
