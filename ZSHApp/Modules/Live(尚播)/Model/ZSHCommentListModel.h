//
//  ZSHCommentListModel.h
//  ZSHApp
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHCommentListModel : ZSHBaseModel

@property (nonatomic, strong) NSString *COMCONTENT;
@property (nonatomic, strong) NSString *PORTRAIT;
@property (nonatomic, strong) NSString *HONOURUSER_ID;
@property (nonatomic, strong) NSString *COMMENTTIME;

@property (nonatomic, assign) CGFloat  height;

@end
