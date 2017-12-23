//
//  ZSHReviewCell.h
//  ZSHApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseCell.h"
#import "ZSHCommentListModel.h"

@interface ZSHReviewCell : ZSHBaseCell

@property (nonatomic, strong) UIButton            *replyBtn;


//- (CGFloat)getCellHeightWithModel:(ZSHCommentListModel *)model;
+ (CGFloat)getCellHeightWithModel:(ZSHCommentListModel *)model;
@end
