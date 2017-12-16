//
//  ZSHEnergyModel.h
//  ZSHApp
//
//  Created by apple on 2017/12/13.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"


@class ZSHEnergyCompListModel;

@interface ZSHEnergyModel : ZSHBaseModel

@property (nonatomic, copy) NSString *NAME;
@property (nonatomic, copy) NSString *INTRODUCE;
@property (nonatomic, copy) NSString *ENERGY_ID;
@property (nonatomic, copy) NSString *SCORE;

// compList
@property (nonatomic, copy) NSArray<ZSHEnergyCompListModel*>  *compList;



@end


@interface ZSHEnergyCompListModel : ZSHBaseModel

@property (nonatomic, copy) NSString *ENERGY_ID;
@property (nonatomic, copy) NSString *NAME;
@property (nonatomic, copy) NSString *SCORECOMPONENT_ID;
@property (nonatomic, copy) NSString *SCORE;

@end
