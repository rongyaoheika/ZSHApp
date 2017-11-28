//
//  ZSHShopCommentModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHShopCommentModel : ZSHBaseModel

@property (nonatomic, copy)  NSString   *PORTRAIT;           //头像
@property (nonatomic, copy)  NSString   *NICKNAME;           //昵称
@property (nonatomic, copy)  NSString   *EVALUATEDATE;       //时间
@property (nonatomic, copy)  NSString   *EVALUATECONTENT;    //评论
@property (nonatomic, assign)CGFloat    cellHeight;          //评论



@end
