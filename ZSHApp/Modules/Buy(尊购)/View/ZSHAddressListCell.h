//
//  ZSHAddressListCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/19.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
#import "ZSHAddrModel.h"

@interface ZSHAddressListCell : ZSHBaseCell


@property (nonatomic, strong) UILabel   *nameLabel;
@property (nonatomic, strong) UILabel   *addressLabel;
@property (nonatomic, strong) UILabel   *telLabel;
@property (nonatomic, strong) UIButton  *defaultBtn;
@property (nonatomic, strong) UIButton  *deleteBtn;
@property (nonatomic, strong) UIButton  *editBtn;

@end
