//
//  ZSHCardImgModel.h
//  ZSHApp
//
//  Created by apple on 2017/12/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHCardImgModel : ZSHBaseModel

@property (nonatomic, copy)   NSString *CARDTYPE;
@property (nonatomic, copy)   NSString *CARDTYPENAME;
@property (nonatomic, strong) NSArray  *CARDIMGS;
@property (nonatomic, copy)   NSString *CARDTYPE_ID;


@end
