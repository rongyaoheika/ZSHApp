//
//  ZSHTicketPlaceCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseView.h"

typedef void(^SaveBlock)(NSString *from,NSString *to);

@interface ZSHTicketPlaceCell :ZSHBaseView 


@property (nonatomic, copy) SaveBlock saveBlock;

@end
