//
//  ZSHPersonalModel.h
//  ZSHApp
//
//  Created by apple on 2017/11/25.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHPersonalModel : ZSHBaseModel

@property (nonatomic, strong) NSString *IMGENCHAR;
@property (nonatomic, strong) NSString *IMGSCNCHAR;
@property (nonatomic, strong) NSString *PERSONALIMGS;
@property (nonatomic, strong) NSString *PERSONALTYPE;
@property (nonatomic, strong) NSString *PERSONAL_ID;

//{
//    IMGENCHAR = "GIEVES&HAWKES";
//    IMGSCNCHAR = "\U82f1\U56fd\U7687\U5bb6\U7ec5\U58eb\U54c1\U724c";
//    PERSONALIMGS = "http://47.104.16.215:8088/personalimgs/personalimg/ddbed16daf194e1aa39b924ef4793b19.png";
//    PERSONALTYPE = "\U670d\U9970";
//    "PERSONAL_ID" = 26ce9cfadff44e9fa46aa7cab98a677c;
//},

@end
