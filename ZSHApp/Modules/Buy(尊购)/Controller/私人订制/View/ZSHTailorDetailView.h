//
//  ZSHTailorDetailTableViewCell.h
//  ZSHApp
//
//  Created by Apple on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
#import "ZSHPersonalDetailModel.h"

@interface ZSHTailorDetailView : ZSHBaseCell

+ (CGFloat)updateCellHeightWithModel:(ZSHPersonalDetailModel *)model;
@end
