//
//  ZSHBaseCell.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/8/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSHBaseModel.h"

@interface ZSHBaseCell : UITableViewCell

@property (nonatomic, strong) ZSHBaseModel *model;
@property (nonatomic, strong) NSDictionary *paramDic;
@property (nonatomic, copy) NSString       *arrowImageName;


//加载cell  控件
- (void)setup;

//更新cell内容
- (void)updateCellWithParamDic:(NSDictionary *)dic;
- (void)updateCellWithModel:(ZSHBaseModel *)model;

//获取cell高度
+ (CGFloat)getCellHeightWithModel:(ZSHBaseModel *)model;

//获取cell高度
-(CGFloat)rowHeightWithCellModel:(ZSHBaseModel *)model;
@end
