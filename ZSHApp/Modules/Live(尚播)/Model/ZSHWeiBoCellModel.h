//
//  ZSHWeiBoModel.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/16.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHBaseModel.h"

@interface ZSHWeiBoCellModel : ZSHBaseModel

@property (nonatomic,copy)  NSString *avatarPicture;
@property (nonatomic,copy)  NSString *name;
@property (nonatomic,copy)  NSString *detailText;
@property (nonatomic,copy)  NSString *detailPicture;

//子控件的可变frame（根据内容显示不同，frame变化）
//@property (nonatomic,assign)  CGRect  avatarFrame;
//@property (nonatomic,assign)  CGRect  nameLabelFrame;
//@property (nonatomic,assign)  CGRect  vipFrame;
//@property (nonatomic,assign)  CGRect  detailLabelFrame;
//@property (nonatomic,assign)  CGRect  detailPictureFrame;
//@property (nonatomic,assign)  CGFloat rowHeight;

+(instancetype)modelWithDict:(NSDictionary *)dict;
-(void)updateRowHeight;

@end
