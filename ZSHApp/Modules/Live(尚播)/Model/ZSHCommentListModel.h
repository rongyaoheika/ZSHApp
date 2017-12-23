//
//  ZSHCommentListModel.h
//  ZSHApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHCommentListModel : ZSHBaseModel

@property (nonatomic, copy) NSString *COMCONTENT;
@property (nonatomic, copy) NSString *PORTRAIT;
@property (nonatomic, copy) NSString *HONOURUSER_ID;
@property (nonatomic, copy) NSString *COMMENTTIME;
@property (nonatomic, copy) NSString *COMMENTNICKNAME;
@property (nonatomic, copy) NSString *REPLYNICKNAME;
@property (nonatomic, copy) NSString *CIRCLE_ID;
@property (nonatomic, copy) NSString *REPLYHONOURUSER_ID;
@property (nonatomic, copy) NSString *dotAgreeCount;
@property (nonatomic, copy) NSString *lossAgreeCount;
@property (nonatomic, copy) NSString *COMMENT_ID;

@property (nonatomic, assign) CGFloat  height;

@end
